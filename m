Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaBPTqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:46:24 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51200 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbaBPTqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:46:23 -0500
Message-ID: <1392579980.28866.56.camel@x220>
Subject: [PATCH 2/2] usb: host: remove selects of USB_ARCH_HAS_?HCI
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>
Cc: Richard Weinberger <richard@nod.at>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 20:46:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 19:46:21.0326 (UTC) FILETIME=[C453A2E0:01CF2B4F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB_ARCH_HAS_EHCI, USB_ARCH_HAS_OHCI, and USB_ARCH_HAS_XHCI were just
removed. Selecting them is a nop. The select statements for these
symbols can be removed too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

Sending this as a few separate patches to the maintainers of the arches
involved seemed inefficient.

 arch/arm/Kconfig                   | 3 ---
 arch/arm/mach-exynos/Kconfig       | 1 -
 arch/arm/mach-omap2/Kconfig        | 2 --
 arch/arm/mach-shmobile/Kconfig     | 4 ----
 arch/arm/mach-tegra/Kconfig        | 1 -
 arch/mips/Kconfig                  | 7 -------
 arch/mips/ath79/Kconfig            | 8 --------
 arch/mips/ralink/Kconfig           | 6 ------
 arch/powerpc/platforms/44x/Kconfig | 1 -
 arch/powerpc/platforms/ps3/Kconfig | 2 --
 arch/sh/Kconfig                    | 9 ---------
 11 files changed, 44 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..e607f08 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -534,7 +534,6 @@ config ARCH_DOVE
 	select PINCTRL
 	select PINCTRL_DOVE
 	select PLAT_ORION_LEGACY
-	select USB_ARCH_HAS_EHCI
 	help
 	  Support for the Marvell Dove SoC 88AP510
 
@@ -633,7 +632,6 @@ config ARCH_LPC32XX
 	select GENERIC_CLOCKEVENTS
 	select HAVE_IDE
 	select HAVE_PWM
-	select USB_ARCH_HAS_OHCI
 	select USE_OF
 	help
 	  Support for the NXP LPC32XX family of processors
@@ -770,7 +768,6 @@ config ARCH_S3C64XX
 	select SAMSUNG_ATAGS
 	select SAMSUNG_WAKEMASK
 	select SAMSUNG_WDT_RESET
-	select USB_ARCH_HAS_OHCI
 	help
 	  Samsung S3C64XX series based systems
 
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 4c414af..8d197dc 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -36,7 +36,6 @@ config ARCH_EXYNOS5
 	select HAVE_ARM_SCU if SMP
 	select HAVE_SMP
 	select PINCTRL
-	select USB_ARCH_HAS_XHCI
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
 
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index bb51eeb..9deaa92 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -21,7 +21,6 @@ config ARCH_OMAP3
 	select PM_OPP if PM
 	select PM_RUNTIME if CPU_IDLE
 	select SOC_HAS_OMAP2_SDRC
-	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 
 config ARCH_OMAP4
 	bool "TI OMAP4"
@@ -42,7 +41,6 @@ config ARCH_OMAP4
 	select PL310_ERRATA_727915
 	select PM_OPP if PM
 	select PM_RUNTIME if CPU_IDLE
-	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_775420
 
diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 3386406..bbdf684 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -102,8 +102,6 @@ config ARCH_R8A7778
 	select CPU_V7
 	select SH_CLK_CPG
 	select ARM_GIC
-	select USB_ARCH_HAS_EHCI
-	select USB_ARCH_HAS_OHCI
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
@@ -111,8 +109,6 @@ config ARCH_R8A7779
 	select ARM_GIC
 	select CPU_V7
 	select SH_CLK_CPG
-	select USB_ARCH_HAS_EHCI
-	select USB_ARCH_HAS_OHCI
 	select RENESAS_INTC_IRQPIN
 
 config ARCH_R8A7790
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index b1232d8..4926bd1 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -19,7 +19,6 @@ config ARCH_TEGRA
 	select RESET_CONTROLLER
 	select SOC_BUS
 	select SPARSE_IRQ
-	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select USB_ULPI if USB_PHY
 	select USB_ULPI_VIEWPORT if USB_PHY
 	select USE_OF
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b3bf596..1f51db8 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -67,8 +67,6 @@ config MIPS_ALCHEMY
 	select SYS_SUPPORTS_APM_EMULATION
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_SUPPORTS_ZBOOT
-	select USB_ARCH_HAS_OHCI
-	select USB_ARCH_HAS_EHCI
 
 config AR7
 	bool "Texas Instruments AR7"
@@ -360,7 +358,6 @@ config MIPS_SEAD3
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_SMARTMIPS
 	select SYS_SUPPORTS_MICROMIPS
-	select USB_ARCH_HAS_EHCI
 	select USB_EHCI_BIG_ENDIAN_DESC
 	select USB_EHCI_BIG_ENDIAN_MMIO
 	select USE_OF
@@ -718,8 +715,6 @@ config CAVIUM_OCTEON_SOC
 	select SWAP_IO_SPACE
 	select HW_HAS_PCI
 	select ZONE_DMA32
-	select USB_ARCH_HAS_OHCI
-	select USB_ARCH_HAS_EHCI
 	select HOLES_IN_ZONE
 	select ARCH_REQUIRE_GPIOLIB
 	help
@@ -756,8 +751,6 @@ config NLM_XLR_BOARD
 	select ZONE_DMA32 if 64BIT
 	select SYNC_R4K
 	select SYS_HAS_EARLY_PRINTK
-	select USB_ARCH_HAS_OHCI if USB_SUPPORT
-	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select SYS_SUPPORTS_ZBOOT
 	select SYS_SUPPORTS_ZBOOT_UART16550
 	help
diff --git a/arch/mips/ath79/Kconfig b/arch/mips/ath79/Kconfig
index 3995e31..dfc6020 100644
--- a/arch/mips/ath79/Kconfig
+++ b/arch/mips/ath79/Kconfig
@@ -74,34 +74,26 @@ config ATH79_MACH_UBNT_XM
 endmenu
 
 config SOC_AR71XX
-	select USB_ARCH_HAS_EHCI
-	select USB_ARCH_HAS_OHCI
 	select HW_HAS_PCI
 	def_bool n
 
 config SOC_AR724X
-	select USB_ARCH_HAS_EHCI
-	select USB_ARCH_HAS_OHCI
 	select HW_HAS_PCI
 	select PCI_AR724X if PCI
 	def_bool n
 
 config SOC_AR913X
-	select USB_ARCH_HAS_EHCI
 	def_bool n
 
 config SOC_AR933X
-	select USB_ARCH_HAS_EHCI
 	def_bool n
 
 config SOC_AR934X
-	select USB_ARCH_HAS_EHCI
 	select HW_HAS_PCI
 	select PCI_AR724X if PCI
 	def_bool n
 
 config SOC_QCA955X
-	select USB_ARCH_HAS_EHCI
 	select HW_HAS_PCI
 	select PCI_AR724X if PCI
 	def_bool n
diff --git a/arch/mips/ralink/Kconfig b/arch/mips/ralink/Kconfig
index 1bfd1c1..4a29665 100644
--- a/arch/mips/ralink/Kconfig
+++ b/arch/mips/ralink/Kconfig
@@ -20,19 +20,13 @@ choice
 	config SOC_RT305X
 		bool "RT305x"
 		select USB_ARCH_HAS_HCD
-		select USB_ARCH_HAS_OHCI
-		select USB_ARCH_HAS_EHCI
 
 	config SOC_RT3883
 		bool "RT3883"
-		select USB_ARCH_HAS_OHCI
-		select USB_ARCH_HAS_EHCI
 		select HW_HAS_PCI
 
 	config SOC_MT7620
 		bool "MT7620"
-		select USB_ARCH_HAS_OHCI
-		select USB_ARCH_HAS_EHCI
 
 endchoice
 
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index d6c7506..dc1a264 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -265,7 +265,6 @@ config 440EP
 	select PPC_FPU
 	select IBM440EP_ERR42
 	select IBM_EMAC_ZMII
-	select USB_ARCH_HAS_OHCI
 
 config 440EPX
 	bool
diff --git a/arch/powerpc/platforms/ps3/Kconfig b/arch/powerpc/platforms/ps3/Kconfig
index e87c194..56f2740 100644
--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -2,10 +2,8 @@ config PPC_PS3
 	bool "Sony PS3"
 	depends on PPC64 && PPC_BOOK3S
 	select PPC_CELL
-	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_LITTLE_ENDIAN
 	select USB_OHCI_BIG_ENDIAN_MMIO
-	select USB_ARCH_HAS_EHCI
 	select USB_EHCI_BIG_ENDIAN_MMIO
 	select PPC_PCI_CHOICE
 	help
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 6357710..64455da 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -356,7 +356,6 @@ config CPU_SUBTYPE_SH7720
 	select CPU_HAS_DSP
 	select SYS_SUPPORTS_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	select PINCTRL
 	help
@@ -367,7 +366,6 @@ config CPU_SUBTYPE_SH7721
 	select CPU_SH3
 	select CPU_HAS_DSP
 	select SYS_SUPPORTS_CMT
-	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	help
 	  Select SH7721 if you have a SH3-DSP SH7721 CPU.
@@ -445,8 +443,6 @@ config CPU_SUBTYPE_SH7734
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select USB_ARCH_HAS_OHCI
-	select USB_ARCH_HAS_EHCI
 	select PINCTRL
 	help
 	  Select SH7734 if you have a SH4A SH7734 CPU.
@@ -456,8 +452,6 @@ config CPU_SUBTYPE_SH7757
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select USB_ARCH_HAS_OHCI
-	select USB_ARCH_HAS_EHCI
 	select PINCTRL
 	help
 	  Select SH7757 if you have a SH4A SH7757 CPU.
@@ -465,7 +459,6 @@ config CPU_SUBTYPE_SH7757
 config CPU_SUBTYPE_SH7763
 	bool "Support SH7763 processor"
 	select CPU_SH4A
-	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	help
 	  Select SH7763 if you have a SH4A SH7763(R5S77631) CPU.
@@ -494,9 +487,7 @@ config CPU_SUBTYPE_SH7786
 	select CPU_HAS_PTEAEX
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
-	select USB_ARCH_HAS_EHCI
 	select USB_EHCI_SH if USB_EHCI_HCD
 	select PINCTRL
 
-- 
1.8.5.3

