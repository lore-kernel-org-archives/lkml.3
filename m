Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3BFQYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:19 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:36921 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab3BFQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:14 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 03/15] drivers/mfd: add missing GENERIC_HARDIRQS dependecies
Date: Wed,  6 Feb 2013 17:23:51 +0100
Message-Id: <1360167843-3587-4-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-5024-0000-0000-00000523C1AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of mfd drivers select MFD_CORE which however depends on
GENERIC_HARDIRQS support.
So add the missing dependency to all drivers to get rid of
this link error:

ERROR: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/mfd/Kconfig |   72 +++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ff553ba..671f5b1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -65,7 +65,7 @@ config MFD_SM501_GPIO
 
 config MFD_RTSX_PCI
 	tristate "Support for Realtek PCI-E card reader"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  This supports for Realtek PCI-Express card reader including rts5209,
@@ -95,7 +95,7 @@ config MFD_DM355EVM_MSP
 
 config MFD_TI_SSP
 	tristate "TI Sequencer Serial Port support"
-	depends on ARCH_DAVINCI_TNETV107X
+	depends on ARCH_DAVINCI_TNETV107X && GENERIC_HARDIRQS
 	select MFD_CORE
 	---help---
 	  Say Y here if you want support for the Sequencer Serial Port
@@ -109,6 +109,7 @@ config MFD_TI_AM335X_TSCADC
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
+	depends on GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for Texas Instruments series
 	  of Touch Screen /ADC chips.
@@ -126,6 +127,7 @@ config HTC_EGPIO
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
 	select MFD_CORE
+	depends on GENERIC_HARDIRQS
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
@@ -157,6 +159,7 @@ config MFD_LM3533
 	depends on I2C
 	select MFD_CORE
 	select REGMAP_I2C
+	depends on GENERIC_HARDIRQS
 	help
 	  Say yes here to enable support for National Semiconductor / TI
 	  LM3533 Lighting Power chips.
@@ -171,6 +174,7 @@ config TPS6105X
 	select REGULATOR
 	select MFD_CORE
 	select REGULATOR_FIXED_VOLTAGE
+	depends on GENERIC_HARDIRQS
 	help
 	  This option enables a driver for the TP61050/TPS61052
 	  high-power "white LED driver". This boost converter is
@@ -193,7 +197,7 @@ config TPS65010
 config TPS6507X
 	tristate "TPS6507x Power Management / Touch Screen chips"
 	select MFD_CORE
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the TPS6507x series of
 	  Power Management / Touch Screen chips.  These include voltage
@@ -204,7 +208,7 @@ config TPS6507X
 
 config MFD_TPS65217
 	tristate "TPS65217 Power Management / White LED chips"
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	help
@@ -234,7 +238,7 @@ config MFD_TPS6586X
 
 config MFD_TPS65910
 	bool "TPS65910 Power Management chip"
-	depends on I2C=y && GPIOLIB
+	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -251,7 +255,7 @@ config MFD_TPS65912_I2C
 	bool "TPS65912 Power Management chip with I2C"
 	select MFD_CORE
 	select MFD_TPS65912
-	depends on I2C=y && GPIOLIB
+	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips with I2C interface.
@@ -260,7 +264,7 @@ config MFD_TPS65912_SPI
 	bool "TPS65912 Power Management chip with SPI"
 	select MFD_CORE
 	select MFD_TPS65912
-	depends on SPI_MASTER && GPIOLIB
+	depends on SPI_MASTER && GPIOLIB && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips with SPI interface.
@@ -330,13 +334,13 @@ config TWL4030_POWER
 
 config MFD_TWL4030_AUDIO
 	bool
-	depends on TWL4030_CORE
+	depends on TWL4030_CORE && GENERIC_HARDIRQS
 	select MFD_CORE
 	default n
 
 config TWL6040_CORE
 	bool "Support for TWL6040 audio codec"
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -405,7 +409,7 @@ config MFD_TMIO
 
 config MFD_T7L66XB
 	bool "Support Toshiba T7L66XB"
-	depends on ARM && HAVE_CLK
+	depends on ARM && HAVE_CLK && GENERIC_HARDIRQS
 	select MFD_CORE
 	select MFD_TMIO
 	help
@@ -413,7 +417,7 @@ config MFD_T7L66XB
 
 config MFD_SMSC
        bool "Support for the SMSC ECE1099 series chips"
-       depends on I2C=y
+       depends on I2C=y && GENERIC_HARDIRQS
        select MFD_CORE
        select REGMAP_I2C
        help
@@ -460,7 +464,7 @@ config MFD_DA9052_SPI
 	select REGMAP_SPI
 	select REGMAP_IRQ
 	select PMIC_DA9052
-	depends on SPI_MASTER=y
+	depends on SPI_MASTER=y && GENERIC_HARDIRQS
 	help
 	  Support for the Dialog Semiconductor DA9052 PMIC
 	  when controlled using SPI. This driver provides common support
@@ -472,7 +476,7 @@ config MFD_DA9052_I2C
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select PMIC_DA9052
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Support for the Dialog Semiconductor DA9052 PMIC
 	  when controlled using I2C. This driver provides common support
@@ -485,7 +489,7 @@ config MFD_DA9055
 	select REGMAP_IRQ
 	select PMIC_DA9055
 	select MFD_CORE
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Say yes here for support of Dialog Semiconductor DA9055. This is
 	  a Power Management IC. This driver provides common support for
