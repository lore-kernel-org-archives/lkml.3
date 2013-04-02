Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab3DBRMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:12:08 -0400
Received: from zmc.proxad.net ([212.27.53.206]:51964 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761172Ab3DBRKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:10:44 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 4/5 v2] USB: enclose all depends on USB_OHCI_HCD within an if USB_OHCI_HCD block
Date: Tue,  2 Apr 2013 19:10:25 +0200
Message-Id: <1364922626-32407-5-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364922626-32407-1-git-send-email-florian@openwrt.org>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
 <1364922626-32407-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the various depends on USB_OHCI_HCD from the OHCI HCD
drivers and enclose them within an if USB_OHCI_HCD / endif block. The
Octeon OHCI HCD driver has been moved around to remain in this block.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig |   51 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index e4faca0..475c508 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -327,16 +327,18 @@ config USB_OHCI_HCD
 	  To compile this driver as a module, choose M here: the
 	  module will be called ohci-hcd.
 
+if USB_OHCI_HCD
+
 config USB_OHCI_HCD_OMAP1
 	bool "OHCI support for OMAP1/2 chips"
-	depends on USB_OHCI_HCD && ARCH_OMAP1
+	depends on ARCH_OMAP1
 	default y
 	---help---
 	  Enables support for the OHCI controller on OMAP1/2 chips.
 
 config USB_OHCI_HCD_OMAP3
 	bool "OHCI support for OMAP3 and later chips"
-	depends on USB_OHCI_HCD && (ARCH_OMAP3 || ARCH_OMAP4)
+	depends on (ARCH_OMAP3 || ARCH_OMAP4)
 	default y
 	---help---
 	  Enables support for the on-chip OHCI controller on
@@ -344,7 +346,7 @@ config USB_OHCI_HCD_OMAP3
 
 config USB_OHCI_ATH79
 	bool "USB OHCI support for the Atheros AR71XX/AR7240 SoCs (DEPRECATED)"
-	depends on USB_OHCI_HCD && (SOC_AR71XX || SOC_AR724X)
+	depends on (SOC_AR71XX || SOC_AR724X)
 	select USB_OHCI_HCD_PLATFORM
 	default y
 	help
@@ -356,7 +358,7 @@ config USB_OHCI_ATH79
 
 config USB_OHCI_HCD_PPC_OF_BE
 	bool "OHCI support for OF platform bus (big endian)"
-	depends on USB_OHCI_HCD && PPC_OF
+	depends on PPC_OF
 	select USB_OHCI_BIG_ENDIAN_DESC
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	---help---
@@ -365,7 +367,7 @@ config USB_OHCI_HCD_PPC_OF_BE
 
 config USB_OHCI_HCD_PPC_OF_LE
 	bool "OHCI support for OF platform bus (little endian)"
-	depends on USB_OHCI_HCD && PPC_OF
+	depends on PPC_OF
 	select USB_OHCI_LITTLE_ENDIAN
 	---help---
 	  Enables support for little-endian USB controllers present on the
@@ -373,12 +375,12 @@ config USB_OHCI_HCD_PPC_OF_LE
 
 config USB_OHCI_HCD_PPC_OF
 	bool
-	depends on USB_OHCI_HCD && PPC_OF
+	depends on PPC_OF
 	default USB_OHCI_HCD_PPC_OF_BE || USB_OHCI_HCD_PPC_OF_LE
 
 config USB_OHCI_HCD_PCI
 	bool "OHCI support for PCI-bus USB controllers"
-	depends on USB_OHCI_HCD && PCI && (STB03xxx || PPC_MPC52xx || USB_OHCI_HCD_PPC_OF)
+	depends on PCI && (STB03xxx || PPC_MPC52xx || USB_OHCI_HCD_PPC_OF)
 	default y
 	select USB_OHCI_LITTLE_ENDIAN
 	---help---
