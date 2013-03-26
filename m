Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3CZSII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:08:08 -0400
Received: from zmc.proxad.net ([212.27.53.206]:48309 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759976Ab3CZSG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:06:28 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [RFC PATCH 4/5] USB: enclose all depends on USB_OHCI_HCD within an if USB_OHCI_HCD block
Date: Tue, 26 Mar 2013 19:06:16 +0100
Message-Id: <1364321177-12146-5-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364321177-12146-1-git-send-email-florian@openwrt.org>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
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
index 7a91712..c5dfc08 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -328,16 +328,18 @@ config USB_OHCI_HCD
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
@@ -345,7 +347,7 @@ config USB_OHCI_HCD_OMAP3
 
 config USB_OHCI_ATH79
 	bool "USB OHCI support for the Atheros AR71XX/AR7240 SoCs (DEPRECATED)"
-	depends on USB_OHCI_HCD && (SOC_AR71XX || SOC_AR724X)
+	depends on (SOC_AR71XX || SOC_AR724X)
 	select USB_OHCI_HCD_PLATFORM
 	default y
 	help
@@ -357,7 +359,7 @@ config USB_OHCI_ATH79
 
 config USB_OHCI_HCD_PPC_OF_BE
 	bool "OHCI support for OF platform bus (big endian)"
-	depends on USB_OHCI_HCD && PPC_OF
+	depends on PPC_OF
 	select USB_OHCI_BIG_ENDIAN_DESC
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	---help---
@@ -366,7 +368,7 @@ config USB_OHCI_HCD_PPC_OF_BE
 
 config USB_OHCI_HCD_PPC_OF_LE
 	bool "OHCI support for OF platform bus (little endian)"
-	depends on USB_OHCI_HCD && PPC_OF
+	depends on PPC_OF
 	select USB_OHCI_LITTLE_ENDIAN
 	---help---
 	  Enables support for little-endian USB controllers present on the
@@ -374,12 +376,12 @@ config USB_OHCI_HCD_PPC_OF_LE
 
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
@@ -388,7 +390,7 @@ config USB_OHCI_HCD_PCI
 
 config USB_OHCI_HCD_SSB
 	bool "OHCI support for Broadcom SSB OHCI core (DEPRECATED)"
-	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD)
+	depends on (SSB = y || SSB = USB_OHCI_HCD)
 	select USB_HCD_SSB
 	select USB_OHCI_HCD_PLATFORM
 	default n
@@ -406,7 +408,7 @@ config USB_OHCI_HCD_SSB
 
 config USB_OHCI_SH
 	bool "OHCI support for SuperH USB controller (DEPRECATED)"
-	depends on USB_OHCI_HCD && SUPERH
+	depends on SUPERH
 	select USB_OHCI_HCD_PLATFORM
 	---help---
 	  This option is deprecated now and the driver was removed, use
@@ -417,13 +419,13 @@ config USB_OHCI_SH
 
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
@@ -434,7 +436,6 @@ config USB_CNS3XXX_OHCI
 
 config USB_OHCI_HCD_PLATFORM
 	bool "Generic OHCI driver for a platform device"
-	depends on USB_OHCI_HCD
 	default n
 	---help---
 	  Adds an OHCI host driver for a generic platform device, which
@@ -442,23 +443,33 @@ config USB_OHCI_HCD_PLATFORM
 
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
@@ -635,16 +646,6 @@ config USB_IMX21_HCD
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

