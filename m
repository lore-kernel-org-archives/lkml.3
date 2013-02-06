Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3BFQYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:44 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36223 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab3BFQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:36 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 13/15] drivers/usb: add missing GENERIC_HARDIRQS dependencies
Date: Wed,  6 Feb 2013 17:24:01 +0100
Message-Id: <1360167843-3587-14-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-4966-0000-0000-000004D4555D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple of missing GENERIC_HARDIRQS dependencies to fix link
errors like below on s390:

ERROR: "devm_request_threaded_irq" [drivers/usb/gadget/mv_udc.ko] undefined!

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/usb/dwc3/Kconfig          |    2 +-
 drivers/usb/gadget/Kconfig        |    3 ++-
 drivers/usb/host/Kconfig          |    2 +-
 drivers/usb/musb/Kconfig          |    1 +
 drivers/usb/renesas_usbhs/Kconfig |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 77e3f40..68e9a2c 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -1,6 +1,6 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
-	depends on (USB || USB_GADGET)
+	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS
 	select USB_OTG_UTILS
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 5e4f879..d3d95de 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -319,6 +319,7 @@ config USB_S3C_HSUDC
 
 config USB_MV_UDC
 	tristate "Marvell USB2.0 Device Controller"
+	depends on GENERIC_HARDIRQS
 	help
 	  Marvell Socs (including PXA and MMP series) include a high speed
 	  USB2.0 OTG controller, which can be configured as high speed or
@@ -440,7 +441,7 @@ config USB_GOKU
 
 config USB_EG20T
 	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7831) UDC"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	help
 	  This is a USB device driver for EG20T PCH.
 	  EG20T PCH is the platform controller hub that is used in Intel's
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3a21c5d..c59a112 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -246,7 +246,7 @@ config USB_EHCI_ATH79
 
 config USB_OXU210HP_HCD
 	tristate "OXU210HP HCD support"
-	depends on USB
+	depends on USB && GENERIC_HARDIRQS
 	---help---
 	  The OXU210HP is an USB host/OTG/device controller. Enable this
 	  option if your board has this chip. If unsure, say N.
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index de6e5ce..45b19e2 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -46,6 +46,7 @@ config USB_MUSB_DA8XX
 
 config USB_MUSB_TUSB6010
 	tristate "TUSB6010"
+	depends on GENERIC_HARDIRQS
 
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
diff --git a/drivers/usb/renesas_usbhs/Kconfig b/drivers/usb/renesas_usbhs/Kconfig
index 6f4afa4..29feb00 100644
--- a/drivers/usb/renesas_usbhs/Kconfig
+++ b/drivers/usb/renesas_usbhs/Kconfig
@@ -4,7 +4,7 @@
 
 config USB_RENESAS_USBHS
 	tristate 'Renesas USBHS controller'
-	depends on USB && USB_GADGET
+	depends on USB && USB_GADGET && GENERIC_HARDIRQS
 	default n
 	help
 	  Renesas USBHS is a discrete USB host and peripheral controller chip
-- 
1.7.10.4

