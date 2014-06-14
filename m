Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbaFNV61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:58:27 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:22816 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbaFNV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:58:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8IAIjEnFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZFnhz2BAxd1hAsCJC8jgQkRN4hGAc9NhWOJEx2ELQSPbIdygmWLMIgogX6BRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH 1/1] drivers/iommu/omap-iovmm.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Date: Sat, 14 Jun 2014 23:58:34 +0200
Message-Id: <1402783114-11261-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/iommu/omap-iovmm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index d147259..f583ba0 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -131,7 +131,7 @@ static unsigned sgtable_nents(size_t bytes, u32 da, u32 pa)
 {
 	unsigned nr_entries = 0, ent_sz;
 
-	if (!IS_ALIGNED(bytes, PAGE_SIZE)) {
+	if (!PAGE_ALIGNED(bytes)) {
 		pr_err("%s: wrong size %08x\n", __func__, bytes);
 		return 0;
 	}
@@ -159,7 +159,7 @@ static struct sg_table *sgtable_alloc(const size_t bytes, u32 flags,
 	if (!bytes)
 		return ERR_PTR(-EINVAL);
 
-	if (!IS_ALIGNED(bytes, PAGE_SIZE))
+	if (!PAGE_ALIGNED(bytes))
 		return ERR_PTR(-EINVAL);
 
 	if (flags & IOVMF_LINEAR) {
@@ -514,7 +514,7 @@ static void unmap_iovm_area(struct iommu_domain *domain, struct omap_iommu *obj,
 	size_t unmapped;
 
 	BUG_ON(!sgtable_ok(sgt));
-	BUG_ON((!total) || !IS_ALIGNED(total, PAGE_SIZE));
+	BUG_ON((!total) || !PAGE_ALIGNED(total));
 
 	start = area->da_start;
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
@@ -529,7 +529,7 @@ static void unmap_iovm_area(struct iommu_domain *domain, struct omap_iommu *obj,
 		dev_dbg(obj->dev, "%s: unmap %08x(%x) %08x\n",
 				__func__, start, bytes, area->flags);
 
-		BUG_ON(!IS_ALIGNED(bytes, PAGE_SIZE));
+		BUG_ON(!PAGE_ALIGNED(bytes));
 
 		total -= bytes;
 		start += bytes;
@@ -545,7 +545,7 @@ static struct sg_table *unmap_vm_area(struct iommu_domain *domain,
 	struct sg_table *sgt = NULL;
 	struct iovm_struct *area;
 
-	if (!IS_ALIGNED(da, PAGE_SIZE)) {
+	if (!PAGE_ALIGNED(da)) {
 		dev_err(obj->dev, "%s: alignment err(%08x)\n", __func__, da);
 		return NULL;
 	}
-- 
1.8.4.5