@@ -508,7 +512,7 @@ config PMIC_ADP5520
 
 config MFD_LP8788
 	bool "Texas Instruments LP8788 Power Management Unit Driver"
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	select IRQ_DOMAIN
@@ -611,7 +615,7 @@ config MFD_ARIZONA_I2C
 	select MFD_ARIZONA
 	select MFD_CORE
 	select REGMAP_I2C
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelectronics Arizona platform audio SoC
 	  core functionality controlled via I2C.
@@ -621,7 +625,7 @@ config MFD_ARIZONA_SPI
 	select MFD_ARIZONA
 	select MFD_CORE
 	select REGMAP_SPI
-	depends on SPI_MASTER
+	depends on SPI_MASTER && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelectronics Arizona platform audio SoC
 	  core functionality controlled via I2C.
@@ -641,7 +645,7 @@ config MFD_WM5110
 config MFD_WM8400
 	bool "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	select REGMAP_I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
@@ -785,7 +789,7 @@ config MFD_MC13783
 
 config MFD_MC13XXX
 	tristate
-	depends on SPI_MASTER || I2C
+	depends on (SPI_MASTER || I2C) && GENERIC_HARDIRQS
 	select MFD_CORE
 	select MFD_MC13783
 	help
@@ -796,7 +800,7 @@ config MFD_MC13XXX
 
 config MFD_MC13XXX_SPI
 	tristate "Freescale MC13783 and MC13892 SPI interface"
-	depends on SPI_MASTER
+	depends on SPI_MASTER && GENERIC_HARDIRQS
 	select REGMAP_SPI
 	select MFD_MC13XXX
 	help
@@ -804,7 +808,7 @@ config MFD_MC13XXX_SPI
 
 config MFD_MC13XXX_I2C
 	tristate "Freescale MC13892 I2C interface"
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	select REGMAP_I2C
 	select MFD_MC13XXX
 	help
@@ -822,7 +826,7 @@ config ABX500_CORE
 
 config AB3100_CORE
 	bool "ST-Ericsson AB3100 Mixed Signal Circuit core functions"
-	depends on I2C=y && ABX500_CORE
+	depends on I2C=y && ABX500_CORE && GENERIC_HARDIRQS
 	select MFD_CORE
 	default y if ARCH_U300
 	help
@@ -909,7 +913,7 @@ config MFD_TIMBERDALE
 
 config LPC_SCH
 	tristate "Intel SCH LPC"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  LPC bridge function of the Intel SCH provides support for
@@ -917,7 +921,7 @@ config LPC_SCH
 
 config LPC_ICH
 	tristate "Intel ICH LPC"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  The LPC bridge function of the Intel ICH provides support for
@@ -928,7 +932,7 @@ config LPC_ICH
 config MFD_RDC321X
 	tristate "Support for RDC-R321x southbridge"
 	select MFD_CORE
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	help
 	  Say yes here if you want to have support for the RDC R-321x SoC
 	  southbridge which provides access to GPIOs and Watchdog using the
@@ -937,7 +941,7 @@ config MFD_RDC321X
 config MFD_JANZ_CMODIO
 	tristate "Support for Janz CMOD-IO PCI MODULbus Carrier Board"
 	select MFD_CORE
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	help
 	  This is the core driver for the Janz CMOD-IO PCI MODULbus
 	  carrier board. This device is a PCI to MODULbus bridge which may
@@ -955,7 +959,7 @@ config MFD_JZ4740_ADC
 
 config MFD_VX855
 	tristate "Support for VIA VX855/VX875 integrated south bridge"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  Say yes here to enable support for various functions of the
@@ -964,7 +968,7 @@ config MFD_VX855
 
 config MFD_WL1273_CORE
 	tristate "Support for TI WL1273 FM radio."
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	select MFD_CORE
 	default n
 	help
@@ -1028,7 +1032,7 @@ config MFD_TPS65090
 config MFD_AAT2870_CORE
 	bool "Support for the AnalogicTech AAT2870"
 	select MFD_CORE
-	depends on I2C=y && GPIOLIB
+	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the AAT2870.
 	  This driver provides common support for accessing the device,
@@ -1060,7 +1064,7 @@ config MFD_RC5T583
 
 config MFD_STA2X11
 	bool "STA2X11 multi function device support"
-	depends on STA2X11
+	depends on STA2X11 && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_MMIO
 
@@ -1077,7 +1081,7 @@ config MFD_PALMAS
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the Palmas
 	  series of PMIC chips from Texas Instruments.
@@ -1085,7 +1089,7 @@ config MFD_PALMAS
 config MFD_VIPERBOARD
         tristate "Support for Nano River Technologies Viperboard"
 	select MFD_CORE
-	depends on USB
+	depends on USB && GENERIC_HARDIRQS
 	default n
 	help
 	  Say yes here if you want support for Nano River Technologies
@@ -1099,7 +1103,7 @@ config MFD_VIPERBOARD
 config MFD_RETU
 	tristate "Support for Retu multi-function device"
 	select MFD_CORE
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	select REGMAP_IRQ
 	help
 	  Retu is a multi-function device found on Nokia Internet Tablets
@@ -1110,7 +1114,7 @@ config MFD_AS3711
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Support for the AS3711 PMIC from AMS
 
-- 
1.7.10.4

