Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaAPPBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:01:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47105 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaAPPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:01:37 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: <linux-arm-kernel@lists.infradead.org>, linux-pwm@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] pwm: Remove obsolete HAVE_PWM Kconfig symbol
Date: Thu, 16 Jan 2014 16:01:34 +0100
Message-Id: <1389884494-13729-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.5.2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we had the PWM framework we used to have a barebone PWM api. The
HAVE_PWM Kconfig symbol used to be selected by the PWM drivers to specify
the PWM API is present in the kernel. Since the last legacy driver is gone
the HAVE_PWM symbol can go aswell.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

I suggest that Thierry as PWM Maintainer takes the patch through his tree.
Is that ok for you Thierry?

 arch/arm/Kconfig           |  4 ----
 arch/arm/mach-pxa/Kconfig  | 15 ---------------
 arch/mips/Kconfig          |  1 -
 drivers/input/misc/Kconfig |  4 ++--
 include/linux/pwm.h        |  2 +-
 5 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..1b6f499 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -109,9 +109,6 @@ config ARM_DMA_IOMMU_ALIGNMENT
 
 endif
 
-config HAVE_PWM
-	bool
-
 config MIGHT_HAVE_PCI
 	bool
 
@@ -606,7 +603,6 @@ config ARCH_LPC32XX
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
 	select HAVE_IDE
-	select HAVE_PWM
 	select USB_ARCH_HAS_OHCI
 	select USE_OF
 	help
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 96100db..b96244c 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -7,7 +7,6 @@ comment "Intel/Marvell Dev Platforms (sorted by hardware release time)"
 config MACH_PXA3XX_DT
 	bool "Support PXA3xx platforms from device tree"
 	select CPU_PXA300
-	select HAVE_PWM
 	select POWER_SUPPLY
 	select PXA3xx
 	select USE_OF
@@ -23,12 +22,10 @@ config ARCH_LUBBOCK
 
 config MACH_MAINSTONE
 	bool "Intel HCDDBBVA0 Development Platform (aka Mainstone)"
-	select HAVE_PWM
 	select PXA27x
 
 config MACH_ZYLONITE
 	bool
-	select HAVE_PWM
 	select PXA3xx
 
 config MACH_ZYLONITE300
@@ -69,7 +66,6 @@ config ARCH_PXA_IDP
 config ARCH_VIPER
 	bool "Arcom/Eurotech VIPER SBC"
 	select ARCOM_PCMCIA
-	select HAVE_PWM
 	select I2C_GPIO
 	select ISA
 	select PXA25x
@@ -120,7 +116,6 @@ config MACH_CM_X300
 	bool "CompuLab CM-X300 modules"
 	select CPU_PXA300
 	select CPU_PXA310
-	select HAVE_PWM
 	select PXA3xx
 
 config MACH_CAPC7117
@@ -211,7 +206,6 @@ config TRIZEPS_PCMCIA
 
 config MACH_LOGICPD_PXA270
 	bool "LogicPD PXA270 Card Engine Development Platform"
-	select HAVE_PWM
 	select PXA27x
 
 config MACH_PCM027
@@ -222,7 +216,6 @@ config MACH_PCM027
 config MACH_PCM990_BASEBOARD
 	bool "PHYTEC PCM-990 development board"
 	depends on MACH_PCM027
-	select HAVE_PWM
 
 choice
 	prompt "display on pcm990"
@@ -246,7 +239,6 @@ config MACH_COLIBRI
 config MACH_COLIBRI_PXA270_INCOME
 	bool "Income s.r.o. PXA270 SBC"
 	depends on MACH_COLIBRI
-	select HAVE_PWM
 	select PXA27x
 
 config MACH_COLIBRI300
@@ -275,7 +267,6 @@ comment "End-user Products (sorted by vendor name)"
 
 config MACH_H4700
 	bool "HP iPAQ hx4700"
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 
@@ -289,14 +280,12 @@ config MACH_HIMALAYA
 
 config MACH_MAGICIAN
 	bool "Enable HTC Magician Support"
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 
 config MACH_MIOA701
 	bool "Mitac Mio A701 Support"
 	select GPIO_SYSFS
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 	help
@@ -306,7 +295,6 @@ config MACH_MIOA701
 
 config PXA_EZX
 	bool "Motorola EZX Platform"
-	select HAVE_PWM
 	select IWMMXT
 	select PXA27x
 
@@ -346,7 +334,6 @@ config MACH_MP900C
 
 config ARCH_PXA_PALM
 	bool "PXA based Palm PDAs"
-	select HAVE_PWM
 
 config MACH_PALM27X
 	bool
@@ -444,7 +431,6 @@ config MACH_TREO680
 config MACH_RAUMFELD_RC
 	bool "Raumfeld Controller"
 	select CPU_PXA300
-	select HAVE_PWM
 	select POWER_SUPPLY
 	select PXA3xx
 
@@ -608,7 +594,6 @@ config MACH_E800
 
 config MACH_ZIPIT2
 	bool "Zipit Z2 Handheld"
-	select HAVE_PWM
 	select PXA27x
 endmenu
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 650de39..ce62af8 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -233,7 +233,6 @@ config MACH_JZ4740
 	select IRQ_CPU
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_HAS_EARLY_PRINTK
-	select HAVE_PWM
 	select HAVE_CLK
 	select GENERIC_IRQ_CHIP
 
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 5f4967d..bc6ec8e 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -156,7 +156,7 @@ config INPUT_MAX8925_ONKEY
 
 config INPUT_MAX8997_HAPTIC
 	tristate "MAXIM MAX8997 haptic controller support"
-	depends on PWM && HAVE_PWM && MFD_MAX8997
+	depends on PWM && MFD_MAX8997
 	select INPUT_FF_MEMLESS
 	help
 	  This option enables device driver support for the haptic controller
@@ -461,7 +461,7 @@ config INPUT_PCF8574
 
 config INPUT_PWM_BEEPER
 	tristate "PWM beeper support"
-	depends on PWM && HAVE_PWM
+	depends on PWM
 	help
 	  Say Y here to get support for PWM based beeper devices.
 
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index f0feafd..4717f54 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -7,7 +7,7 @@
 struct pwm_device;
 struct seq_file;
 
-#if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
+#if IS_ENABLED(CONFIG_PWM)
 /*
  * pwm_request - request a PWM device
  */
-- 
1.8.5.2

