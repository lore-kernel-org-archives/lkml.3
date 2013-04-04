Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774Ab3DDP6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:58:08 -0400
Received: from zmc.proxad.net ([212.27.53.206]:49910 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762612Ab3DDP5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:57:51 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, balbi@ti.com,
        Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 1/5 v3] USB: regroup all depends on USB within an if USB block
Date: Thu,  4 Apr 2013 17:57:24 +0200
Message-Id: <1365091048-16229-2-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365091048-16229-1-git-send-email-florian@openwrt.org>
References: <1365091048-16229-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the depends on USB from all config symbols in
drivers/usb/host/Kconfig and replace that with an if USB / endif block
as suggested by Alan Stern. Some source ... Kconfig lines have been
shuffled around to permit a better regroupment of the Kconfig files
depending on "config USB" item. No functionnal change is introduced.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since v2:
- properly keep USB_MUSB_HDRC dependency

Changes since v1:
- add missing if USB in drivers/usb/Kconfig before USB_USS720

Changes since RFC:
- only remove the "depends on USB" conditionnals and not more as
  the RFC patch did

 drivers/usb/Kconfig                |   23 +++++++++++++++--------
 drivers/usb/atm/Kconfig            |    2 +-
 drivers/usb/class/Kconfig          |    6 +-----
 drivers/usb/core/Kconfig           |    6 ------
 drivers/usb/host/Kconfig           |   30 +++++++++++-------------------
 drivers/usb/image/Kconfig          |    4 +---
 drivers/usb/misc/Kconfig           |   21 ---------------------
 drivers/usb/misc/sisusbvga/Kconfig |    2 +-
 drivers/usb/mon/Kconfig            |    1 -
 drivers/usb/musb/Kconfig           |    2 +-
 drivers/usb/renesas_usbhs/Kconfig  |    2 +-
 drivers/usb/serial/Kconfig         |    2 +-
 drivers/usb/storage/Kconfig        |    7 +++----
 drivers/usb/wusbcore/Kconfig       |    2 --
 14 files changed, 36 insertions(+), 74 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 640ae6c..24c14fc 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -122,9 +122,9 @@ config USB
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbcore.
 
-source "drivers/usb/core/Kconfig"
+if USB
 
-source "drivers/usb/dwc3/Kconfig"
+source "drivers/usb/core/Kconfig"
 
 source "drivers/usb/mon/Kconfig"
 
@@ -134,8 +134,6 @@ source "drivers/usb/host/Kconfig"
 
 source "drivers/usb/musb/Kconfig"
 
-source "drivers/usb/chipidea/Kconfig"
-
 source "drivers/usb/renesas_usbhs/Kconfig"
 
 source "drivers/usb/class/Kconfig"
@@ -144,12 +142,19 @@ source "drivers/usb/storage/Kconfig"
 
 source "drivers/usb/image/Kconfig"
 
+endif
+
+source "drivers/usb/dwc3/Kconfig"
+
+source "drivers/usb/chipidea/Kconfig"
+
 comment "USB port drivers"
-	depends on USB
+
+if USB
 
 config USB_USS720
 	tristate "USS720 parport driver"
-	depends on USB && PARPORT
+	depends on PARPORT
 	select PARPORT_NOT_PC
 	---help---
 	  This driver is for USB parallel port adapters that use the Lucent
@@ -180,10 +185,12 @@ source "drivers/usb/serial/Kconfig"
 
 source "drivers/usb/misc/Kconfig"
 
-source "drivers/usb/phy/Kconfig"
-
 source "drivers/usb/atm/Kconfig"
 
+endif # USB
+
+source "drivers/usb/phy/Kconfig"
+
 source "drivers/usb/gadget/Kconfig"
 
 source "drivers/usb/otg/Kconfig"
diff --git a/drivers/usb/atm/Kconfig b/drivers/usb/atm/Kconfig
index be0b8da..0f92294 100644
--- a/drivers/usb/atm/Kconfig
+++ b/drivers/usb/atm/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig USB_ATM
 	tristate "USB DSL modem support"
-	depends on USB && ATM
+	depends on ATM
 	select CRC32
 	default n
 	help
