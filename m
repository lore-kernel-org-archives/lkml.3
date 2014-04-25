Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaDYQLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:11:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:62757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaDYQLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="519795130"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <sarah.a.sharp@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2 3/4] xhci: extend quirk for Renesas cards
Date: Fri, 25 Apr 2014 19:20:15 +0300
Message-Id: <1398442816-32538-4-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Igor Gnatenko <i.gnatenko.brain@gmail.com>

After suspend another Renesas PCI-X USB 3.0 card doesn't work.
[root@fedora-20 ~]# lspci -vmnnd 1912:
Device:	03:00.0
Class:	USB controller [0c03]
Vendor:	Renesas Technology Corp. [1912]
Device:	uPD720202 USB 3.0 Host Controller [0015]
SVendor:	Renesas Technology Corp. [1912]
SDevice:	uPD720202 USB 3.0 Host Controller [0015]
Rev:	02
ProgIf:	30

This patch should be applied to stable kernel 3.14 that contain
the commit 1aa9578c1a9450fb21501c4f549f5b1edb557e6d
"xhci: Fix resume issues on Renesas chips in Samsung laptops"

Reported-and-tested-by: Anatoly Kharchenko <rfr-bugs@yandex.ru>
Reference: http://redmine.russianfedora.pro/issues/1315
Signed-off-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Cc: stable@vger.kernel.org # 3.14
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 1715063..35d4477 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -145,9 +145,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
-			pdev->device == 0x0015 &&
-			pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
-			pdev->subsystem_device == 0xc0cd)
+			pdev->device == 0x0015)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
-- 
1.8.3.2

