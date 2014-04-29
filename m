Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaD2LTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:19:13 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59724 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbaD2LTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:19:09 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Timur Tabi <timur@tabi.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs depend on INPUT
Date: Tue, 29 Apr 2014 19:18:22 +0800
Message-Id: <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building ARM randconfig got into a situation where CONFIG_INPUT
is turned off and SND_SOC_ALL_CODECS is turned on, which failed
for two codecs trying to use the input subsystem. Some other 
drivers also select one of these codecs and consequently need an
explicit dependency added. 

Appending to the dependency list seems the easiest way out,
since this is not a practical limitation. If anyone really
needs to build these codecs for a kernel with no input support,
a more sophisticated solution can be implemented.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Timur Tabi <timur@tabi.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-input@vger.kernel.org
Cc: alsa-devel@alsa-project.org
---
 sound/soc/codecs/Kconfig  |    8 ++++----
 sound/soc/fsl/Kconfig     |    2 +-
 sound/soc/samsung/Kconfig |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index f0e8401..d4260d3 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -40,7 +40,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_ALC5632 if I2C
 	select SND_SOC_CQ0093VC if MFD_DAVINCI_VOICECODEC
 	select SND_SOC_CS42L51 if I2C
-	select SND_SOC_CS42L52 if I2C
+	select SND_SOC_CS42L52 if I2C && INPUT
 	select SND_SOC_CS42L73 if I2C
 	select SND_SOC_CS4270 if I2C
 	select SND_SOC_CS4271 if SND_SOC_I2C_AND_SPI
@@ -127,7 +127,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_WM8955 if I2C
 	select SND_SOC_WM8960 if I2C
 	select SND_SOC_WM8961 if I2C
-	select SND_SOC_WM8962 if I2C
+	select SND_SOC_WM8962 if I2C && INPUT
 	select SND_SOC_WM8971 if I2C
 	select SND_SOC_WM8974 if I2C
 	select SND_SOC_WM8978 if I2C
@@ -282,7 +282,7 @@ config SND_SOC_CS42L51
 
 config SND_SOC_CS42L52
 	tristate "Cirrus Logic CS42L52 CODEC"
-	depends on I2C
+	depends on I2C && INPUT
 
 config SND_SOC_CS42L73
 	tristate "Cirrus Logic CS42L73 CODEC"
@@ -598,7 +598,7 @@ config SND_SOC_WM8961
 
 config SND_SOC_WM8962
 	tristate "Wolfson Microelectronics WM8962 CODEC"
-	depends on I2C
+	depends on I2C && INPUT
 
 config SND_SOC_WM8971
 	tristate
diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 338a916..f4069d0 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -187,7 +187,7 @@ config SND_SOC_EUKREA_TLV320
 
 config SND_SOC_IMX_WM8962
 	tristate "SoC Audio support for i.MX boards with wm8962"
-	depends on OF && I2C
+	depends on OF && I2C && INPUT
 	select SND_SOC_WM8962
 	select SND_SOC_IMX_PCM_DMA
 	select SND_SOC_IMX_AUDMUX
diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index f2e2891..14568be 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -204,7 +204,7 @@ config SND_SOC_SPEYSIDE
 
 config SND_SOC_TOBERMORY
 	tristate "Audio support for Wolfson Tobermory"
-	depends on SND_SOC_SAMSUNG && MACH_WLF_CRAGG_6410
+	depends on SND_SOC_SAMSUNG && MACH_WLF_CRAGG_6410 && INPUT
 	select SND_SAMSUNG_I2S
 	select SND_SOC_WM8962
 
-- 
1.7.9.5

