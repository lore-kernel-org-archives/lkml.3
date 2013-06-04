Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3FDRm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:42:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3FDRmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:42:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] usb: host: make USB_ARCH_HAS_?HCI obsolete
Date: Tue, 4 Jun 2013 19:42:22 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1306041107520.1093-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306041107520.1093-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041942.22904.arnd@arndb.de>
X-Provags-ID: V02:K0:HhDkHCu1eE0A7SoMXKzjJRFqjE3eTtONEcaxLKYUWB1
 rVN/owe4j0Hnbhk30MMvO6frBzN9Ys59DO/iQwBYc/cM5oOEUz
 OI7raVfPZ4DBOv2gpWFrIyoHBopRMDGyGAIfBss1M+zi61Q5Df
 0IprxKnRUsgLi173mg9GUTRz1SVYNpfKlsqVQpJs8YEELHWWHD
 VilTTgy8u3/7Orw4xdvP2Tc3VlmSZxuA43UMdW5TLhIvDwI8rq
 /ZxdgehJj5+psx8TCg/zJa9DSlEeaDZVB0yfAQehXTvWa5ZDYK
 9gknpnthqv48oAH66id8W2e5F+y89EUAaBUtB4k1mUeVizm90P
 KFcYMoC2QIWJUVdvlApA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three options USB_ARCH_HAS_{EHCI,OHCI,XHCI} are all well beyond
their recommended shelf life. They have caused numerous build failures
over the years because they are never completely correct, and with
the move to splitting out the platform specific back-ends out of the
driver, there is no real need for them any more. Also, the use of making
USB_ARCH_HAS_HCD depend on it is questionable since one can always enable
dummy_hc these days.

This patch enables them unconditionally for all platforms and
architectures, which means it is now possible to build host controller
drivers for machines that are known not to come with this hardware,
but that is just how we treat most other drivers.

In order to minimise the impact on existing architecture code and
defconfig files, all the Kconfig are left present for now. All platforms
that currently do 'select USB_ARCH_HAS_*' should subsequently be changed
not to select that. All drivers depending on USB_ARCH_HAS_HCD should
be changed to depend on USB_SUPPORT instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/Kconfig      | 69 ++++--------------------------------------
 drivers/usb/host/Kconfig |  3 ---
 2 files changed, 7 insertions(+), 65 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 92e1dc9..73f62ca 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -2,59 +2,15 @@
 # USB device configuration
 #
 
-# many non-PCI SOC chips embed OHCI
+# These are unused now, remove them once they are no longer selected
 config USB_ARCH_HAS_OHCI
-	boolean
-	# ARM:
-	default y if SA1111
-	default y if ARCH_OMAP
-	default y if ARCH_S3C24XX
-	default y if PXA27x
-	default y if PXA3xx
-	default y if ARCH_EP93XX
-	default y if ARCH_AT91
-	default y if MFD_TC6393XB
-	default y if ARCH_W90X900
-	default y if ARCH_DAVINCI_DA8XX
-	default y if ARCH_CNS3XXX
-	default y if PLAT_SPEAR
-	default y if ARCH_EXYNOS
-	# PPC:
-	default y if STB03xxx
-	default y if PPC_MPC52xx
-	# MIPS:
-	default y if MIPS_ALCHEMY
-	default y if MACH_JZ4740
-	# more:
-	default PCI
-
-# some non-PCI hcds implement EHCI
+	bool
+
 config USB_ARCH_HAS_EHCI
-	boolean
-	default y if FSL_SOC
-	default y if PPC_MPC512x
-	default y if ARCH_IXP4XX
-	default y if ARCH_W90X900
-	default y if ARCH_AT91
-	default y if ARCH_MXC
-	default y if ARCH_MXS
-	default y if ARCH_OMAP3
-	default y if ARCH_CNS3XXX
-	default y if ARCH_VT8500
-	default y if PLAT_SPEAR
-	default y if PLAT_S5P
-	default y if ARCH_MSM
-	default y if MICROBLAZE
-	default y if SPARC_LEON
-	default y if ARCH_MMP
-	default y if MACH_LOONGSON1
-	default y if PLAT_ORION
-	default PCI
-
-# some non-PCI HCDs implement xHCI
+	bool
+
 config USB_ARCH_HAS_XHCI
-	boolean
-	default PCI
+	bool
 
 menuconfig USB_SUPPORT
 	bool "USB support"
@@ -71,19 +27,8 @@ config USB_COMMON
 	default y
 	depends on USB || USB_GADGET
 
-# Host-side USB depends on having a host controller
-# NOTE:  dummy_hcd is always an option, but it's ignored here ...
-# NOTE:  SL-811 option should be board-specific ...
 config USB_ARCH_HAS_HCD
-	boolean
-	default y if USB_ARCH_HAS_OHCI
-	default y if USB_ARCH_HAS_EHCI
-	default y if USB_ARCH_HAS_XHCI
-	default y if PCMCIA && !M32R			# sl811_cs
-	default y if ARM				# SL-811
-	default y if BLACKFIN				# SL-811
-	default y if SUPERH				# r8a66597-hcd
-	default PCI
+	def_bool y
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
 config USB
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index e060ecf..254191f 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -17,7 +17,6 @@ config USB_C67X00_HCD
 
 config USB_XHCI_HCD
 	tristate "xHCI HCD (USB 3.0) support"
-	depends on USB_ARCH_HAS_XHCI
 	---help---
 	  The eXtensible Host Controller Interface (xHCI) is standard for USB 3.0
 	  "SuperSpeed" host controller hardware.
@@ -43,7 +42,6 @@ endif # USB_XHCI_HCD
 
 config USB_EHCI_HCD
 	tristate "EHCI HCD (USB 2.0) support"
-	depends on USB_ARCH_HAS_EHCI
 	---help---
 	  The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
 	  "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
@@ -361,7 +359,6 @@ config USB_FUSBH200_HCD
 
 config USB_OHCI_HCD
 	tristate "OHCI HCD (USB 1.1) support"
-	depends on USB_ARCH_HAS_OHCI
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
 	depends on USB_ISP1301 || !ARCH_LPC32XX
 	---help---