diff --git a/drivers/usb/class/Kconfig b/drivers/usb/class/Kconfig
index 316aac8..bb8b736 100644
--- a/drivers/usb/class/Kconfig
+++ b/drivers/usb/class/Kconfig
@@ -2,11 +2,10 @@
 # USB Class driver configuration
 #
 comment "USB Device Class drivers"
-	depends on USB
 
 config USB_ACM
 	tristate "USB Modem (CDC ACM) support"
-	depends on USB && TTY
+	depends on TTY
 	---help---
 	  This driver supports USB modems and ISDN adapters which support the
 	  Communication Device Class Abstract Control Model interface.
@@ -21,7 +20,6 @@ config USB_ACM
 
 config USB_PRINTER
 	tristate "USB Printer support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a USB printer to your computer's
 	  USB port.
@@ -31,7 +29,6 @@ config USB_PRINTER
 
 config USB_WDM
 	tristate "USB Wireless Device Management support"
-	depends on USB
 	---help---
 	  This driver supports the WMC Device Management functionality
 	  of cell phones compliant to the CDC WMC specification. You can use
@@ -42,7 +39,6 @@ config USB_WDM
 
 config USB_TMC
 	tristate "USB Test and Measurement Class support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a USB device that follows
 	  the USB.org specification for USB Test and Measurement devices
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 7b7305e..8772b36 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -3,7 +3,6 @@
 #
 config USB_DEBUG
 	bool "USB verbose debug messages"
-	depends on USB
 	help
 	  Say Y here if you want the USB core & hub drivers to produce a bunch
 	  of debug messages to the system log. Select this if you are having a
@@ -11,7 +10,6 @@ config USB_DEBUG
 
 config USB_ANNOUNCE_NEW_DEVICES
 	bool "USB announce new devices"
-	depends on USB
 	default N
 	help
 	  Say Y here if you want the USB core to always announce the
@@ -25,11 +23,9 @@ config USB_ANNOUNCE_NEW_DEVICES
 	  log, or have any doubts about this, say N here.
 
 comment "Miscellaneous USB options"
-	depends on USB
 
 config USB_DEFAULT_PERSIST
 	bool "Enable USB persist by default"
-	depends on USB
 	default y
 	help
 	  Say N here if you don't want USB power session persistance
@@ -45,7 +41,6 @@ config USB_DEFAULT_PERSIST
 
 config USB_DYNAMIC_MINORS
 	bool "Dynamic USB minor allocation"
-	depends on USB
 	help
 	  If you say Y here, the USB subsystem will use dynamic minor
 	  allocation for any device that uses the USB major number.
@@ -56,7 +51,6 @@ config USB_DYNAMIC_MINORS
 
 config USB_OTG
 	bool "OTG support"
-	depends on USB
 	depends on USB_SUSPEND
 	default n
 	help
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 2f68221..7f4ccf7 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -2,11 +2,9 @@
 # USB Host Controller Drivers
 #
 comment "USB Host Controller Drivers"
-	depends on USB
 
 config USB_C67X00_HCD
 	tristate "Cypress C67x00 HCD support"
-	depends on USB
 	help
 	  The Cypress C67x00 (EZ-Host/EZ-OTG) chips are dual-role
 	  host/peripheral/OTG USB controllers.
@@ -19,7 +17,7 @@ config USB_C67X00_HCD
 
 config USB_XHCI_HCD
 	tristate "xHCI HCD (USB 3.0) support"
-	depends on USB && USB_ARCH_HAS_XHCI
+	depends on USB_ARCH_HAS_XHCI
 	---help---
 	  The eXtensible Host Controller Interface (xHCI) is standard for USB 3.0
 	  "SuperSpeed" host controller hardware.
@@ -43,7 +41,7 @@ config USB_XHCI_HCD_DEBUGGING
 
 config USB_EHCI_HCD
 	tristate "EHCI HCD (USB 2.0) support"
-	depends on USB && USB_ARCH_HAS_EHCI
+	depends on USB_ARCH_HAS_EHCI
 	---help---
 	  The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
 	  "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
