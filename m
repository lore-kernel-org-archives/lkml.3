Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaBSKNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbaBSKNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:13:41 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH] ioat: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:22 +0100
Message-Id: <1392804931-30671-2-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/dma/ioat/dma.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 8752918..af0d8b1 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -909,8 +909,9 @@ msix:
 	for (i = 0; i < msixcnt; i++)
 		device->msix_entries[i].entry = i;
 
-	err = pci_enable_msix(pdev, device->msix_entries, msixcnt);
-	if (err)
+	err = pci_enable_msix_range(pdev,
+				    device->msix_entries, msixcnt, msixcnt);
+	if (err < 0)
 		goto msi;
 
 	for (i = 0; i < msixcnt; i++) {
-- 
1.7.7.6

