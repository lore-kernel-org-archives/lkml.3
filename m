Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaKYMCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:02:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaKYKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 025/254] xhci: no switching back on non-ULT Haswell
Date: Tue, 25 Nov 2014 10:36:15 +0000
Message-Id: <1416912004-5928-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit b45abacde3d551c6696c6738bef4a1805d0bf27a upstream.

The switch back is limited to ULT even on HP. The contrary
finding arose by bad luck in BIOS versions for testing.
This fixes spontaneous resume from S3 on some HP laptops.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index ea14b663c8b2..d71aa5a97f0d 100644
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
2.1.0

