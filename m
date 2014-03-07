Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaCGHqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:46:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaCGHqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:46:12 -0500
Date: Fri, 7 Mar 2014 08:48:06 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 2/2] xhci: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140307074806.GB2670@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <606a52afdccf627b6273379b21daffc460b9559a.1394128952.git.agordeev@redhat.com>
 <20140306215646.GA23294@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306215646.GA23294@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/usb/host/xhci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6fbba7a..dc7cfb5 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -292,7 +292,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 		xhci->msix_entries[i].vector = 0;
 	}
 
-	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
+	ret = pci_enable_msix_exact(pdev, xhci->msix_entries, xhci->msix_count);
 	if (ret) {
 		xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 				"Failed to enable MSI-X");
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
