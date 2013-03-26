Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3CZSHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:07:06 -0400
Received: from zmc.proxad.net ([212.27.53.206]:48319 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759987Ab3CZSGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:06:30 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [RFC PATCH 3/5] USB: enclose EHCI HCD drivers within an if USB_EHCI_HCD block
Date: Tue, 26 Mar 2013 19:06:15 +0100
Message-Id: <1364321177-12146-4-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364321177-12146-1-git-send-email-florian@openwrt.org>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thist patch removes the depends on USB_EHCI_HCD that the various USB
EHCI HCD drivers use and encloses every driver within an if USB_EHCI_HCD
/ endif block. The EHCI HCD platform and Octeon drivers have been moved
around to remain enclosed within this block.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig |   75 ++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 1b63fae..7a91712 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -93,14 +93,16 @@ config USB_EHCI_TT_NEWSCHED
 
 	  If unsure, say Y.
 
+if USB_EHCI_HCD
+
 config USB_EHCI_PCI
 	tristate
-	depends on USB_EHCI_HCD && PCI
+	depends on PCI
 	default y
 
 config USB_EHCI_HCD_PMC_MSP
 	tristate "EHCI support for on-chip PMC MSP71xx USB controller"
-	depends on USB_EHCI_HCD && MSP_HAS_USB
+	depends on MSP_HAS_USB
 	default n
 	select USB_EHCI_BIG_ENDIAN_DESC
 	select USB_EHCI_BIG_ENDIAN_MMIO
@@ -110,17 +112,15 @@ config USB_EHCI_HCD_PMC_MSP
 
 config USB_EHCI_BIG_ENDIAN_MMIO
 	bool
-	depends on USB_EHCI_HCD
 	default n
 
 config USB_EHCI_BIG_ENDIAN_DESC
 	bool
-	depends on USB_EHCI_HCD
 	default n
 
 config XPS_USB_HCD_XILINX
 	bool "Use Xilinx usb host EHCI controller core"
-	depends on USB_EHCI_HCD && (PPC32 || MICROBLAZE)
+	depends on (PPC32 || MICROBLAZE)
 	select USB_EHCI_BIG_ENDIAN_DESC
 	select USB_EHCI_BIG_ENDIAN_MMIO
 	---help---
@@ -134,7 +134,7 @@ config USB_FSL_MPH_DR_OF
 
 config USB_EHCI_FSL
 	bool "Support for Freescale PPC on-chip EHCI USB controller"
-	depends on USB_EHCI_HCD && FSL_SOC
+	depends on FSL_SOC
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_FSL_MPH_DR_OF if OF
 	---help---
@@ -142,14 +142,14 @@ config USB_EHCI_FSL
 
 config USB_EHCI_MXC
 	tristate "Support for Freescale i.MX on-chip EHCI USB controller"
-	depends on USB_EHCI_HCD && ARCH_MXC
+	depends on ARCH_MXC
 	select USB_EHCI_ROOT_HUB_TT
 	---help---
 	  Variation of ARC USB block used in some Freescale chips.
 
 config USB_EHCI_HCD_OMAP
 	tristate "EHCI support for OMAP3 and later chips"
-	depends on USB_EHCI_HCD && ARCH_OMAP
+	depends on ARCH_OMAP
 	select NOP_USB_XCEIV
 	default y
 	---help---
@@ -158,7 +158,7 @@ config USB_EHCI_HCD_OMAP
 
 config USB_EHCI_MSM
 	bool "Support for MSM on-chip EHCI USB controller"
-	depends on USB_EHCI_HCD && ARCH_MSM
+	depends on ARCH_MSM
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_MSM_OTG
 	---help---
@@ -171,7 +171,7 @@ config USB_EHCI_MSM
 
 config USB_EHCI_TEGRA
        boolean "NVIDIA Tegra HCD support"
-       depends on USB_EHCI_HCD && ARCH_TEGRA
+       depends on ARCH_TEGRA
        select USB_EHCI_ROOT_HUB_TT
        help
          This driver enables support for the internal USB Host Controllers
@@ -179,7 +179,7 @@ config USB_EHCI_TEGRA
 
 config USB_EHCI_HCD_PPC_OF
 	bool "EHCI support for PPC USB controller on OF platform bus"
-	depends on USB_EHCI_HCD && PPC_OF
+	depends on PPC_OF
 	default y
 	---help---
 	  Enables support for the USB controller present on the PowerPC
@@ -187,20 +187,20 @@ config USB_EHCI_HCD_PPC_OF
 
 config USB_EHCI_SH
 	bool "EHCI support for SuperH USB controller"
-	depends on USB_EHCI_HCD && SUPERH
+	depends on SUPERH
 	---help---
 	  Enables support for the on-chip EHCI controller on the SuperH.
 	  If you use the PCI EHCI controller, this option is not necessary.
 
 config USB_EHCI_S5P
        boolean "S5P EHCI support"
-       depends on USB_EHCI_HCD && PLAT_S5P
+       depends on PLAT_S5P
        help
 	 Enable support for the S5P SOC's on-chip EHCI controller.
 
 config USB_EHCI_MV
 	bool "EHCI support for Marvell on-chip controller"
-	depends on USB_EHCI_HCD && (ARCH_PXA || ARCH_MMP)
+	depends on (ARCH_PXA || ARCH_MMP)
 	select USB_EHCI_ROOT_HUB_TT
 	---help---
 	  Enables support for Marvell (including PXA and MMP series) on-chip
@@ -209,13 +209,13 @@ config USB_EHCI_MV
 
 config USB_W90X900_EHCI
 	bool "W90X900(W90P910) EHCI support"
-	depends on USB_EHCI_HCD && ARCH_W90X900
+	depends on ARCH_W90X900
 	---help---
 		Enables support for the W90X900 USB controller
 
 config USB_CNS3XXX_EHCI
 	bool "Cavium CNS3XXX EHCI Module (DEPRECATED)"
-	depends on USB_EHCI_HCD && ARCH_CNS3XXX
+	depends on ARCH_CNS3XXX
 	select USB_EHCI_HCD_PLATFORM
 	---help---
 	  This option is deprecated now and the driver was removed, use
@@ -227,7 +227,7 @@ config USB_CNS3XXX_EHCI
 
 config USB_EHCI_ATH79
 	bool "EHCI support for AR7XXX/AR9XXX SoCs (DEPRECATED)"
-	depends on USB_EHCI_HCD && (SOC_AR71XX || SOC_AR724X || SOC_AR913X || SOC_AR933X)
+	depends on (SOC_AR71XX || SOC_AR724X || SOC_AR913X || SOC_AR933X)
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_EHCI_HCD_PLATFORM
 	default y
@@ -238,6 +238,28 @@ config USB_EHCI_ATH79
 	  Enables support for the built-in EHCI controller present
 	  on the Atheros AR7XXX/AR9XXX SoCs.
 
+config USB_EHCI_HCD_PLATFORM
+	tristate "Generic EHCI driver for a platform device"
+	default n
+	---help---
+	  Adds an EHCI host driver for a generic platform device, which
+	  provides a memory space and an irq.
+
+	  If unsure, say N.
+
+config USB_OCTEON_EHCI
+	bool "Octeon on-chip EHCI support"
+	depends on CPU_CAVIUM_OCTEON
+	default n
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	help
+	  Enable support for the Octeon II SOC's on-chip EHCI
+	  controller.  It is needed for high-speed (480Mbit/sec)
+	  USB 2.0 device support.  All CN6XXX based chips with USB are
+	  supported.
+
+endif # USB_EHCI_HCD
+
 config USB_OXU210HP_HCD
 	tristate "OXU210HP HCD support"
 	depends on GENERIC_HARDIRQS
@@ -420,15 +442,6 @@ config USB_OHCI_HCD_PLATFORM
 
 	  If unsure, say N.
 
-config USB_EHCI_HCD_PLATFORM
-	tristate "Generic EHCI driver for a platform device"
-	depends on USB_EHCI_HCD
-	default n
-	---help---
-	  Adds an EHCI host driver for a generic platform device, which
-	  provides a memory space and an irq.
-
-	  If unsure, say N.
 
 config USB_OHCI_BIG_ENDIAN_DESC
 	bool
@@ -621,16 +634,6 @@ config USB_IMX21_HCD
          To compile this driver as a module, choose M here: the
          module will be called "imx21-hcd".
 
-config USB_OCTEON_EHCI
-	bool "Octeon on-chip EHCI support"
-	depends on USB_EHCI_HCD && CPU_CAVIUM_OCTEON
-	default n
-	select USB_EHCI_BIG_ENDIAN_MMIO
-	help
-	  Enable support for the Octeon II SOC's on-chip EHCI
-	  controller.  It is needed for high-speed (480Mbit/sec)
-	  USB 2.0 device support.  All CN6XXX based chips with USB are
-	  supported.
 
 config USB_OCTEON_OHCI
 	bool "Octeon on-chip OHCI support"
-- 
1.7.10.4

