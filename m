Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967096Ab3E2VPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:15:35 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48937 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966939Ab3E2VPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:15:23 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/2] USB: xhci: show firmware version for Renesas XHCI hosts if debug is enabled
Date: Wed, 29 May 2013 23:14:33 +0200
Message-Id: <1369862073-3685-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369862073-3685-1-git-send-email-holler@ahsoftware.de>
References: <1369862073-3685-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They support the same vendor specific command as former NEC hosts.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/usb/host/xhci-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index f47d3d2..9977cee 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -78,7 +78,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 
-	if (pdev->vendor == PCI_VENDOR_ID_NEC)
+	if (pdev->vendor == PCI_VENDOR_ID_NEC ||
+			pdev->vendor == PCI_VENDOR_ID_RENESAS)
 		xhci->quirks |= XHCI_NEC_SHOW_FW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD && xhci->hci_version == 0x96)
-- 
1.8.1.5

