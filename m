Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaKUSf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:35:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35785 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaKUSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:35:25 -0500
From: Andreas Ruprecht <rupran@einserver.de>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] ASoC: rockchip: i2s: Add dependency to I2S device driver
Date: Fri, 21 Nov 2014 19:35:13 +0100
Message-Id: <1416594913-30187-1-git-send-email-rupran@einserver.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, CONFIG_SND_SOC_ROCKCHIP_I2S could also be selected
without having CONFIG_SND_SOC_ROCKCHIP enabled.

As this makes no sense (and breaks the build, when the option
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM - which would be selected by
CONFIG_SND_SOC_ROCKCHIP - is not enabled), a Kconfig dependency
is added to CONFIG_SND_SOC_ROCKCHIP_I2S. This will make the item
visible only if CONFIG_SND_SOC_ROCKCHIP is enabled.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
Reported-by: Jim Davis <jim.epost@gmail.com>
---
 sound/soc/rockchip/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index b1fc0ca..74380b4 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -9,7 +9,7 @@ config SND_SOC_ROCKCHIP
 
 config SND_SOC_ROCKCHIP_I2S
 	tristate "Rockchip I2S Device Driver"
-	depends on CLKDEV_LOOKUP
+	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
 	help
 	  Say Y or M if you want to add support for I2S driver for
 	  Rockchip I2S device. The device supports upto maximum of
-- 
1.9.1

