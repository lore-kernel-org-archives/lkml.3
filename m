Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaFWIkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55584 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Denis Turischev <denis@compulab.co.il>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 006/111] xhci: Switch only Intel Lynx Point-LP ports to EHCI on shutdown.
Date: Mon, 23 Jun 2014 10:30:41 +0200
Message-Id: <d0f30eb91a4beef22aa86c89a21d2492832f33c9.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Turischev <denis.turischev@compulab.co.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 17447ef59d08..f34b42e4c391 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -134,7 +134,9 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
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
2.0.0

