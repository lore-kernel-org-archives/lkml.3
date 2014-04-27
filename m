Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaD0HkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41690 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaD0Hi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:38:57 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-fe-535cb40f7fe4
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 03/31] iommu/exynos: change error handling when page table
 update is failed
Date: Sun, 27 Apr 2014 13:07:35 +0530
Message-id: <1398584283-22846-4-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkTpd/S0ywQdNlK4s7d8+xWsw/AiRe
	HfnBZLFgv7VF5+wN7Bbfd31ht+hdcJXNYtPja6wWl3fNYbOYcX4fk8WFFRvZLf71HmS0mLLo
	MKvF4TftrBYn//QyWrRc72WyWD/jNYvFql1/GC1m3lrD4iDs8eTgPCaP2Q0XWTz+He5n8tg5
	6y67x51re9g8Ni+p95h8YzmjR9+WVYwenzfJeVw5eoYpgCuKyyYlNSezLLVI3y6BK+PLkgnM
	BZPUKjZPM29gnCjXxcjJISFgInFn7002CFtM4sK99UA2F4eQwFJGiZcPb7PDFF1c280OkVjE
	KHF111YmCGcCk8TST82MIFVsAoYS2+9dYQVJiAisZpTou3gGrIVZ4C6TxJxV78CqhAUSJeav
	msgEYrMIqEosaWxgAbF5Bdwllu7uAIpzAO1TkJgzyQYkzCngIfHkzh6wEiGgkrenvoAtkBCY
	ySGx6dtqNog5AhLfJh9igeiVldh0gBnibEmJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3
	uDQvXS85P3cTIzAeT/971reD8eYB60OMyUDjJjJLiSbnA+M5ryTe0NjMyMLUxNTYyNzSjDRh
	JXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwRhyMOp5y6IX51WUhTRVq5rac/+tr
	P99w9a/zZLyr6Pn9iSLzbo/nX03ivvGlW/f9L7j/3q537oxiVWXdzF+3LI1aXFQZfCM2fVF6
	JFQe4x9mbzzz+UaPtqlcilYrtDz7lFxLSh+Erki59m29q6DG10cbl359xC7CyVpTcy/zCt/r
	S0seJ8cqsRRnJBpqMRcVJwIAkAxM/d0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3+LTHBBhdf6FvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzviyZwFwwSa1i8zTzBsaJcl2MnBwSAiYSF9d2s0PYYhIX7q1n
	62Lk4hASWMQocXXXViYIZwKTxNJPzYwgVWwChhLb711hBUmICKxmlOi7eIYdxGEWuMskMWfV
	O7AqYYFEifmrJjKB2CwCqhJLGhtYQGxeAXeJpbs7gOIcQPsUJOZMsgEJcwp4SDy5swesRAio
	5O2pL6wTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO9mdSOxhXNlgcYhTgYFTi
	4V0gGRMsxJpYVlyZe4hRgoNZSYSXczpQiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBiSiv
	JN7Q2MTc1NjU0sTCxMySNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgD63MecV3kdVy0
	NGu/4wPBjzNuHRY1XTqBd5n/1Lvxj9ZcPSSV+kvwjvY1RzPvOyp9e+/Mc4isPv66oH4jz/k/
	Xxg3rz7qePyYPjf7toNGrJE/Nyxo2DbryoZTh9Levd84b+mxli9zJSKEHk3uDpt1aZ1cwNwK
	nlXXzxc0V7MIz5cQubB1SXPzRCWW4oxEQy3mouJEANJR7Mc6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch changes not to panic on any error when updating page table.
Instead prints error messages with callstack.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   58 ++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 34e4273..84fc3b4 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -811,13 +811,18 @@ finish:
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 					short *pgcounter)
 {
+	if (lv1ent_section(sent)) {
+		WARN(1, "Trying mapping on %#08lx mapped with 1MiB page", iova);
+		return ERR_PTR(-EADDRINUSE);
+	}
+
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
 		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 
 		*sent = mk_lv1ent_page(__pa(pent));
 		*pgcounter = NUM_LV2ENTRIES;
@@ -828,14 +833,21 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	return page_entry(sent, iova);
 }
 
-static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
+static int lv1set_section(unsigned long *sent, unsigned long iova,
+			  phys_addr_t paddr, short *pgcnt)
 {
-	if (lv1ent_section(sent))
+	if (lv1ent_section(sent)) {
+		WARN(1, "Trying mapping on 1MiB@%#08lx that is mapped",
+			iova);
 		return -EADDRINUSE;
+	}
 
 	if (lv1ent_page(sent)) {
-		if (*pgcnt != NUM_LV2ENTRIES)
+		if (*pgcnt != NUM_LV2ENTRIES) {
+			WARN(1, "Trying mapping on 1MiB@%#08lx that is mapped",
+				iova);
 			return -EADDRINUSE;
+		}
 
 		kfree(page_entry(sent, 0));
 
@@ -853,8 +865,10 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 								short *pgcnt)
 {
 	if (size == SPAGE_SIZE) {
-		if (!lv2ent_fault(pent))
+		if (!lv2ent_fault(pent)) {
+			WARN(1, "Trying mapping on 4KiB where mapping exists");
 			return -EADDRINUSE;
+		}
 
 		*pent = mk_lv2ent_spage(paddr);
 		pgtable_flush(pent, pent + 1);
@@ -863,7 +877,10 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 		int i;
 		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
 			if (!lv2ent_fault(pent)) {
-				memset(pent, 0, sizeof(*pent) * i);
+				WARN(1,
+				"Trying mapping on 64KiB where mapping exists");
+				if (i > 0)
+					memset(pent - i, 0, sizeof(*pent) * i);
 				return -EADDRINUSE;
 			}
 
@@ -891,7 +908,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	entry = section_entry(priv->pgtable, iova);
 
 	if (size == SECT_SIZE) {
-		ret = lv1set_section(entry, paddr,
+		ret = lv1set_section(entry, iova, paddr,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	} else {
 		unsigned long *pent;
@@ -899,17 +916,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 		pent = alloc_lv2entry(entry, iova,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 
-		if (!pent)
-			ret = -ENOMEM;
+		if (IS_ERR(pent))
+			ret = PTR_ERR(pent);
 		else
 			ret = lv2set_page(pent, paddr, size,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	}
 
-	if (ret) {
+	if (ret)
 		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
 							__func__, iova, size);
-	}
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
@@ -923,6 +939,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
+	size_t err_pgsize;
 
 	BUG_ON(priv->pgtable == NULL);
 
@@ -931,7 +948,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		BUG_ON(size < SECT_SIZE);
+		if (size < SECT_SIZE) {
+			err_pgsize = SECT_SIZE;
+			goto err;
+		}
 
 		*ent = 0;
 		pgtable_flush(ent, ent + 1);
@@ -963,7 +983,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	BUG_ON(size < LPAGE_SIZE);
+	if (size < LPAGE_SIZE) {
+		err_pgsize = LPAGE_SIZE;
+		goto err;
+	}
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
 	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
@@ -978,8 +1001,15 @@ done:
 		sysmmu_tlb_invalidate_entry(data->dev, iova);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-
 	return size;
+err:
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	WARN(1,
+	"%s: Failed due to size(%#x) @ %#08lx is smaller than page size %#x\n",
+	__func__, size, iova, err_pgsize);
+
+	return 0;
 }
 
 static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
-- 
1.7.9.5

