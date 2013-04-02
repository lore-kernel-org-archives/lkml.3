Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008Ab3DBRG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:06:27 -0400
Received: from zmc.proxad.net ([212.27.53.206]:51572 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761846Ab3DBRFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:05:43 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 5/5] USB: enclose USB_XHCI_HCD related symbols within a if USB_XHCI_HCD block
Date: Tue,  2 Apr 2013 19:05:13 +0200
Message-Id: <1364922314-30639-6-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364922314-30639-1-git-send-email-florian@openwrt.org>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
 <1364922314-30639-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch encloses all symbols depending on USB_XHCI_HCD within an if
USB_XHCI_HCD / endif block.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 475c508..a96a979 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -25,13 +25,13 @@ config USB_XHCI_HCD
 	  To compile this driver as a module, choose M here: the
 	  module will be called xhci-hcd.
 
+if USB_XHCI_HCD
+
 config USB_XHCI_PLATFORM
 	tristate
-	depends on USB_XHCI_HCD
 
 config USB_XHCI_HCD_DEBUGGING
 	bool "Debugging for the xHCI host controller"
-	depends on USB_XHCI_HCD
 	---help---
 	  Say 'Y' to turn on debugging for the xHCI host controller driver.
 	  This will spew debugging output, even in interrupt context.
@@ -39,6 +39,8 @@ config USB_XHCI_HCD_DEBUGGING
 
 	  If unsure, say N.
 
+endif # USB_XHCI_HCD
+
 config USB_EHCI_HCD
 	tristate "EHCI HCD (USB 2.0) support"
 	depends on USB_ARCH_HAS_EHCI
-- 
1.7.10.4