@@ -247,7 +245,7 @@ config USB_EHCI_ATH79
 
 config USB_OXU210HP_HCD
 	tristate "OXU210HP HCD support"
-	depends on USB && GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS
 	---help---
 	  The OXU210HP is an USB host/OTG/device controller. Enable this
 	  option if your board has this chip. If unsure, say N.
@@ -260,7 +258,6 @@ config USB_OXU210HP_HCD
 
 config USB_ISP116X_HCD
 	tristate "ISP116X HCD support"
-	depends on USB
 	---help---
 	  The ISP1160 and ISP1161 chips are USB host controllers. Enable this
 	  option if your board has this chip. If unsure, say N.
@@ -272,7 +269,6 @@ config USB_ISP116X_HCD
 
 config USB_ISP1760_HCD
 	tristate "ISP 1760 HCD support"
-	depends on USB
 	---help---
 	  The ISP1760 chip is a USB 2.0 host controller.
 
@@ -287,7 +283,6 @@ config USB_ISP1760_HCD
 
 config USB_ISP1362_HCD
 	tristate "ISP1362 HCD support"
-	depends on USB
 	default N
 	---help---
 	  Supports the Philips ISP1362 chip as a host controller
@@ -299,7 +294,7 @@ config USB_ISP1362_HCD
 
 config USB_OHCI_HCD
 	tristate "OHCI HCD support"
-	depends on USB && USB_ARCH_HAS_OHCI
+	depends on USB_ARCH_HAS_OHCI
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
 	select USB_OTG_UTILS if ARCH_OMAP
 	depends on USB_ISP1301 || !ARCH_LPC32XX
@@ -458,7 +453,7 @@ config USB_OHCI_LITTLE_ENDIAN
 
 config USB_UHCI_HCD
 	tristate "UHCI HCD (most Intel and VIA) support"
