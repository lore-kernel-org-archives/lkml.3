Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaBUQTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:19:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbaBUQTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:19:22 -0500
Date: Fri, 21 Feb 2014 17:21:19 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2] ioat: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140221162118.GA17353@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-2-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392804931-30671-2-git-send-email-agordeev@redhat.com>
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
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/dma/ioat/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 8752918..7bc9e6f 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -909,7 +909,7 @@ msix:
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
