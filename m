Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966596AbaLLG5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:57:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51762 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758704AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lu Baolu" <baolu.lu@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Dmitry Nezhevenko" <dion@inhex.net>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.179299143@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 147/164] Revert "xhci: clear root port wake on bits if
 controller isn't wake-up capable"
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-hub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/gfp.h>
-#include <linux/device.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -996,9 +995,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 			t2 |= PORT_LINK_STROBE | XDEV_U3;
 			set_bit(port_index, &bus_state->bus_suspended);
 		}
-		if (hcd->self.root_hub->do_remote_wakeup
-				&& device_may_wakeup(hcd->self.controller)) {
-
+		if (hcd->self.root_hub->do_remote_wakeup) {
 			if (t1 & PORT_CONNECT) {
 				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
 				t2 &= ~PORT_WKCONN_E;

