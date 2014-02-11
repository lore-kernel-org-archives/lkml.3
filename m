Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaBKMiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:38:51 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:52389 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaBKMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:38:49 -0500
Message-ID: <1392122327.13064.14.camel@x220>
Subject: [PATCH] [TRIVIAL] Kconfig: Remove useless "default N" lines
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Walch <walch.martin@web.de>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 13:38:47 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 12:38:48.0251 (UTC) FILETIME=[35D648B0:01CF2726]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of Kconfig entries default to (uppercase) "N". It was clearly
intended to use "default n". But since (lowercase) "n" is the default
anyway, these lines might as well be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested on a Fedora 20-based .config, where it was a NOP. But there's a
chance that none of the entries I touch here influence that .config. I
didn't check.

This patch deserves a
    Reported-by: Martin Walch <walch.martin@web.de>

line, but that apparently requires Martin's permission.

 arch/arc/Kconfig                          | 1 -
 arch/cris/arch-v32/drivers/Kconfig        | 2 --
 drivers/misc/mic/Kconfig                  | 2 --
 drivers/staging/android/Kconfig           | 2 --
 drivers/staging/bcm/Kconfig               | 1 -
 drivers/staging/frontier/Kconfig          | 1 -
 drivers/staging/media/go7007/Kconfig      | 3 ---
 drivers/staging/rtl8187se/Kconfig         | 1 -
 drivers/staging/rtl8188eu/Kconfig         | 1 -
 drivers/staging/rtl8192e/rtl8192e/Kconfig | 1 -
 drivers/staging/rtl8192u/Kconfig          | 1 -
 drivers/staging/rtl8712/Kconfig           | 2 --
 drivers/staging/rtl8821ae/Kconfig         | 1 -
 drivers/staging/usbip/Kconfig             | 4 ----
 drivers/usb/core/Kconfig                  | 1 -
 drivers/usb/host/Kconfig                  | 3 ---
 16 files changed, 27 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 9be30c8..75de197 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -356,7 +356,6 @@ config ARC_CURR_IN_REG
 
 config ARC_MISALIGN_ACCESS
 	bool "Emulate unaligned memory access (userspace only)"
-	default N
 	select SYSCTL_ARCH_UNALIGN_NO_WARN
 	select SYSCTL_ARCH_UNALIGN_ALLOW
 	help
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 6792503..15a9ed1 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -11,7 +11,6 @@ config ETRAX_ETHERNET
 config ETRAX_NO_PHY
 	bool "PHY not present"
 	depends on ETRAX_ETHERNET
-	default N
 	help
 	  This option disables all MDIO communication with an ethernet
 	  transceiver connected to the MII interface. This option shall
@@ -116,7 +115,6 @@ config ETRAX_AXISFLASHMAP
 config ETRAX_AXISFLASHMAP_MTD0WHOLE
 	bool "MTD0 is whole boot flash device"
 	depends on ETRAX_AXISFLASHMAP
-	default N
 	help
 	  When this option is not set, mtd0 refers to the first partition
 	  on the boot flash device. When set, mtd0 refers to the whole
diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index e42b331..462a5b1 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -4,7 +4,6 @@ config INTEL_MIC_HOST
 	tristate "Intel MIC Host Driver"
 	depends on 64BIT && PCI && X86
 	select VHOST_RING
-	default N
 	help
 	  This enables Host Driver support for the Intel Many Integrated
 	  Core (MIC) family of PCIe form factor coprocessor devices that
@@ -25,7 +24,6 @@ config INTEL_MIC_CARD
 	tristate "Intel MIC Card Driver"
 	depends on 64BIT && X86
 	select VIRTIO
-	default N
 	help
 	  This enables card driver support for the Intel Many Integrated
 	  Core (MIC) device family. The card driver communicates shutdown/
diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index b91c758..b6b8692 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -2,7 +2,6 @@ menu "Android"
 
 config ANDROID
 	bool "Android Drivers"
-	default N
 	---help---
 	  Enable support for various drivers needed on the Android platform
 
@@ -60,7 +59,6 @@ config ANDROID_TIMED_GPIO
 
 config ANDROID_LOW_MEMORY_KILLER
 	bool "Android Low Memory Killer"
