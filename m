Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbaLBT1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:27:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810AbaLBT04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 028/121] xhci: no switching back on non-ULT Haswell
Date: Tue,  2 Dec 2014 11:18:27 -0800
Message-Id: <1417548000-1794-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit b45abacde3d551c6696c6738bef4a1805d0bf27a upstream.

The switch back is limited to ULT even on HP. The contrary
finding arose by bad luck in BIOS versions for testing.
This fixes spontaneous resume from S3 on some HP laptops.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 21223f8..4588815 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -126,20 +126,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_AVOID_BEI;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    (pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI)) {
-		/* Workaround for occasional spurious wakeups from S5 (or
-		 * any other sleep) on Haswell machines with LPT and LPT-LP
-		 * with the new Intel BIOS
-		 */
-		/* Limit the quirk to only known vendors, as this triggers
-		 * yet another BIOS bug on some other machines
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=66171
-		 */
-		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
-			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
-	}
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 		pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI) {
 		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 	}
-- 
1.9.1

