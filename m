Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaCGHrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:47:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaCGHrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:47:35 -0500
Date: Fri, 7 Mar 2014 08:49:32 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2] ioat: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140307074932.GC2670@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <2ba22558b5db90740d5833c35570c3e7cc1e359e.1394128952.git.agordeev@redhat.com>
 <CAPcyv4jW19zxApviDdbofbXB1OvvN2sCriL3Paszfk9o3T8x0w@mail.gmail.com>
 <20140306214356.GA16376@dhcp-26-207.brq.redhat.com>
 <CAPcyv4ivvxHvyT_5oybVvRJAUKABQQ1ZH4Eua-1KVDeri5kpkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ivvxHvyT_5oybVvRJAUKABQQ1ZH4Eua-1KVDeri5kpkA@mail.gmail.com>
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

Function pci_enable_msix() returns a tri-state value while
pci_enable_msi_exact() is a canonical zero/-errno variant.
The former is being phased out in favor of the latter.
In case of 'ioat' there (should be) no difference.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 4e3549a..b76c148 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -947,7 +947,7 @@ msix:
 	for (i = 0; i < msixcnt; i++)
 		device->msix_entries[i].entry = i;
 
-	err = pci_enable_msix(pdev, device->msix_entries, msixcnt);
+	err = pci_enable_msix_exact(pdev, device->msix_entries, msixcnt);
 	if (err)
 		goto msi;
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
