Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaBJURr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:17:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaBJTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jack Pham <jackp@codeaurora.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 016/124] usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()
Date: Mon, 10 Feb 2014 11:39:16 -0800
Message-Id: <1392061264-28124-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Pham <jackp@codeaurora.org>

commit 9005355af23856c55a5538c9024355785424821b upstream.

If CONFIG_PCI is enabled, make sure xhci_cleanup_msix()
doesn't try to free a bogus PCI IRQ or dereference an invalid
pci_dev when the xHCI device is actually a platform_device.

This patch should be backported to kernels as old as 3.9, that
contain the commit 52fb61250a7a132b0cfb9f4a1060a1f3c49e5a25
"xhci-plat: Don't enable legacy PCI interrupts."

Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4bade57..e00d140 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -315,6 +315,9 @@ static void xhci_cleanup_msix(struct xhci_hcd *xhci)
 	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
 
+	if (xhci->quirks & XHCI_PLAT)
+		return;
+
 	xhci_free_irq(xhci);
 
 	if (xhci->msix_entries) {
-- 
1.8.3.2

