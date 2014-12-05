Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaLEWrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:47:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaLEWqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Dmitry Nezhevenko <dion@inhex.net>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.17 101/122] Revert "xhci: clear root port wake on bits if controller isnt wake-up capable"
Date: Fri,  5 Dec 2014 14:44:35 -0800
Message-Id: <20141205223321.148102332@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 9b41ebd3cf0f68d8cad779d3eeba336f78262e43 upstream.

commit ff8cbf250b44 ("xhci: clear root port wake on bits if controller isn't")
can cause device detection error if runtime PM is enabled, and S3 wake
is disabled. Revert it.
https://bugzilla.kernel.org/show_bug.cgi?id=85701

This commit got into stable and should be reverted from there as well.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reported-by: Dmitry Nezhevenko <dion@inhex.net>
[Mathias Nyman: reword commit message]
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -22,7 +22,6 @@
 
 
 #include <linux/slab.h>
-#include <linux/device.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -1142,9 +1141,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 		 * including the USB 3.0 roothub, but only if CONFIG_PM_RUNTIME
 		 * is enabled, so also enable remote wake here.
 		 */
-		if (hcd->self.root_hub->do_remote_wakeup
-				&& device_may_wakeup(hcd->self.controller)) {
-
+		if (hcd->self.root_hub->do_remote_wakeup) {
 			if (t1 & PORT_CONNECT) {
 				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
 				t2 &= ~PORT_WKCONN_E;


