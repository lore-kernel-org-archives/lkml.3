Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbaLOTbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:31:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40854 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaLOTbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:31:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 50/96] Revert "xhci: clear root port wake on bits if controller isn't wake-up capable"
Date: Mon, 15 Dec 2014 11:26:10 -0800
Message-Id: <1418671616-25482-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-hub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index e44be08..44f152d 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/gfp.h>
-#include <linux/device.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -1147,9 +1146,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
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

