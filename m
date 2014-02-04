Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaBDVsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:48:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405AbaBDVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Pham <jackp@codeaurora.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.13 023/140] usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()
Date: Tue,  4 Feb 2014 13:10:10 -0800
Message-Id: <20140204211037.625096602@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -321,6 +321,9 @@ static void xhci_cleanup_msix(struct xhc
 	struct usb_hcd *hcd = xhci_to_hcd(xhci);
 	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
 
+	if (xhci->quirks & XHCI_PLAT)
+		return;
+
 	xhci_free_irq(xhci);
 
 	if (xhci->msix_entries) {


