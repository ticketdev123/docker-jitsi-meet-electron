FROM debian:stretch

RUN apt-get update && apt-get install -y \
    apt-utils \
    software-properties-common \
    wget \
    curl \
    --no-install-recommends

# Jitsi meet download
RUN wget https://github.com/jitsi/jitsi-meet-electron/releases/latest/download/jitsi-meet-amd64.deb -O /tmp/jitsi-meet-amd64.deb

# Make a user
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
        && chown -R user:user $HOME \
        && usermod -a -G audio,video user

# Install required deps
RUN apt-get update && apt-get install -y \
    dbus-x11 \
    dunst \
    hunspell-en-us \
    python3-dbus \
    libx11-xcb1 \
    libpulse0 \
    gconf2 \
    libdrm2 \
    libice6 \
    libsm6 \
    libegl1-mesa-dev \
    libgl1-mesa-glx \
    libasound2 \
    libgbm-dev \
    libxshmfence-dev \
    libx11-dev \
    zlib1g-dev \
    libpng-dev \
    libxtst-dev \
    --no-install-recommends


RUN  apt-get install -y --no-install-recommends  \
    /tmp/jitsi-meet-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $HOME
USER user

ENV QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

# Autorun Jitsi Meet
CMD /opt/Jitsi\ Meet/jitsi-meet.bin --no-sandbox --disable-dev-shm-usage
