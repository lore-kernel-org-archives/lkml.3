Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaFWIvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:51:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55538 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 053/111] usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports
Date: Mon, 23 Jun 2014 10:31:28 +0200
Message-Id: <ed7a0e4033fce15bec2424f3c6a7a5531e8b3203.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b38f09ccc3fd453180e96273bf3f34083c30809a upstream.

Sony VAIO t-series machines are not capable of switching usb2 ports over
from Intel EHCI to xHCI controller. If tried the USB2 port will be left
unconnected and unusable.

This patch should be backported to stable kernels as old as 3.12,
that contain the commit 26b76798e0507429506b93cd49f8c4cfdab06896
"Intel xhci: refactor EHCI/xHCI port switching"

Reported-by: Jorge <xxopxe@gmail.com>
Tested-by: Jorge <xxopxe@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/pci-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 463156d03140..f8763cc9d301 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -836,6 +836,13 @@ void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev)
 	bool		ehci_found = false;
 	struct pci_dev	*companion = NULL;
 
+	/* Sony VAIO t-series with subsystem device ID 90a8 is not capable of
+	 * switching ports from EHCI to xHCI
+	 */
+	if (xhci_pdev->subsystem_vendor == PCI_VENDOR_ID_SONY &&
+	    xhci_pdev->subsystem_device == 0x90a8)
+		return;
+
 	/* make sure an intel EHCI controller exists */
 	for_each_pci_dev(companion) {
 		if (companion->class == PCI_CLASS_SERIAL_USB_EHCI &&
-- 
2.0.0

