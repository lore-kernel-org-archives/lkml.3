Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaKEFRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 00:17:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:40266 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaKEFRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 00:17:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,317,1413270000"; 
   d="scan'208";a="602495048"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v3 1/3] usb: xhci: Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"
Date: Wed,  5 Nov 2014 13:07:14 +0800
Message-Id: <1415164036-68517-2-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415164036-68517-1-git-send-email-baolu.lu@linux.intel.com>
References: <1415164036-68517-1-git-send-email-baolu.lu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ff8cbf250b448aac35589f6075082c3fcad8a8fe.

Commit ff8cbf250b448aac35589f6075082c3fcad8a8fe triggers the bug logged at

https://bugzilla.kernel.org/show_bug.cgi?id=85701

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reported-by: Dmitry Nezhevenko <dion@inhex.net>
---
 drivers/usb/host/xhci-hub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 696160d..388cfd8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -22,7 +22,6 @@
 
 
 #include <linux/slab.h>
-#include <linux/device.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -1149,9 +1148,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
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
-- 
1.9.1

