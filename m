Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422819AbaJaCt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:49:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:2098 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422772AbaJaCt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,291,1413270000"; 
   d="scan'208";a="614496256"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/3] usb: xhci: Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"
Date: Fri, 31 Oct 2014 10:38:56 +0800
Message-Id: <1414723138-62776-2-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414723138-62776-1-git-send-email-baolu.lu@linux.intel.com>
References: <1414723138-62776-1-git-send-email-baolu.lu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ff8cbf250b448aac35589f6075082c3fcad8a8fe.

Commit ff8cbf250b448aac35589f6075082c3fcad8a8fe triggers the bug logged at

https://bugzilla.kernel.org/show_bug.cgi?id=85701

Reported-by: Dmitry Nezhevenko <dion@inhex.net>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
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

