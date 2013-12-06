Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3LFDYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:24:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab3LFDU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:20:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986919"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiri Kosina <trivial@kernel.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 08/20] iommu/vt-d, trivial: clean up unused code
Date: Fri,  6 Dec 2013 11:21:11 +0800
Message-Id: <1386300083-6882-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code from VT-d related files.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c        |    2 --
 drivers/iommu/intel-iommu.c |   25 -------------------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 70612a9..9a76073 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1121,8 +1121,6 @@ static const char *irq_remap_fault_reasons[] =
 	"Blocked an interrupt request due to source-id verification failure",
 };
 
-#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
-
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
 	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 68bce9d..b5f13e4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -289,26 +289,6 @@ static inline void dma_clear_pte(struct dma_pte *pte)
 	pte->val = 0;
 }
 
-static inline void dma_set_pte_readable(struct dma_pte *pte)
-{
-	pte->val |= DMA_PTE_READ;
-}
-
-static inline void dma_set_pte_writable(struct dma_pte *pte)
-{
-	pte->val |= DMA_PTE_WRITE;
-}
-
-static inline void dma_set_pte_snp(struct dma_pte *pte)
-{
-	pte->val |= DMA_PTE_SNP;
-}
-
-static inline void dma_set_pte_prot(struct dma_pte *pte, unsigned long prot)
-{
-	pte->val = (pte->val & ~3) | (prot & 3);
-}
-
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
@@ -319,11 +299,6 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)
 #endif
 }
 
-static inline void dma_set_pte_pfn(struct dma_pte *pte, unsigned long pfn)
-{
-	pte->val |= (uint64_t)pfn << VTD_PAGE_SHIFT;
-}
-
 static inline bool dma_pte_present(struct dma_pte *pte)
 {
 	return (pte->val & 3) != 0;
-- 
1.7.10.4

