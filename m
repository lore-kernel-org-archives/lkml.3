Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbaLBT1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:27:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933881AbaLBT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:27:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Denis Turischev <denis@compulab.co.il>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 027/121] xhci: Switch only Intel Lynx Point-LP ports to EHCI on shutdown.
Date: Tue,  2 Dec 2014 11:18:26 -0800
Message-Id: <1417548000-1794-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Turischev <denis.turischev@compulab.co.il>

commit 0a939993bff117d3657108ca13b011fc0378aedb upstream.

Patch "xhci: Switch Intel Lynx Point ports to EHCI on shutdown."
commit c09ec25d3684cad74d851c0f028a495999591279 is not fully correct

It switches both Lynx Point and Lynx Point-LP ports to EHCI on shutdown.
On some Lynx Point machines it causes spurious interrupt,
which wake the system: bugzilla.kernel.org/show_bug.cgi?id=76291

On Lynx Point-LP on the contrary switching ports to EHCI seems to be
necessary to fix these spurious interrupts.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
Reported-by: Wulf Richartz <wulf.richartz@gmail.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 3fc8d9e..21223f8 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -138,7 +138,9 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
 			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
-
+	}
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+		pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI) {
 		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-- 
1.9.1

