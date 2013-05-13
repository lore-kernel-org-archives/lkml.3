Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3EMIna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:43:30 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:63669 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab3EMIn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:43:29 -0400
Message-ID: <1368434606.1350.31.camel@x61.thuisdomein>
Subject: [PATCH] usb: phy: remove CONFIG_USB_OTG_UTILS once more
From: Paul Bolle <pebolle@tiscali.nl>
To: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 10:43:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 08:43:26.0837 (UTC) FILETIME=[EFA20250:01CE4FB5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol USB_OTG_UTILS was removed in the v3.10 merge window,
in commit fd89149875 ("usb: phy: remove CONFIG_USB_OTG_UTILS"). But that
symbol popped up again in a few places. Remove it there too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/staging/dwc2/Kconfig | 1 -
 drivers/usb/gadget/Kconfig   | 1 -
 drivers/usb/phy/Kconfig      | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/staging/dwc2/Kconfig b/drivers/staging/dwc2/Kconfig
index f0b4739..bbee177 100644
--- a/drivers/staging/dwc2/Kconfig
+++ b/drivers/staging/dwc2/Kconfig
@@ -2,7 +2,6 @@ config USB_DWC2
 	tristate "DesignWare USB2 DRD Core Support"
 	depends on USB
 	depends on VIRT_TO_BUS
-	select USB_OTG_UTILS
 	help
 	  Say Y or M here if your system has a Dual Role HighSpeed
 	  USB controller based on the DesignWare HSOTG IP Core.
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 83300d9..f41aa0d 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -146,7 +146,6 @@ config USB_LPC32XX
 	depends on ARCH_LPC32XX
 	depends on USB_PHY
 	select USB_ISP1301
-	select USB_OTG_UTILS
 	help
 	   This option selects the USB device controller in the LPC32xx SoC.
 
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 371d0e7..5053cea 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -139,7 +139,6 @@ config USB_ISP1301
 	tristate "NXP ISP1301 USB transceiver support"
 	depends on USB || USB_GADGET
 	depends on I2C
-	select USB_OTG_UTILS
 	help
 	  Say Y here to add support for the NXP ISP1301 USB transceiver driver.
 	  This chip is typically used as USB transceiver for USB host, gadget
-- 
1.7.11.7

