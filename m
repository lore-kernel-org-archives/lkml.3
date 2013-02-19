Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab3BSSuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab3BSSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 03/81] drivers: xhci: fix incorrect bit test
Date: Tue, 19 Feb 2013 15:48:26 -0300
Message-Id: <1361299784-8830-4-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

commit ba7b5c22d33136a5612ca5ef8d31564dcc501126 upstream.

Fix incorrect bit test that originally showed up in
4ee823b83bc9851743fab756c76b27d6a1e2472b "USB/xHCI: Support
device-initiated USB 3.0 resume."

Use '&' instead of '&&'.

This should be backported to kernels as old as 3.4.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 3dc8e3f..5530c76 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1698,7 +1698,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 				faked_port_index + 1);
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
-		if (bus_state->port_remote_wakeup && (1 << faked_port_index)) {
+		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
 			bus_state->port_remote_wakeup &=
 				~(1 << faked_port_index);
 			xhci_test_and_clear_bit(xhci, port_array,
-- 
1.7.9.5