-	default N
 	---help---
 	  Registers processes to be killed when memory is low
 
diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
index 83c9752..8acf4b2 100644
--- a/drivers/staging/bcm/Kconfig
+++ b/drivers/staging/bcm/Kconfig
@@ -1,7 +1,6 @@
 config BCM_WIMAX
        tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
        depends on USB && NET
-       default N
        help
          This is an experimental driver for the Beceem WIMAX chipset used
 	 by Sprint 4G.
diff --git a/drivers/staging/frontier/Kconfig b/drivers/staging/frontier/Kconfig
index 7121853..4da290b 100644
--- a/drivers/staging/frontier/Kconfig
+++ b/drivers/staging/frontier/Kconfig
@@ -1,6 +1,5 @@
 config TRANZPORT
 	tristate "Frontier Tranzport and Alphatrack support"
 	depends on USB
-	default N
 	---help---
 	  Enable support for the Frontier Tranzport and Alphatrack devices.
diff --git a/drivers/staging/media/go7007/Kconfig b/drivers/staging/media/go7007/Kconfig
index 04bd0fb..95a3af6 100644
--- a/drivers/staging/media/go7007/Kconfig
+++ b/drivers/staging/media/go7007/Kconfig
@@ -13,7 +13,6 @@ config VIDEO_GO7007
 	select VIDEO_TW9906 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_OV7640 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_UDA1342 if MEDIA_SUBDRV_AUTOSELECT
-	default N
 	---help---
 	  This is a video4linux driver for the WIS GO7007 MPEG
 	  encoder chip.
@@ -24,7 +23,6 @@ config VIDEO_GO7007
 config VIDEO_GO7007_USB
 	tristate "WIS GO7007 USB support"
 	depends on VIDEO_GO7007 && USB
-	default N
 	---help---
 	  This is a video4linux driver for the WIS GO7007 MPEG
 	  encoder chip over USB.
@@ -46,7 +44,6 @@ config VIDEO_GO7007_LOADER
 config VIDEO_GO7007_USB_S2250_BOARD
 	tristate "Sensoray 2250/2251 support"
 	depends on VIDEO_GO7007_USB && USB
-	default N
 	---help---
 	  This is a video4linux driver for the Sensoray 2250/2251 device.
 
diff --git a/drivers/staging/rtl8187se/Kconfig b/drivers/staging/rtl8187se/Kconfig
index 3162aab..ff8d41e 100644
--- a/drivers/staging/rtl8187se/Kconfig
+++ b/drivers/staging/rtl8187se/Kconfig
@@ -6,6 +6,5 @@ config R8187SE
 	select WEXT_PRIV
 	select EEPROM_93CX6
 	select CRYPTO
-	default N
 	---help---
 	  If built as a module, it will be called r8187se.ko.
diff --git a/drivers/staging/rtl8188eu/Kconfig b/drivers/staging/rtl8188eu/Kconfig
index 9a57d31..e45c106 100644
--- a/drivers/staging/rtl8188eu/Kconfig
+++ b/drivers/staging/rtl8188eu/Kconfig
@@ -3,7 +3,6 @@ config R8188EU
 	depends on WLAN && USB
 	select WIRELESS_EXT
 	select WEXT_PRIV
-	default N
 	---help---
 	This option adds the Realtek RTL8188EU USB device such as TP-Link TL-WN725N.
 	If built as a module, it will be called r8188eu.
diff --git a/drivers/staging/rtl8192e/rtl8192e/Kconfig b/drivers/staging/rtl8192e/rtl8192e/Kconfig
index 50e0d91..ad82bc3 100644
--- a/drivers/staging/rtl8192e/rtl8192e/Kconfig
+++ b/drivers/staging/rtl8192e/rtl8192e/Kconfig
@@ -5,5 +5,4 @@ config RTL8192E
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select CRYPTO
-	default N
 	---help---
diff --git a/drivers/staging/rtl8192u/Kconfig b/drivers/staging/rtl8192u/Kconfig
index 3f05509..3ee9d0d 100644
--- a/drivers/staging/rtl8192u/Kconfig
+++ b/drivers/staging/rtl8192u/Kconfig
@@ -5,5 +5,4 @@ config RTL8192U
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select CRYPTO
-	default N
 	---help---