@@ -387,7 +389,7 @@ config USB_OHCI_HCD_PCI
 
 config USB_OHCI_HCD_SSB
 	bool "OHCI support for Broadcom SSB OHCI core (DEPRECATED)"
-	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD)
+	depends on (SSB = y || SSB = USB_OHCI_HCD)
 	select USB_HCD_SSB
 	select USB_OHCI_HCD_PLATFORM
 	default n
@@ -405,7 +407,7 @@ config USB_OHCI_HCD_SSB
 
 config USB_OHCI_SH
 	bool "OHCI support for SuperH USB controller (DEPRECATED)"
-	depends on USB_OHCI_HCD && SUPERH
+	depends on SUPERH
 	select USB_OHCI_HCD_PLATFORM
 	---help---
 	  This option is deprecated now and the driver was removed, use
@@ -416,13 +418,13 @@ config USB_OHCI_SH
 
 config USB_OHCI_EXYNOS
 	boolean "OHCI support for Samsung EXYNOS SoC Series"
-	depends on USB_OHCI_HCD && ARCH_EXYNOS
+	depends on ARCH_EXYNOS
 	help
 	 Enable support for the Samsung Exynos SOC's on-chip OHCI controller.
 
 config USB_CNS3XXX_OHCI
 	bool "Cavium CNS3XXX OHCI Module (DEPRECATED)"
-	depends on USB_OHCI_HCD && ARCH_CNS3XXX
+	depends on ARCH_CNS3XXX
 	select USB_OHCI_HCD_PLATFORM
 	---help---
 	  This option is deprecated now and the driver was removed, use
@@ -433,7 +435,6 @@ config USB_CNS3XXX_OHCI
 
 config USB_OHCI_HCD_PLATFORM
 	bool "Generic OHCI driver for a platform device"
-	depends on USB_OHCI_HCD
 	default n
 	---help---
 	  Adds an OHCI host driver for a generic platform device, which
@@ -441,23 +442,33 @@ config USB_OHCI_HCD_PLATFORM
 
 	  If unsure, say N.
 
+config USB_OCTEON_OHCI
+	bool "Octeon on-chip OHCI support"
+	depends on CPU_CAVIUM_OCTEON
+	default USB_OCTEON_EHCI
+	select USB_OHCI_BIG_ENDIAN_MMIO
+	select USB_OHCI_LITTLE_ENDIAN
+	help
+	  Enable support for the Octeon II SOC's on-chip OHCI
+	  controller.  It is needed for low-speed USB 1.0 device
+	  support.  All CN6XXX based chips with USB are supported.
+
 
 config USB_OHCI_BIG_ENDIAN_DESC
 	bool
-	depends on USB_OHCI_HCD
 	default n
 
 config USB_OHCI_BIG_ENDIAN_MMIO
 	bool
-	depends on USB_OHCI_HCD
 	default n
 
 config USB_OHCI_LITTLE_ENDIAN
 	bool
-	depends on USB_OHCI_HCD
 	default n if STB03xxx || PPC_MPC52xx
 	default y
 
+endif # USB_OHCI_HCD
+
 config USB_UHCI_HCD
 	tristate "UHCI HCD (most Intel and VIA) support"
 	depends on PCI || SPARC_LEON || ARCH_VT8500
@@ -634,16 +645,6 @@ config USB_IMX21_HCD
          module will be called "imx21-hcd".
 
 
-config USB_OCTEON_OHCI
-	bool "Octeon on-chip OHCI support"
-	depends on USB_OHCI_HCD && CPU_CAVIUM_OCTEON
-	default USB_OCTEON_EHCI
-	select USB_OHCI_BIG_ENDIAN_MMIO
-	select USB_OHCI_LITTLE_ENDIAN
-	help
-	  Enable support for the Octeon II SOC's on-chip OHCI
-	  controller.  It is needed for low-speed USB 1.0 device
-	  support.  All CN6XXX based chips with USB are supported.
 
 config USB_OCTEON2_COMMON
 	bool
-- 
1.7.10.4

