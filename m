Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab3BHA6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:58:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab3BHA5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Moore <david.moore@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 34/34] usb: Prevent dead ports when xhci is not enabled
Date: Thu,  7 Feb 2013 16:57:30 -0800
Message-Id: <20130208004632.398811873@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -780,6 +780,7 @@ void usb_enable_xhci_ports(struct pci_de
 				"defaulting to EHCI.\n");
 		dev_warn(&xhci_pdev->dev,
 				"USB 3.0 devices will work at USB 2.0 speeds.\n");
+		usb_disable_xhci_ports(xhci_pdev);
 		return;
 	}
 


