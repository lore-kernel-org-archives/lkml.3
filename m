Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaDVMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:13:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:4921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbaDVMMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:12:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="421964544"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <sarah.a.sharp@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <agordeev@redhat.com>, linux-pci@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/5] xhci: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Tue, 22 Apr 2014 15:22:59 +0300
Message-Id: <1398169382-12097-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
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
index 988ed5f..b0b8399 100644
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

