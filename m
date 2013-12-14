Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3LNNDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:03:23 -0500
Received: from smtp27.mail.ru ([94.100.176.180]:46405 "EHLO smtp27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3LNNDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:03:21 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/3] mfd: mc13xxx: Remove useless symbol MFD_MC13783
Date: Sat, 14 Dec 2013 17:03:10 +0400
Message-Id: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symbol MFD_MC13783 always selected by MFD_MC13XXX, so no need
to keep additional symbol.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/input/misc/Kconfig        | 2 +-
 drivers/input/touchscreen/Kconfig | 2 +-
 drivers/mfd/Kconfig               | 4 ----
 drivers/regulator/Kconfig         | 2 +-
 sound/soc/fsl/Kconfig             | 2 +-
 5 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 4ffc397..7904ab0 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -168,7 +168,7 @@ config INPUT_MAX8997_HAPTIC
 
 config INPUT_MC13783_PWRBUTTON
 	tristate "MC13783 ON buttons"
-	depends on MFD_MC13783
+	depends on MFD_MC13XXX
 	help
 	  Support the ON buttons of MC13783 PMIC as an input device
 	  reporting power button status.
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 961d58d..07e9e82 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -717,7 +717,7 @@ config TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_MC13783
 	tristate "Freescale MC13783 touchscreen input driver"
-	depends on MFD_MC13783
+	depends on MFD_MC13XXX
 	help
 	  Say Y here if you have an Freescale MC13783 PMIC on your
 	  board and want to use its touchscreen
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 58ed055..49bb445 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -163,14 +163,10 @@ config MFD_DA9063
 	  Additional drivers must be enabled in order to use the functionality
 	  of the device.
 
-config MFD_MC13783
-	tristate
-
 config MFD_MC13XXX
 	tristate
 	depends on (SPI_MASTER || I2C)
 	select MFD_CORE
-	select MFD_MC13783
 	help
 	  Enable support for the Freescale MC13783 and MC13892 PMICs.
 	  This driver provides common support for accessing the device,
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index ce785f4..db9ae6f 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -343,7 +343,7 @@ config REGULATOR_MC13XXX_CORE
 
 config REGULATOR_MC13783
 	tristate "Freescale MC13783 regulator driver"
-	depends on MFD_MC13783
+	depends on MFD_MC13XXX
 	select REGULATOR_MC13XXX_CORE
 	help
 	  Say y here to support the regulators found on the Freescale MC13783
diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index b7ab71f..5b44c5c 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -206,7 +206,7 @@ config SND_SOC_IMX_SPDIF
 
 config SND_SOC_IMX_MC13783
 	tristate "SoC Audio support for I.MX boards with mc13783"
-	depends on MFD_MC13783 && ARM
+	depends on MFD_MC13XXX && ARM
 	select SND_SOC_IMX_SSI
 	select SND_SOC_IMX_AUDMUX
 	select SND_SOC_MC13783
-- 
1.8.3.2

