Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaGDJWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:22:14 -0400
Received: from 8bytes.org ([85.214.48.195]:42137 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaGDJWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:22:13 -0400
Date: Fri, 4 Jul 2014 11:22:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] trivial cleanup for iommu/vt-d
Message-ID: <20140704092209.GA13434@8bytes.org>
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  4 11:22:10 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b6724220865582432342
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 08:37:46PM +0800, Yijing Wang wrote:
> 
> Yijing Wang (6):
>   iommu/vt-d: Use list_for_each_safe() to simplify code
>   iommu/vt-d: move up no_iommu and dmar_disabled check
>   iommu/vt-d: clear the redundant assignment in dmar_enable_qi
>   iommu/vt-d: clear the redundant assignment for domain->nid
>   iommu/vt-d: use inline function dma_pte_superpage instead of macros
>   iommu/vt-d: fix reference count in iommu_prepare_isa

Applied patches 1, 3, 4, 5 and 6, thanks. Also added another patch
on-top, see below.

>From 77c704bebc5d023ece7af32ea18bc3508cdb0007 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Fri, 4 Jul 2014 11:19:10 +0200
Subject: [PATCH] iommu/vt-d: Don't use magic number in dma_pte_superpage

Use the already defined DMA_PTE_LARGE_PAGE for testing
instead of hardcoding the value again.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 9b9f28e..5d86e93 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -304,7 +304,7 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 
 static inline bool dma_pte_superpage(struct dma_pte *pte)
 {
-	return (pte->val & (1 << 7));
+	return (pte->val & DMA_PTE_LARGE_PAGE);
 }
 
 static inline int first_pte_in_page(struct dma_pte *pte)
-- 
1.8.4.5


