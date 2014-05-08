Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaEHQSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:18:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:57040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbaEHQPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979654"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 06/10] xhci: Report max device limit when Enable Slot command fails.
Date: Thu,  8 May 2014 19:25:59 +0300
Message-Id: <1399566363-25837-7-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

xHCI host controllers may only support a limited number of device slot
IDs, which is usually far less than the theoretical maximum number of
devices (255) that the USB specifications advertise.  This is
frustrating to consumers that expect to be able to plug in a large
number of devices.

Add a print statement when the Enable Slot command fails to show how
many devices the host supports.  We can't change hardware manufacturer's
design decisions, but hopefully we can save customers a little bit of
time trying to debug why their host mysteriously fails when too many
devices are plugged in.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Amund Hov <Amund.Hov@silabs.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 88ec076..92e1dda 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3696,6 +3696,9 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 
 	if (!xhci->slot_id) {
 		xhci_err(xhci, "Error while assigning device slot ID\n");
+		xhci_err(xhci, "Max number of devices this xHCI host supports is %u.\n",
+				HCS_MAX_SLOTS(
+					readl(&xhci->cap_regs->hcs_params1)));
 		return 0;
 	}
 
-- 
1.8.3.2

