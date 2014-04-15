Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaDOXJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:09:44 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:44316 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaDOXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:09:30 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH 1/8] Fix a few existing lines that checkpatch.pl will complain about later.
Date: Tue, 15 Apr 2014 17:09:02 -0600
Message-Id: <1397603349-30930-2-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
References: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things like:
1. no space before tabs
2. no initialization of static variables to 0 or NULL
3. no extra parentheses around the value on the 'return' statement
4. no line over 80-characters

Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a22c86c..8abcb6c 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -72,7 +72,7 @@
    to match. That way, we can use 'unsigned long' for PFNs with impunity. */
 #define DOMAIN_MAX_PFN(gaw)	((unsigned long) min_t(uint64_t, \
 				__DOMAIN_MAX_PFN(gaw), (unsigned long)-1))
-#define DOMAIN_MAX_ADDR(gaw)	(((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
+#define DOMAIN_MAX_ADDR(gaw) (((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
 #define DMA_32BIT_PFN		IOVA_PFN(DMA_BIT_MASK(32))
@@ -175,7 +175,7 @@ static int rwbf_quirk;
  * set to 1 to panic kernel if can't successfully enable VT-d
  * (used when kernel is launched w/ TXT)
  */
-static int force_on = 0;
+static int force_on;
 
 /*
  * 0: Present
@@ -190,7 +190,7 @@ struct root_entry {
 #define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
 static inline bool root_present(struct root_entry *root)
 {
-	return (root->val & 1);
+	return root->val & 1;
 }
 static inline void set_root_present(struct root_entry *root)
 {
@@ -228,7 +228,7 @@ struct context_entry {
 
 static inline bool context_present(struct context_entry *context)
 {
-	return (context->lo & 1);
+	return context->lo & 1;
 }
 static inline void context_set_present(struct context_entry *context)
 {
@@ -306,7 +306,7 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 
 static inline bool dma_pte_superpage(struct dma_pte *pte)
 {
-	return (pte->val & (1 << 7));
+	return pte->val & (1 << 7);
 }
 
 static inline int first_pte_in_page(struct dma_pte *pte)
@@ -317,7 +317,7 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 /*
  * This domain is a statically identity mapping domain.
  *	1. This domain creats a static 1:1 mapping to all usable memory.
- * 	2. It maps to each iommu if successful.
+ *	2. It maps to each iommu if successful.
  *	3. Each iommu mapps to this domain if successful.
  */
 static struct dmar_domain *si_domain;
@@ -347,7 +347,7 @@ struct dmar_domain {
 	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
 					/* bitmap of iommus this domain uses*/
 
-	struct list_head devices; 	/* all devices' list */
+	struct list_head devices;	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
 
 	struct dma_pte	*pgd;		/* virtual address */
-- 
Bill Sumner <bill.sumner@hp.com>

