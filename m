Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaLOCMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:12:23 -0500
Received: from regular2.263xmail.com ([211.157.152.3]:58911 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaLOCMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:12:15 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-FST-TO: ykk@rock-chips.com
X-SENDER-IP: 104.167.231.7
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <4c7d05ac89f962764159f91c33226d24>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yakir Yang <ykk@rock-chips.com>
To: Yakir Yang <ykk@rock-chips.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>, alsa-devel@alsa-project.org,
        Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, David Airlie <airlied@linux.ie>,
        Sean Cross <xobs@kosagi.com>, Grant Likely <grant.likely@linaro.org>,
        linux-rockchip@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Zhang <benzh@chromium.org>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Mark Rutland <mark.rutland@arm.com>, Jyri Sarha <jsarha@ti.com>
Subject: [RFC PATCH 0/6] Those patches is used for dw_hdmi audio.
Date: Mon, 15 Dec 2014 10:11:28 +0800
Message-Id: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rk3288 use Designware HDMI IP, Designware HDMI supports four interfaces to
config hdmi audio(I2S, S/PDIF, Generic Parallel Audio, AHB Audio DMA), but
rk3288 only support two ways to config hdmi audio(I2S, S/PDIF), So we take
I2S as hdmi audio operation interfaces, and then treat hdmi audio as an
standard ALSA devices(only got platback function).

Four things we have done:
1. modify the audio part of dw_hdmi drivers for rk3288 platform specific.
2. add codec driver for hdmi audio, and creat codec device dynamically in
   hdmi driver probe function, using platform_register_device_full way, so
   that hdmi codec driver can connected with hdmi driver.
3. add sound driver for hdmi audio, creat hdmi audio sound card.
4. add dt-bings file and add hdmi_audio node to corresponding dt file.

[Explanation]:
those patch is depend on patch by Andy Yan
drm: bridge/dw_hdmi: add rockchip rk3288 support
see https://patchwork.kernel.org/patch/5442361/


Yakir Yang (6):
  drm: bridge/dw_hdmi: add hdmi audio config interfaces
  drm: bridge/bridge: add support for rk3288 hdmi-audio
  ASoC: dw-hdmi-audio: add codec driver for dw hdmi audio
  ASoC: rockchip-hdmi-audio: add sound driver for hdmi audio
  dt-bindings: Add documentation for Rockchip hdmi-audio
  ARM: dts: rockchip: add hdmi audio nodes

 .../sound/rockchip,rockchip-hdmi-audio.txt         |  16 +
 arch/arm/boot/dts/rk3288-evb.dtsi                  |  11 +
 arch/arm/boot/dts/rk3288.dtsi                      |   8 +
 drivers/gpu/drm/bridge/dw_hdmi.c                   |  32 +-
 include/drm/bridge/dw_hdmi.h                       |  12 +
 sound/soc/codecs/Kconfig                           |   4 +
 sound/soc/codecs/Makefile                          |   2 +
 sound/soc/codecs/dw-hdmi-audio.c                   | 371 +++++++++++++++++++++
 sound/soc/codecs/dw-hdmi-audio.h                   |  82 +++++
 sound/soc/rockchip/Kconfig                         |   9 +
 sound/soc/rockchip/Makefile                        |   2 +
 sound/soc/rockchip/rockchip_hdmi_audio.c           | 208 ++++++++++++
 12 files changed, 756 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip,rockchip-hdmi-audio.txt
 create mode 100644 sound/soc/codecs/dw-hdmi-audio.c
 create mode 100644 sound/soc/codecs/dw-hdmi-audio.h
 create mode 100644 sound/soc/rockchip/rockchip_hdmi_audio.c

-- 
2.1.2


