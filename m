Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbbAOWSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:18:13 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57835 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755828AbbAOWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:16:53 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/5] ARM: at91: switch to multiplatform
Date: Thu, 15 Jan 2015 23:16:45 +0100
Message-Id: <1421360209-15852-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421360209-15852-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421360209-15852-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch AT91 to multiplatform as all SoCs are properly handled.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/Kconfig            |  13 -----
 arch/arm/mach-at91/Kconfig  | 114 +++++++++++++++++++++++---------------------
 arch/arm/mach-at91/Makefile |   2 +
 3 files changed, 62 insertions(+), 67 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97d07ed60a0b..178266237422 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -354,19 +354,6 @@ config ARCH_VERSATILE
 	help
 	  This enables support for ARM Ltd Versatile board.
 
-config ARCH_AT91
-	bool "Atmel AT91"
-	select ARCH_REQUIRE_GPIOLIB
-	select CLKDEV_LOOKUP
-	select IRQ_DOMAIN
-	select NEED_MACH_IO_H if PCCARD
-	select PINCTRL
-	select PINCTRL_AT91
-	select USE_OF
-	help
-	  This enables support for systems based on Atmel
-	  AT91RM9200, AT91SAM9 and SAMA5 processors.
-
 config ARCH_CLPS711X
 	bool "Cirrus Logic CLPS711x/EP721x/EP731x-based"
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index c6740e359a44..f787e9a320bc 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -1,51 +1,19 @@
-if ARCH_AT91
-
-config HAVE_AT91_UTMI
-	bool
-
-config HAVE_AT91_USB_CLK
-	bool
-
-config COMMON_CLK_AT91
-	bool
-	select COMMON_CLK
-
-config HAVE_AT91_SMD
-	bool
-
-config HAVE_AT91_H32MX
-	bool
-
-config SOC_SAMA5
+config ARCH_AT91
+	select ARCH_REQUIRE_GPIOLIB
+	select CLKDEV_LOOKUP
+	select IRQ_DOMAIN
+	select NEED_MACH_IO_H if PCCARD
+	select PINCTRL
+	select PINCTRL_AT91
+	select USE_OF
 	bool
-	select ATMEL_AIC5_IRQ
-	select COMMON_CLK_AT91
-	select CPU_V7
-	select GENERIC_CLOCKEVENTS
-	select MEMORY
-	select ATMEL_SDRAMC
-	select PHYLIB if NETDEVICES
-
-menu "Atmel AT91 System-on-Chip"
 
-choice
-
-	prompt "Core type"
-
-config SOC_SAM_V4_V5
-	bool "ARM9 AT91SAM9/AT91RM9200"
+menuconfig SOC_SAM_V7
+	bool "Atmel SAMA5" if ARCH_MULTI_V7
+	select ARCH_AT91
 	help
-	  Select this if you are using one of Atmel's AT91SAM9 or
-	  AT91RM9200 SoC.
-
-config SOC_SAM_V7
-	bool "Cortex A5"
-	help
-	  Select this if you are using one of Atmel's SAMA5D3 SoC.
-
-endchoice
-
-comment "Atmel AT91 Processor"
+	  This enables support for systems based on Atmel
+	  SAMA5D3 or SAMA5D4 SoCs.
 
 if SOC_SAM_V7
 config SOC_SAMA5D3
@@ -72,11 +40,19 @@ config SOC_SAMA5D4
 	select HAVE_AT91_H32MX
 	help
 	  Select this if you are using one of Atmel's SAMA5D4 family SoC.
-endif
+endif # SOC_SAM_V7
+
+
+menuconfig SOC_SAM_V4_V5
+	bool "Atmel ARM9 AT91SAM9/AT91RM9200" if ARCH_MULTI_V4_V5
+	select ARCH_AT91
+	help
+	  Select this if you are using one of Atmel's AT91SAM9 or
+	  AT91RM9200 SoC.
 
 if SOC_SAM_V4_V5
 config SOC_AT91RM9200
-	bool "AT91RM9200"
+	bool "AT91RM9200" if ARCH_MULTI_V4T
 	select ATMEL_AIC_IRQ
 	select COMMON_CLK_AT91
 	select CPU_ARM920T
@@ -84,7 +60,7 @@ config SOC_AT91RM9200
 	select HAVE_AT91_USB_CLK
 
 config SOC_AT91SAM9
-	bool "AT91SAM9"
+	bool "AT91SAM9" if ARCH_MULTI_V5
 	select ATMEL_AIC_IRQ
 	select ATMEL_SDRAMC
 	select COMMON_CLK_AT91
@@ -115,6 +91,36 @@ config SOC_AT91SAM9
 	    AT91SAM9XE
 endif # SOC_SAM_V4_V5
 
+if ARCH_AT91
+
+config HAVE_AT91_UTMI
+	bool
+
+config HAVE_AT91_USB_CLK
+	bool
+
+config COMMON_CLK_AT91
+	bool
+	select COMMON_CLK
+
+config HAVE_AT91_SMD
+	bool
+
+config HAVE_AT91_H32MX
+	bool
+
+config SOC_SAMA5
+	bool
+	select ATMEL_AIC5_IRQ
+	select COMMON_CLK_AT91
+	select CPU_V7
+	select GENERIC_CLOCKEVENTS
+	select MEMORY
+	select ATMEL_SDRAMC
+	select PHYLIB if NETDEVICES
+
+menu "Atmel AT91 common options"
+
 comment "AT91 Feature Selections"
 
 config AT91_SLOW_CLOCK
@@ -132,12 +138,12 @@ config AT91_SLOW_CLOCK
 	  need to be completely re-initialized.
 
 config AT91_TIMER_HZ
-       int "Kernel HZ (jiffies per second)"
-       range 32 1024
-       depends on ARCH_AT91
-       default "128" if SOC_AT91RM9200
-       default "100"
-       help
+	int "Kernel HZ (jiffies per second)"
+	range 32 1024
+	depends on ARCH_AT91
+	default "128" if SOC_AT91RM9200
+	default "100"
+	help
 	  On AT91rm9200 chips where you're using a system clock derived
 	  from the 32768 Hz hardware clock, this tick rate should divide
 	  it exactly: use a power-of-two value, such as 128 or 256, to
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index be26bb8c9a9a..a6a02f3c3219 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -1,6 +1,8 @@
 #
 # Makefile for the linux kernel.
 #
+ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
+asflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
 
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
-- 
2.1.0

