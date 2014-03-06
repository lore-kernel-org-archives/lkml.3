Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaCFUJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:09:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaCFUJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:09:35 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 1/4] ioat: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Thu,  6 Mar 2014 21:11:21 +0100
Message-Id: <2ba22558b5db90740d5833c35570c3e7cc1e359e.1394128952.git.agordeev@redhat.com>
In-Reply-To: <cover.1394128952.git.agordeev@redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
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

