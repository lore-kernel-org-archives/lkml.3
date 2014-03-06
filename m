Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaCFKFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:05:08 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54685 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaCFKE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:04:59 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 2/2] ASoC: update Kconfig of AIC23 users to select I2C variant
Date: Thu,  6 Mar 2014 14:04:42 +0400
Message-Id: <1394100282-27404-3-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394100282-27404-1-git-send-email-jcmvbkbc@gmail.com>
References: <1394100282-27404-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that AIC23 supports two control interfaces all existing I2C users
should select I2C variant.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
Changes v1->v2:
- new patch.

 sound/soc/atmel/Kconfig   | 2 +-
 sound/soc/cirrus/Kconfig  | 2 +-
 sound/soc/fsl/Kconfig     | 2 +-
 sound/soc/omap/Kconfig    | 4 ++--
 sound/soc/samsung/Kconfig | 2 +-
 sound/soc/tegra/Kconfig   | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index e634eb7..4789619 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -58,6 +58,6 @@ config SND_AT91_SOC_AFEB9260
 	depends on ARCH_AT91 && ATMEL_SSC && ARCH_AT91 && MACH_AFEB9260 && SND_ATMEL_SOC
 	select SND_ATMEL_SOC_PDC
 	select SND_ATMEL_SOC_SSC
-	select SND_SOC_TLV320AIC23
+	select SND_SOC_TLV320AIC23_I2C
 	help
 	  Say Y here to support sound on AFEB9260 board.
diff --git a/sound/soc/cirrus/Kconfig b/sound/soc/cirrus/Kconfig
index 06f938d..a0bf4a6 100644
--- a/sound/soc/cirrus/Kconfig
+++ b/sound/soc/cirrus/Kconfig
@@ -18,7 +18,7 @@ config SND_EP93XX_SOC_SNAPPERCL15
         tristate "SoC Audio support for Bluewater Systems Snapper CL15 module"
         depends on SND_EP93XX_SOC && MACH_SNAPPER_CL15
         select SND_EP93XX_SOC_I2S
-        select SND_SOC_TLV320AIC23
+        select SND_SOC_TLV320AIC23_I2C
         help
           Say Y or M here if you want to add support for I2S audio on the
           Bluewater Systems Snapper CL15 module.
diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 07f8f14..19a18a4 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -170,7 +170,7 @@ config SND_SOC_EUKREA_TLV320
 		|| MACH_EUKREA_MBIMXSD35_BASEBOARD \
 		|| MACH_EUKREA_MBIMXSD51_BASEBOARD
 	depends on I2C
-	select SND_SOC_TLV320AIC23
+	select SND_SOC_TLV320AIC23_I2C
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
 	select SND_SOC_IMX_SSI
diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index 22ad9c5..e006593 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -58,7 +58,7 @@ config SND_OMAP_SOC_OSK5912
 	tristate "SoC Audio support for omap osk5912"
 	depends on SND_OMAP_SOC && MACH_OMAP_OSK && I2C
 	select SND_OMAP_SOC_MCBSP
-	select SND_SOC_TLV320AIC23
+	select SND_SOC_TLV320AIC23_I2C
 	help
 	  Say Y if you want to add support for SoC audio on osk5912.
 
@@ -66,7 +66,7 @@ config SND_OMAP_SOC_AM3517EVM
 	tristate "SoC Audio support for OMAP3517 / AM3517 EVM"
 	depends on SND_OMAP_SOC && MACH_OMAP3517EVM && I2C
 	select SND_OMAP_SOC_MCBSP
-	select SND_SOC_TLV320AIC23
+	select SND_SOC_TLV320AIC23_I2C
 	help
 	  Say Y if you want to add support for SoC audio on the OMAP3517 / AM3517
 	  EVM.
diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 3507574..f2e2891 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -117,7 +117,7 @@ config SND_SOC_SAMSUNG_SIMTEC_TLV320AIC23
 	tristate "SoC I2S Audio support for TLV320AIC23 on Simtec boards"
 	depends on SND_SOC_SAMSUNG && ARCH_S3C24XX
 	select SND_S3C24XX_I2S
-	select SND_SOC_TLV320AIC23
+	select SND_SOC_TLV320AIC23_I2C
 	select SND_SOC_SAMSUNG_SIMTEC
 
 config SND_SOC_SAMSUNG_SIMTEC_HERMES
diff --git a/sound/soc/tegra/Kconfig b/sound/soc/tegra/Kconfig
index 9f9c185..31198cf7 100644
--- a/sound/soc/tegra/Kconfig
+++ b/sound/soc/tegra/Kconfig
@@ -105,7 +105,7 @@ config SND_SOC_TEGRA_TRIMSLICE
 	tristate "SoC Audio support for TrimSlice board"
 	depends on SND_SOC_TEGRA && I2C
 	select SND_SOC_TEGRA20_I2S if ARCH_TEGRA_2x_SOC
-	select SND_SOC_TLV320AIC23
+	select SND_SOC_TLV320AIC23_I2C
 	help
 	  Say Y or M here if you want to add support for SoC audio on the
 	  TrimSlice platform.
-- 
1.8.1.4

