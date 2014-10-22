Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaJVDAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 23:00:16 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:56102 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaJVDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 23:00:14 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <afeded244751253b52098eade3a3e7e6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH v3] ASoC: rockchip-i2s: add MAX98090 support to Kconfig
Date: Wed, 22 Oct 2014 10:59:59 +0800
Message-Id: <1413946799-20834-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
References: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SND_SOC_MAX98090 to Kconfig of rockchip ASoC, to support
rockchip board using a max98090 codec.

Tested on rockchip board based on rk3288.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
changes since v1:
--make the max98090 driver directly selectable, suggested by Lars

changes since v2:
--modify tristate infomation for SND_SOC_ROCKCHIP
--make SND_SOC_MAX98090 not depends on SND_SOC_ROCKCHIP

 sound/soc/rockchip/Kconfig | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index 78fc159..236500e 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -1,5 +1,5 @@
 config SND_SOC_ROCKCHIP
-	tristate "ASoC support for Rockchip"
+	tristate "SoC Audio for the Rockchip System-on-Chip"
 	depends on COMPILE_TEST || ARCH_ROCKCHIP
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
@@ -8,4 +8,14 @@ config SND_SOC_ROCKCHIP
 	  select the audio interfaces to support below.
 
 config SND_SOC_ROCKCHIP_I2S
-	tristate
+	tristate "ASoC support for Rockchip I2S driver"
+	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
+	help
+	  Say Y or M if you want to add support for I2S driver for Rockchip
+	  I2S device.
+
+config SND_SOC_MAX98090
+	tristate "ASoC support for max98090 driver"
+	depends on I2C && GPIOLIB
+	help
+	  Say Y or M here if you want to add support for max98090 codec.
-- 
1.9.1


