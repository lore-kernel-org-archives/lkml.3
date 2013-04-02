Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026Ab3DBRKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:10:48 -0400
Received: from zmc.proxad.net ([212.27.53.206]:51976 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761994Ab3DBRKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:10:45 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 2/5 v2] USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends on architecture symbol
Date: Tue,  2 Apr 2013 19:10:23 +0200
Message-Id: <1364922626-32407-3-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364922626-32407-1-git-send-email-florian@openwrt.org>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
 <1364922626-32407-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like the OHCI counter part we just can remove the architecture
specific symbols which prevent these configuration symbols from being
selected by platforms/architectures requiring it. The original
implementation did not scale at all since it required each and every
single architecture to be added for these configuration symbols to be
selected. Now it is up to the EHCI driver and/or platform to select
these configuration symbols accordingly.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since RFC:
- dropped default n for USB_EHCI_BIG_ENDIAN_{MMIO_DESC} as it is the default
- properly patch MPC521x and not MPC52xx

 arch/arm/Kconfig                    |    2 ++
 arch/mips/Kconfig                   |    3 +++
 arch/powerpc/platforms/44x/Kconfig  |    2 ++
 arch/powerpc/platforms/512x/Kconfig |    2 ++
 arch/sparc/Kconfig                  |    2 ++
 drivers/usb/host/Kconfig            |   11 ++---------
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..6100e6e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -549,6 +549,8 @@ config ARCH_IXP4XX
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
 	select NEED_MACH_IO_H
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	select USB_EHCI_BIG_ENDIAN_DESC
 	help
 	  Support for Intel's IXP4XX (XScale) family of processors.
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cd2e21f..a46a0b0 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -404,6 +404,8 @@ config PMC_MSP
 	select IRQ_CPU
 	select SERIAL_8250
 	select SERIAL_8250_CONSOLE
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	select USB_EHCI_BIG_ENDIAN_DESC
 	help
 	  This adds support for the PMC-Sierra family of Multi-Service
 	  Processor System-On-A-Chips.  These parts include a number
@@ -1433,6 +1435,7 @@ config CPU_CAVIUM_OCTEON
 	select CPU_SUPPORTS_HUGEPAGES
 	select LIBFDT
 	select USE_OF
+	select USB_EHCI_BIG_ENDIAN_MMIO
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
 	  many ethernet hardware widgets for networking tasks. The processor
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 0effe9f..7be9336 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -274,6 +274,8 @@ config 440EPX
 	select IBM_EMAC_EMAC4
 	select IBM_EMAC_RGMII
 	select IBM_EMAC_ZMII
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	select USB_EHCI_BIG_ENDIAN_DESC
 
 config 440GRX
 	bool
diff --git a/arch/powerpc/platforms/512x/Kconfig b/arch/powerpc/platforms/512x/Kconfig
index c169998..381a592 100644
--- a/arch/powerpc/platforms/512x/Kconfig
+++ b/arch/powerpc/platforms/512x/Kconfig
@@ -7,6 +7,8 @@ config PPC_MPC512x
 	select PPC_PCI_CHOICE
 	select FSL_PCI if PCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	select USB_EHCI_BIG_ENDIAN_DESC
 
 config MPC5121_ADS
 	bool "Freescale MPC5121E ADS"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3d361f2..66dc562 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -407,6 +407,8 @@ config SERIAL_CONSOLE
 config SPARC_LEON
 	bool "Sparc Leon processor family"
 	depends on SPARC32
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	select USB_EHCI_BIG_ENDIAN_DESC
 	---help---
 	  If you say Y here if you are running on a SPARC-LEON processor.
 	  The LEON processor is a synthesizable VHDL model of the
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 7f4ccf7..a330549 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -110,18 +110,11 @@ config USB_EHCI_HCD_PMC_MSP
 
 config USB_EHCI_BIG_ENDIAN_MMIO
 	bool
-	depends on USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || \
-				    ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
-				    PPC_MPC512x || CPU_CAVIUM_OCTEON || \
-				    PMC_MSP || SPARC_LEON || MIPS_SEAD3)
-	default y
+	depends on USB_EHCI_HCD
 
 config USB_EHCI_BIG_ENDIAN_DESC
 	bool
-	depends on USB_EHCI_HCD && (440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
-				    PPC_MPC512x || PMC_MSP || SPARC_LEON || \
-				    MIPS_SEAD3)
-	default y
+	depends on USB_EHCI_HCD
 
 config XPS_USB_HCD_XILINX
 	bool "Use Xilinx usb host EHCI controller core"
-- 
1.7.10.4

