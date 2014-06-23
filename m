Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaFWIwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55541 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/111] xhci: extend quirk for Renesas cards
Date: Mon, 23 Jun 2014 10:30:38 +0200
Message-Id: <66c90702b5e15aa1ca070dcee38164d10e366a5e.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Igor Gnatenko <i.gnatenko.brain@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: stable@vger.kernel.org # 3.14
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 67394da1c645..17447ef59d08 100644
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
2.0.0

