Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab3CZSHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:07:13 -0400
Received: from zmc.proxad.net ([212.27.53.206]:48382 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab3CZSHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:07:09 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [RFC PATCH 5/5] USB: enclose USB_XHCI_HCD related symbols within a if USB_XHCI_HCD block
Date: Tue, 26 Mar 2013 19:06:17 +0100
Message-Id: <1364321177-12146-6-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364321177-12146-1-git-send-email-florian@openwrt.org>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
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
index c5dfc08..be7b7cc 100644
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

