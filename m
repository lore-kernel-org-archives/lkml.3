Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3CZRre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:47:34 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:40330 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755990Ab3CZRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:47:32 -0400
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 13:47:32 EDT
From: Roland Stigge <stigge@antcom.de>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] usb: Fix compile error by selecting USB_OTG_UTILS
Date: Tue, 26 Mar 2013 18:36:01 +0100
Message-Id: <1364319361-28265-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current lpc32xx_defconfig breaks like this, caused by recent phy
restructuring:

  LD      init/built-in.o
drivers/built-in.o: In function `usb_hcd_nxp_probe':
drivers/usb/host/ohci-nxp.c:224: undefined reference to `isp1301_get_client'
drivers/built-in.o: In function `lpc32xx_udc_probe':
drivers/usb/gadget/lpc32xx_udc.c:3104: undefined reference to
`isp1301_get_client' distcc[27867] ERROR: compile (null) on localhost failed
make: *** [vmlinux] Error 1

This patch fixes this by selecting USB_OTG_UTILS in Kconfig which
causes the phy driver to be built again.

Signed-off-by: Roland Stigge <stigge@antcom.de>

--
Applies to v3.9-rc4

---
 drivers/usb/gadget/Kconfig |    1 +
 drivers/usb/phy/Kconfig    |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.orig/drivers/usb/gadget/Kconfig
+++ linux-2.6/drivers/usb/gadget/Kconfig
@@ -145,6 +145,7 @@ config USB_LPC32XX
 	tristate "LPC32XX USB Peripheral Controller"
 	depends on ARCH_LPC32XX
 	select USB_ISP1301
+	select USB_OTG_UTILS
 	help
 	   This option selects the USB device controller in the LPC32xx SoC.
 
--- linux-2.6.orig/drivers/usb/phy/Kconfig
+++ linux-2.6/drivers/usb/phy/Kconfig
@@ -38,6 +38,7 @@ config USB_ISP1301
 	tristate "NXP ISP1301 USB transceiver support"
 	depends on USB || USB_GADGET
 	depends on I2C
+	select USB_OTG_UTILS
 	help
 	  Say Y here to add support for the NXP ISP1301 USB transceiver driver.
 	  This chip is typically used as USB transceiver for USB host, gadget
