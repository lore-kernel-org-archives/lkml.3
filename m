Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbaEGNO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:14:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaEGNOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 47/70] xhci: extend quirk for Renesas cards
Date: Wed,  7 May 2014 14:12:50 +0100
Message-Id: <1399468393-10140-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Gnatenko <i.gnatenko.brain@gmail.com>

commit 6db249ebefc6bf5c39f35dfaacc046d8ad3ffd70 upstream.

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
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index bed96e9..8d5f45e 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -140,9 +140,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
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
1.9.1

