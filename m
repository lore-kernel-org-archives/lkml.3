Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaDVMNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:13:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:20724 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbaDVMMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:12:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="421964571"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <sarah.a.sharp@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4/5] xhci: extend quirk for Renesas cards
Date: Tue, 22 Apr 2014 15:23:01 +0300
Message-Id: <1398169382-12097-5-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
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

Reported-and-tested-by: Anatoly Kharchenko <rfr-bugs@yandex.ru>
Reference: http://redmine.russianfedora.pro/issues/1315
Signed-off-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
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

