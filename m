Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaAFGWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:22:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:13062 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbaAFGSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:18:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="401364858"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Jiri Kosina <trivial@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part1 V3 08/20] iommu/vt-d, trivial: clean up unused code
Date: Mon,  6 Jan 2014 14:18:15 +0800
Message-Id: <1388989107-4795-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
References: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
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
index 5e7ba3b..f5f7b7d 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1113,8 +1113,6 @@ static const char *irq_remap_fault_reasons[] =
 	"Blocked an interrupt request due to source-id verification failure",
 };
 
-#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
-
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
 	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 3a0cf5d..751db33 100644
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

