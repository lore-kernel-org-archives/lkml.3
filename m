Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaBGNbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:31:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbaBGLYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jack Pham <jackp@codeaurora.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 26/88] usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()
Date: Fri,  7 Feb 2014 11:22:23 +0000
Message-Id: <1391772205-22239-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8ef76d2..0d4c7e4 100644
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

