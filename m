Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861Ab3BHBMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:12:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab3BHA5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nickolai Zeldovich <nickolai@csail.mit.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 30/34] drivers: xhci: fix incorrect bit test
Date: Thu,  7 Feb 2013 16:57:26 -0800
Message-Id: <20130208004631.971945985@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1698,7 +1698,7 @@ static void handle_port_status(struct xh
 				faked_port_index + 1);
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
-		if (bus_state->port_remote_wakeup && (1 << faked_port_index)) {
+		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
 			bus_state->port_remote_wakeup &=
 				~(1 << faked_port_index);
 			xhci_test_and_clear_bit(xhci, port_array,


