Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3BQXLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:11:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45589 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422Ab3BQWy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:54:58 -0500
Message-Id: <20130217225002.259338794@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:06 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, David Moore <david.moore@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 05/66] usb: Prevent dead ports when xhci is not enabled
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/pci-quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index a3b6d71..4c338ec 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -780,6 +780,7 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 				"defaulting to EHCI.\n");
 		dev_warn(&xhci_pdev->dev,
 				"USB 3.0 devices will work at USB 2.0 speeds.\n");
+		usb_disable_xhci_ports(xhci_pdev);
 		return;
 	}
 


