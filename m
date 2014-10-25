Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaJYSZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:25:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:35697 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaJYSZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:25:15 -0400
X-IronPort-AV: E=Sophos;i="5.04,786,1406592000"; 
   d="scan'208";a="184886127"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 2/7] xen/arm: remove outer_*_range call
Date: Sat, 25 Oct 2014 14:57:17 +0100
Message-ID: <1414245442-4306-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410251450180.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410251450180.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dom0 is not actually capable of issuing outer_inv_range or
outer_clean_range calls.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/arm/xen/mm32.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index a5a93fc..6153d61 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -61,9 +61,6 @@ static void __xen_dma_page_dev_to_cpu(struct device *hwdev, dma_addr_t handle,
 	/* Cannot use __dma_page_dev_to_cpu because we don't have a
 	 * struct page for handle */
 
-	if (dir != DMA_TO_DEVICE)
-		outer_inv_range(handle, handle + size);
-
 	dma_cache_maint(handle & PAGE_MASK, handle & ~PAGE_MASK, size, dir, dmac_unmap_area);
 }
 
@@ -72,12 +69,6 @@ static void __xen_dma_page_cpu_to_dev(struct device *hwdev, dma_addr_t handle,
 {
 
 	dma_cache_maint(handle & PAGE_MASK, handle & ~PAGE_MASK, size, dir, dmac_map_area);
-
-	if (dir == DMA_FROM_DEVICE) {
-		outer_inv_range(handle, handle + size);
-	} else {
-		outer_clean_range(handle, handle + size);
-	}
 }
 
 void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
-- 
1.7.10.4

