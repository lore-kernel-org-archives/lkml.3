Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaIMAkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:40:46 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:49179 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaIMAkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:40:45 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <7dc6ca7e9f770432245069f0b1cba52d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 1/5] ASoC: rockchip-i2s: fix rockchip i2s defination more reasonable
Date: Sat, 13 Sep 2014 08:40:19 +0800
Message-Id: <1410568819-21671-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix SND_ROCKCHIP_I2S to be more reasonable - SND_SOC_ROCKCHIP_I2S,
SND_SOC_ROCKCHIP_I2S should select by audio driver, instead of
SND_SOC_ROCKCHIP.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/Kconfig  | 3 +--
 sound/soc/rockchip/Makefile | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index c196a46..78fc159 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -2,11 +2,10 @@ config SND_SOC_ROCKCHIP
 	tristate "ASoC support for Rockchip"
 	depends on COMPILE_TEST || ARCH_ROCKCHIP
 	select SND_SOC_GENERIC_DMAENGINE_PCM
-	select SND_ROCKCHIP_I2S
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the Rockchip SoCs' Audio interfaces. You will also need to
 	  select the audio interfaces to support below.
 
-config SND_ROCKCHIP_I2S
+config SND_SOC_ROCKCHIP_I2S
 	tristate
diff --git a/sound/soc/rockchip/Makefile b/sound/soc/rockchip/Makefile
index 1006418..b921909 100644
--- a/sound/soc/rockchip/Makefile
+++ b/sound/soc/rockchip/Makefile
@@ -1,4 +1,4 @@
 # ROCKCHIP Platform Support
 snd-soc-i2s-objs := rockchip_i2s.o
 
-obj-$(CONFIG_SND_ROCKCHIP_I2S) += snd-soc-i2s.o
+obj-$(CONFIG_SND_SOC_ROCKCHIP_I2S) += snd-soc-i2s.o
-- 
1.9.1


