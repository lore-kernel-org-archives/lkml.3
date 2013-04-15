Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3DOLuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:50:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53974 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3DOLup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:50:45 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <holler@ahsoftware.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/2] USB: ehci-omap: Don't select any PHY driver
Date: Mon, 15 Apr 2013 14:50:34 +0300
Message-ID: <1366026636-29198-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't select NOP_USB_XCEIV. Instead, board config
must select USB_PHY and the appropriate PHY driver.

Also add a hint in Kconfig so that users enabling
this driver manually enable the right PHY drivers as well.

Gets rid of the below warnings when USB_EHCI_HCD_OMAP
is enabled.

warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)

CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index c0be25c..c558472 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -150,11 +150,13 @@ config USB_EHCI_MXC
 config USB_EHCI_HCD_OMAP
 	tristate "EHCI support for OMAP3 and later chips"
 	depends on ARCH_OMAP
-	select NOP_USB_XCEIV
 	default y
 	---help---
 	  Enables support for the on-chip EHCI controller on
 	  OMAP3 and later chips.
+	  If your system uses a PHY on the USB port, you will need to
+	  enable USB_PHY and the appropriate PHY driver as well. Most
+	  boards need the NOP_USB_XCEIV PHY driver.
 
 config USB_EHCI_HCD_ORION
 	tristate  "Support for Marvell EBU on-chip EHCI USB controller"
-- 
1.7.4.1

