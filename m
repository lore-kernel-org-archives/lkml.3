Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbaLLGka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:40:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51876 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759290AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oliver Neukum" <oneukum@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.417659599@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 112/164] xhci: no switching back on non-ULT Haswell
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit b45abacde3d551c6696c6738bef4a1805d0bf27a upstream.

The switch back is limited to ULT even on HP. The contrary
finding arose by bad luck in BIOS versions for testing.
This fixes spontaneous resume from S3 on some HP laptops.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c | 14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -118,20 +118,6 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 		xhci->quirks |= XHCI_AVOID_BEI;
 	}
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
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
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;

