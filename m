Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbaD2LYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:24:07 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61702 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbaD2LTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:19:11 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH 02/15] ASoC: davinci: add dependencies for SND_SOC_TLV320AIC3X
Date: Tue, 29 Apr 2014 19:18:23 +0800
Message-Id: <1398770316-19715-3-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This codec requires I2C to be enabled, so any other option
that selects it should also depend on I2C.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/davinci/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/davinci/Kconfig b/sound/soc/davinci/Kconfig
index a8ec1fc..50a0987 100644
--- a/sound/soc/davinci/Kconfig
+++ b/sound/soc/davinci/Kconfig
@@ -18,7 +18,7 @@ config SND_DAVINCI_SOC_GENERIC_EVM
 
 config SND_AM33XX_SOC_EVM
 	tristate "SoC Audio for the AM33XX chip based boards"
-	depends on SND_DAVINCI_SOC && SOC_AM33XX
+	depends on SND_DAVINCI_SOC && SOC_AM33XX && I2C
 	select SND_DAVINCI_SOC_GENERIC_EVM
 	help
 	  Say Y or M if you want to add support for SoC audio on AM33XX
@@ -28,7 +28,7 @@ config SND_AM33XX_SOC_EVM
 
 config SND_DAVINCI_SOC_EVM
 	tristate "SoC Audio support for DaVinci DM6446, DM355 or DM365 EVM"
-	depends on SND_DAVINCI_SOC
+	depends on SND_DAVINCI_SOC && I2C
 	depends on MACH_DAVINCI_EVM || MACH_DAVINCI_DM355_EVM || MACH_DAVINCI_DM365_EVM
 	select SND_DAVINCI_SOC_GENERIC_EVM
 	help
@@ -56,7 +56,7 @@ endchoice
 
 config  SND_DM6467_SOC_EVM
 	tristate "SoC Audio support for DaVinci DM6467 EVM"
-	depends on SND_DAVINCI_SOC && MACH_DAVINCI_DM6467_EVM
+	depends on SND_DAVINCI_SOC && MACH_DAVINCI_DM6467_EVM && I2C
 	select SND_DAVINCI_SOC_GENERIC_EVM
 	select SND_SOC_SPDIF
 
@@ -65,7 +65,7 @@ config  SND_DM6467_SOC_EVM
 
 config  SND_DA830_SOC_EVM
 	tristate "SoC Audio support for DA830/OMAP-L137 EVM"
-	depends on SND_DAVINCI_SOC && MACH_DAVINCI_DA830_EVM
+	depends on SND_DAVINCI_SOC && MACH_DAVINCI_DA830_EVM && I2C
 	select SND_DAVINCI_SOC_GENERIC_EVM
 
 	help
@@ -74,7 +74,7 @@ config  SND_DA830_SOC_EVM
 
 config  SND_DA850_SOC_EVM
 	tristate "SoC Audio support for DA850/OMAP-L138 EVM"
-	depends on SND_DAVINCI_SOC && MACH_DAVINCI_DA850_EVM
+	depends on SND_DAVINCI_SOC && MACH_DAVINCI_DA850_EVM && I2C
 	select SND_DAVINCI_SOC_GENERIC_EVM
 	help
 	  Say Y if you want to add support for SoC audio on TI
-- 
1.7.9.5

