Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3FZI7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:59:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39931 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3FZI7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:59:05 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: host: xhci-plat: Enable XHCI_SPURIOUS_SUCCESS quirk for xhci-plat
Date: Wed, 26 Jun 2013 14:28:57 +0530
Message-ID: <1372237137-17351-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synopsis xhci controllers with hci_version > 0.96 gives spurious success
events on short packet completion. During webcam capture the
"ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
The same application works fine with synopsis controllers hci_version 0.96.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/host/xhci-plat.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 93ad67e..e63c6d3 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -25,6 +25,16 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 	 * dev struct in order to setup MSI
 	 */
 	xhci->quirks |= XHCI_BROKEN_MSI;
+
+	/*
+	 * In some xhci controllers which follows xhci 1.0 spec gives a spurious
+	 * success event after a short transfer. This quirk will ignore such
+	 * spurious event. Hit this issue in synopsis xhci controllers with
+	 * hci_version > 0.96
+	 */
+
+	if (xhci->hci_version > 0x96)
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 }
 
 /* called during probe() after chip reset completes */
-- 
1.8.1.4