diff --git a/drivers/staging/rtl8712/Kconfig b/drivers/staging/rtl8712/Kconfig
index 6a43312..f160eee 100644
--- a/drivers/staging/rtl8712/Kconfig
+++ b/drivers/staging/rtl8712/Kconfig
@@ -4,7 +4,6 @@ config R8712U
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER
-	default N
 	---help---
 	This option adds the Realtek RTL8712 USB device such as the D-Link DWA-130.
 	If built as a module, it will be called r8712u.
@@ -12,7 +11,6 @@ config R8712U
 config R8712_TX_AGGR
 	bool "Realtek RTL8712U Transmit Aggregation code"
 	depends on R8712U && BROKEN
-	default N
 	---help---
 	This option provides transmit aggregation for the Realtek RTL8712 USB device.
 
diff --git a/drivers/staging/rtl8821ae/Kconfig b/drivers/staging/rtl8821ae/Kconfig
index 2aa5dac..4679fd8 100644
--- a/drivers/staging/rtl8821ae/Kconfig
+++ b/drivers/staging/rtl8821ae/Kconfig
@@ -6,6 +6,5 @@ config R8821AE
 	select WEXT_PRIV
 	select EEPROM_93CX6
 	select CRYPTO
-	default N
 	---help---
 	  If built as a module, it will be called r8821ae.ko.
diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
index 8860009..bd99e9e 100644
--- a/drivers/staging/usbip/Kconfig
+++ b/drivers/staging/usbip/Kconfig
@@ -1,7 +1,6 @@
 config USBIP_CORE
 	tristate "USB/IP support"
 	depends on USB && NET
-	default N
 	---help---
 	  This enables pushing USB packets over IP to allow remote
 	  machines direct access to USB devices. It provides the
@@ -18,7 +17,6 @@ config USBIP_CORE
 config USBIP_VHCI_HCD
 	tristate "VHCI hcd"
 	depends on USBIP_CORE
-	default N
 	---help---
 	  This enables the USB/IP virtual host controller driver,
 	  which is run on the remote machine.
@@ -29,7 +27,6 @@ config USBIP_VHCI_HCD
 config USBIP_HOST
 	tristate "Host driver"
 	depends on USBIP_CORE
-	default N
 	---help---
 	  This enables the USB/IP host driver, which is run on the
 	  machine that is sharing the USB devices.
@@ -40,6 +37,5 @@ config USBIP_HOST
 config USBIP_DEBUG
 	bool "Debug messages for USB/IP"
 	depends on USBIP_CORE
-	default N
 	---help---
 	  This enables the debug messages from the USB/IP drivers.
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index fed7f68..cb8e991 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -10,7 +10,6 @@ config USB_DEBUG
 
 config USB_ANNOUNCE_NEW_DEVICES
 	bool "USB announce new devices"
-	default N
 	help
 	  Say Y here if you want the USB core to always announce the
 	  idVendor, idProduct, Manufacturer, Product, and SerialNumber
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index e22b826..3d9e540 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -314,7 +314,6 @@ config USB_ISP1760_HCD
 
 config USB_ISP1362_HCD
 	tristate "ISP1362 HCD support"
-	default N
 	---help---
 	  Supports the Philips ISP1362 chip as a host controller
 
@@ -326,7 +325,6 @@ config USB_ISP1362_HCD
 config USB_FUSBH200_HCD
 	tristate "FUSBH200 HCD support"
 	depends on USB
-	default N
 	---help---
 	Faraday FUSBH200 is designed to meet USB2.0 EHCI specification
 	with minor modification.
@@ -337,7 +335,6 @@ config USB_FUSBH200_HCD
 config USB_FOTG210_HCD
 	tristate "FOTG210 HCD support"
 	depends on USB
-	default N
 	---help---
 	  Faraday FOTG210 is an OTG controller which can be configured as
 	  an USB2.0 host. It is designed to meet USB2.0 EHCI specification
-- 
1.8.5.3

