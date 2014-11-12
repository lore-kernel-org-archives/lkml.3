Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbaKLBey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:34:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542AbaKLBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 3.17 247/319] xhci: no switching back on non-ULT Haswell
Date: Wed, 12 Nov 2014 10:16:25 +0900
Message-Id: <20141112011033.676641041@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit b45abacde3d551c6696c6738bef4a1805d0bf27a upstream.

The switch back is limited to ULT even on HP. The contrary
finding arose by bad luck in BIOS versions for testing.
This fixes spontaneous resume from S3 on some HP laptops.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -126,20 +126,6 @@ static void xhci_pci_quirks(struct devic
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


