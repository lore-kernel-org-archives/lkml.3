Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaEHQSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:18:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:34560 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaEHQPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979621"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>,
        Alexander Gordeev <agordeev@redhat.com>, linux-pci@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 05/10] xhci: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Thu,  8 May 2014 19:25:58 +0300
Message-Id: <1399566363-25837-6-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 708cb29..88ec076 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -291,7 +291,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 		xhci->msix_entries[i].vector = 0;
 	}
 
-	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
+	ret = pci_enable_msix_exact(pdev, xhci->msix_entries, xhci->msix_count);
 	if (ret) {
 		xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 				"Failed to enable MSI-X");
-- 
1.8.3.2

