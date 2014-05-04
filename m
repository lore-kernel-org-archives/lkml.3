Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaEDPr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:47:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaEDPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:43:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.4 31/43] xhci: extend quirk for Renesas cards
Date: Sun,  4 May 2014 11:42:25 -0400
Message-Id: <20140504154228.496032617@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-pci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -135,9 +135,7 @@ static void xhci_pci_quirks(struct devic
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


