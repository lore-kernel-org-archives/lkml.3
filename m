Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab3BSTSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:18:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382Ab3BSSuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Moore <david.moore@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 05/81] usb: Prevent dead ports when xhci is not enabled
Date: Tue, 19 Feb 2013 15:48:28 -0300
Message-Id: <1361299784-8830-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Moore <david.moore@gmail.com>

commit 58b2939b4d5a030eaec469d29812ab8477ee7e76 upstream.

When the xHCI driver is not available, actively switch the ports to EHCI
mode since some BIOSes leave them in xHCI mode where they would
otherwise appear dead.  This was discovered on a  Dell Optiplex 7010,
but it's possible other systems could be affected.

This should be backported to kernels as old as 3.0, that contain the
commit 69e848c2090aebba5698a1620604c7dccb448684 "Intel xhci: Support
EHCI/xHCI port switching."

Signed-off-by: David Moore <david.moore@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/pci-quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index eb5563a..7893351 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -780,6 +780,7 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 				"defaulting to EHCI.\n");
 		dev_warn(&xhci_pdev->dev,
 				"USB 3.0 devices will work at USB 2.0 speeds.\n");
+		usb_disable_xhci_ports(xhci_pdev);
 		return;
 	}
 
-- 
1.7.9.5