-	depends on USB && (PCI || SPARC_LEON || ARCH_VT8500)
+	depends on PCI || SPARC_LEON || ARCH_VT8500
 	---help---
 	  The Universal Host Controller Interface is a standard by Intel for
 	  accessing the USB hardware in the PC (which is also called the USB
@@ -498,7 +493,7 @@ config USB_UHCI_BIG_ENDIAN_DESC
 
 config USB_FHCI_HCD
 	tristate "Freescale QE USB Host Controller support"
-	depends on USB && OF_GPIO && QE_GPIO && QUICC_ENGINE
+	depends on OF_GPIO && QE_GPIO && QUICC_ENGINE
 	select FSL_GTM
 	select QE_USB
 	help
@@ -515,7 +510,7 @@ config FHCI_DEBUG
 
 config USB_U132_HCD
 	tristate "Elan U132 Adapter Host Controller"
-	depends on USB && USB_FTDI_ELAN
+	depends on USB_FTDI_ELAN
 	default M
 	help
 	  The U132 adapter is a USB to CardBus adapter specifically designed
@@ -543,7 +538,6 @@ config USB_U132_HCD
 
 config USB_SL811_HCD
 	tristate "SL811HS HCD support"
-	depends on USB
 	help
 	  The SL811HS is a single-port USB controller that supports either
 	  host side or peripheral side roles.  Enable this option if your
@@ -575,7 +569,6 @@ config USB_SL811_CS
 
 config USB_R8A66597_HCD
 	tristate "R8A66597 HCD support"
-	depends on USB
 	help
 	  The R8A66597 is a USB 2.0 host and peripheral controller.
 
@@ -587,7 +580,6 @@ config USB_R8A66597_HCD
 
 config USB_RENESAS_USBHS_HCD
 	tristate "Renesas USBHS HCD support"
-	depends on USB
 	depends on USB_RENESAS_USBHS
 	help
 	  The Renesas USBHS is a USB 2.0 host and peripheral controller.
@@ -612,7 +604,7 @@ config USB_WHCI_HCD
 
 config USB_HWA_HCD
 	tristate "Host Wire Adapter (HWA) driver"
-	depends on USB && UWB
+	depends on UWB
 	select USB_WUSB
 	select UWB_HWA
 	help
@@ -626,7 +618,7 @@ config USB_HWA_HCD
 
 config USB_IMX21_HCD
        tristate "i.MX21 HCD support"
-       depends on USB && ARM && ARCH_MXC
+       depends on ARM && ARCH_MXC
        help
          This driver enables support for the on-chip USB host in the
          i.MX21 processor.
@@ -636,7 +628,7 @@ config USB_IMX21_HCD
 
 config USB_OCTEON_EHCI
 	bool "Octeon on-chip EHCI support"
-	depends on USB && USB_EHCI_HCD && CPU_CAVIUM_OCTEON
+	depends on USB_EHCI_HCD && CPU_CAVIUM_OCTEON
 	default n
 	select USB_EHCI_BIG_ENDIAN_MMIO
 	help
@@ -647,7 +639,7 @@ config USB_OCTEON_EHCI
 
 config USB_OCTEON_OHCI
 	bool "Octeon on-chip OHCI support"
-	depends on USB && USB_OHCI_HCD && CPU_CAVIUM_OCTEON
+	depends on USB_OHCI_HCD && CPU_CAVIUM_OCTEON
 	default USB_OCTEON_EHCI
 	select USB_OHCI_BIG_ENDIAN_MMIO
 	select USB_OHCI_LITTLE_ENDIAN
diff --git a/drivers/usb/image/Kconfig b/drivers/usb/image/Kconfig
index 33350f9..320d368 100644
--- a/drivers/usb/image/Kconfig
+++ b/drivers/usb/image/Kconfig
@@ -2,11 +2,9 @@
 # USB Imaging devices configuration
 #
 comment "USB Imaging devices"
-	depends on USB
 
 config USB_MDC800
 	tristate "USB Mustek MDC800 Digital Camera support"
-	depends on USB
 	---help---
 	  Say Y here if you want to connect this type of still camera to
 	  your computer's USB port. This driver can be used with gphoto 0.4.3
@@ -19,7 +17,7 @@ config USB_MDC800
 
 config USB_MICROTEK
 	tristate "Microtek X6USB scanner support"
-	depends on USB && SCSI
+	depends on SCSI
 	help
 	  Say Y here if you want support for the Microtek X6USB and
 	  possibly the Phantom 336CX, Phantom C6 and ScanMaker V6U(S)L.
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 3b1a3f4..a51e7d6 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -2,11 +2,9 @@
 # USB Miscellaneous driver configuration
 #
 comment "USB Miscellaneous drivers"
-	depends on USB
 
 config USB_EMI62
 	tristate "EMI 6|2m USB Audio interface support"
-	depends on USB
 	---help---
 	  This driver loads firmware to Emagic EMI 6|2m low latency USB
 	  Audio and Midi interface.
@@ -21,7 +19,6 @@ config USB_EMI62
 
 config USB_EMI26
 	tristate "EMI 2|6 USB Audio interface support"
-	depends on USB
 	---help---
 	  This driver loads firmware to Emagic EMI 2|6 low latency USB
 	  Audio interface.
@@ -34,7 +31,6 @@ config USB_EMI26
 
 config USB_ADUTUX
 	tristate "ADU devices from Ontrak Control Systems"
-	depends on USB
 	help
 	  Say Y if you want to use an ADU device from Ontrak Control
 	  Systems.
@@ -44,7 +40,6 @@ config USB_ADUTUX
 
 config USB_SEVSEG
 	tristate "USB 7-Segment LED Display"
-	depends on USB
 	help
 	  Say Y here if you have a USB 7-Segment Display by Delcom
 
@@ -53,7 +48,6 @@ config USB_SEVSEG
 
 config USB_RIO500
 	tristate "USB Diamond Rio500 support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a USB Rio500 mp3 player to your
 	  computer's USB port. Please read <file:Documentation/usb/rio.txt>
@@ -64,7 +58,6 @@ config USB_RIO500
 
 config USB_LEGOTOWER
 	tristate "USB Lego Infrared Tower support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a USB Lego Infrared Tower to your
 	  computer's USB port.
@@ -77,7 +70,6 @@ config USB_LEGOTOWER
 
 config USB_LCD
 	tristate "USB LCD driver support"
-	depends on USB
 	help
 	  Say Y here if you want to connect an USBLCD to your computer's
 	  USB port. The USBLCD is a small USB interface board for
@@ -89,7 +81,6 @@ config USB_LCD
 
 config USB_LED
 	tristate "USB LED driver support"
-	depends on USB
 	help
 	  Say Y here if you want to connect an USBLED device to your 
 	  computer's USB port.
@@ -99,7 +90,6 @@ config USB_LED
 
 config USB_CYPRESS_CY7C63
 	tristate "Cypress CY7C63xxx USB driver support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a Cypress CY7C63xxx
 	  micro controller to your computer's USB port. Currently this
@@ -113,7 +103,6 @@ config USB_CYPRESS_CY7C63
 
 config USB_CYTHERM
 	tristate "Cypress USB thermometer driver support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a Cypress USB thermometer
 	  device to your computer's USB port. This device is also known
@@ -126,7 +115,6 @@ config USB_CYTHERM
 
 config USB_IDMOUSE
 	tristate "Siemens ID USB Mouse Fingerprint sensor support"
-	depends on USB
 	help
 	  Say Y here if you want to use the fingerprint sensor on
 	  the Siemens ID Mouse. There is also a Siemens ID Mouse
@@ -140,7 +128,6 @@ config USB_IDMOUSE
 
 config USB_FTDI_ELAN
 	tristate "Elan PCMCIA CardBus Adapter USB Client"
-	depends on USB
 	default M
 	help
 	  ELAN's Uxxx series of adapters are USB to PCMCIA CardBus adapters.
@@ -164,7 +151,6 @@ config USB_FTDI_ELAN
 
 config USB_APPLEDISPLAY
 	tristate "Apple Cinema Display support"
-	depends on USB
 	select BACKLIGHT_LCD_SUPPORT
 	select BACKLIGHT_CLASS_DEVICE
 	help
@@ -175,7 +161,6 @@ source "drivers/usb/misc/sisusbvga/Kconfig"
 
 config USB_LD
 	tristate "USB LD driver"
-	depends on USB
 	help
 	  This driver is for generic USB devices that use interrupt transfers,
 	  like LD Didactic's USB devices.
@@ -185,7 +170,6 @@ config USB_LD
 
 config USB_TRANCEVIBRATOR
 	tristate "PlayStation 2 Trance Vibrator driver support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a PlayStation 2 Trance Vibrator
 	  device to your computer's USB port.
@@ -195,7 +179,6 @@ config USB_TRANCEVIBRATOR
 
 config USB_IOWARRIOR
 	tristate "IO Warrior driver support"
-	depends on USB
 	help
 	  Say Y here if you want to support the IO Warrior devices from Code
 	  Mercenaries.  This includes support for the following devices:
@@ -209,7 +192,6 @@ config USB_IOWARRIOR
 
 config USB_TEST
 	tristate "USB testing driver"
-	depends on USB
 	help
 	  This driver is for testing host controller software.  It is used
 	  with specialized device firmware for regression and stress testing,
@@ -220,7 +202,6 @@ config USB_TEST
 
 config USB_ISIGHTFW
 	tristate "iSight firmware loading support"
-	depends on USB
 	select FW_LOADER
 	help
 	  This driver loads firmware for USB Apple iSight cameras, allowing
@@ -233,7 +214,6 @@ config USB_ISIGHTFW
 
 config USB_YUREX
 	tristate "USB YUREX driver support"
-	depends on USB
 	help
 	  Say Y here if you want to connect a YUREX to your computer's
 	  USB port. The YUREX is a leg-shakes sensor. See
@@ -246,7 +226,6 @@ config USB_YUREX
 
 config USB_EZUSB_FX2
 	tristate "Functions for loading firmware on EZUSB chips"
-	depends on USB
 	help
 	  Say Y here if you need EZUSB device support.
 	  (Cypress FX/FX2/FX2LP microcontrollers)
diff --git a/drivers/usb/misc/sisusbvga/Kconfig b/drivers/usb/misc/sisusbvga/Kconfig
index 30ea7ca..0d03a52 100644
--- a/drivers/usb/misc/sisusbvga/Kconfig
+++ b/drivers/usb/misc/sisusbvga/Kconfig
@@ -1,7 +1,7 @@
 
 config USB_SISUSBVGA
 	tristate "USB 2.0 SVGA dongle support (Net2280/SiS315)"
-	depends on USB && (USB_MUSB_HDRC || USB_EHCI_HCD)
+	depends on (USB_MUSB_HDRC || USB_EHCI_HCD)
         ---help---
 	  Say Y here if you intend to attach a USB2VGA dongle based on a
 	  Net2280 and a SiS315 chip.
diff --git a/drivers/usb/mon/Kconfig b/drivers/usb/mon/Kconfig
index 635745f..5c6ffa2 100644
--- a/drivers/usb/mon/Kconfig
+++ b/drivers/usb/mon/Kconfig
@@ -4,7 +4,6 @@
 
 config USB_MON
 	tristate "USB Monitor"
-	depends on USB
 	help
 	  If you select this option, a component which captures the USB traffic
 	  between peripheral-specific drivers and HC drivers will be built.
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 05e5143..4636ab9 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -6,7 +6,7 @@
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
-	depends on USB && USB_GADGET
+	depends on USB_GADGET
 	select USB_OTG_UTILS
 	help
 	  Say Y here if your system has a dual role high speed USB
diff --git a/drivers/usb/renesas_usbhs/Kconfig b/drivers/usb/renesas_usbhs/Kconfig
index 29feb00..019bf7e 100644
--- a/drivers/usb/renesas_usbhs/Kconfig
+++ b/drivers/usb/renesas_usbhs/Kconfig
@@ -4,7 +4,7 @@
 
 config USB_RENESAS_USBHS
 	tristate 'Renesas USBHS controller'
-	depends on USB && USB_GADGET && GENERIC_HARDIRQS
+	depends on USB_GADGET && GENERIC_HARDIRQS
 	default n
 	help
 	  Renesas USBHS is a discrete USB host and peripheral controller chip
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 17b7f9a..bf37336 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig USB_SERIAL
 	tristate "USB Serial Converter support"
-	depends on USB && TTY
+	depends on TTY
 	---help---
 	  Say Y here if you have a USB device that provides normal serial
 	  ports, or acts like a serial device, and you want to connect it to
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index eab04a6..8470e1b 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -4,11 +4,10 @@
 
 comment "NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may"
 comment "also be needed; see USB_STORAGE Help for more info"
-	depends on USB
 
 config USB_STORAGE
 	tristate "USB Mass Storage support"
-	depends on USB && SCSI
+	depends on SCSI
 	---help---
 	  Say Y here if you want to connect USB mass storage devices to your
 	  computer's USB port. This is the driver you need for USB
@@ -188,7 +187,7 @@ config USB_STORAGE_CYPRESS_ATACB
 
 config USB_STORAGE_ENE_UB6250
 	tristate "USB ENE card reader support"
-	depends on USB && SCSI
+	depends on SCSI
 	depends on USB_STORAGE
 	---help---
 	  Say Y here if you wish to control a ENE SD/MS Card reader.
@@ -203,7 +202,7 @@ config USB_STORAGE_ENE_UB6250
 
 config USB_UAS
 	tristate "USB Attached SCSI"
-	depends on USB && SCSI && BROKEN
+	depends on SCSI && BROKEN
 	help
 	  The USB Attached SCSI protocol is supported by some USB
 	  storage devices.  It permits higher performance by supporting
diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
index 8bf1976..0e17b96 100644
--- a/drivers/usb/wusbcore/Kconfig
+++ b/drivers/usb/wusbcore/Kconfig
@@ -3,7 +3,6 @@
 #
 config USB_WUSB
 	tristate "Enable Wireless USB extensions"
-	depends on USB
 	depends on PCI
 	depends on UWB
         select CRYPTO
@@ -19,7 +18,6 @@ config USB_WUSB
 
 config USB_WUSB_CBAF
 	tristate "Support WUSB Cable Based Association (CBA)"
-	depends on USB
 	help
 	  Some WUSB devices support Cable Based Association. It's used to
 	  enable the secure communication between the host and the
-- 
1.7.10.4

