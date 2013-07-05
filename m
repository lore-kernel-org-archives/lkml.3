Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab3GEM3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36086 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab3GEM3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:20 -0400
X-AuditID: cbfee68e-b7f276d000002279-65-51d6bc1e7d3c
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
Subject: [PATCH v7 3/9] iommu/exynos: fix page table maintenance
Date: Fri, 05 Jul 2013 21:29:18 +0900
Message-id: <002b01ce797b$44d4ad10$ce7e0730$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55d6JT814ICoM1Sxm7p0k6WMmA/A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zQ125PdcCDc7+M7F4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZaye
	+oWp4KRERd/3NywNjFeEuxg5OSQETCQOTb3JDGGLSVy4t54NxBYSWMYosXymIEzN+TWrmboY
	uYDiixgl+lYuh3L+Mkr8nzONFaSKTUBLYvXc44wgtojAXUaJl+d5QIqYBW4wSWz41MYCkhAW
	cJBYP+Ep2AoWAVWJ9v37wVbzClhKbO/YBGULSvyYfA+snhlo6Pqdx5kgbHmJzWveQp2qILHj
	7GuoZXoS+6ZNYoeoEZHY9+IdI8hiCYFGDokFk+5CLROQ+Db5ENBQDqCErMSmA1BzJCUOrrjB
	MoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJ6b4djDcP
	WB9iTAZaP5FZSjQ5H5gS8kriDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAWC2u9MXwi7RwN39a8JsQvb6PaUcfbrrNl8zB5pa9eN7sZxrLlVT63SrP
	hMm5ClbPCP0qVLdqRfKF+LpoVeUkv5kb37IVL7XMm9Wy9YAK+91s051znFa4355ZcllOrT6n
	4ObDROtY8+Ufjz43ZVZxPsZ/NXJuxrPZSxSc/eWW/KrzWfJy2cxcJZbijERDLeai4kQA8bCc
	bP8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jAV25PdcCDV4fMrB4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8xYPfULU8FJiYq+729YGhivCHcxcnJICJhInF+zmgnCFpO4
	cG89WxcjF4eQwCJGib6Vy5kgnL+MEv/nTGMFqWIT0JJYPfc4I4gtInCXUeLleR6QImaBG0wS
	Gz61sYAkhAUcJNZPeMoGYrMIqEq079/PDGLzClhKbO/YBGULSvyYfA+snhlo6Pqdx5kgbHmJ
	zWveMkOcpCCx4+xrqGV6EvumTWKHqBGR2PfiHeMERoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kRnDKeSe9gXNVgcYhRgINRiYf3Qf3VQCHWxLLiytxDjBIc
	zEoivPYJ1wKFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YzvJK4g2NTcyMLI3MLIxMzM1J
	E1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgZHV1asqPeCYkGlP4DnfMK9pZls/bvHbMFF/
	8bzpaxfd2tey1SUvTkL+dFJau8f67HssPzp+v9G/u/i4y/GIdi7X1RtDTc6p//I5dtZFfQuL
	a0s0s7nCFfFbnKwGty+cC+ZQmWBXpOnO9TZDvFXsw/MFsSa6nRWtpdYfEn06z8/LPbkhU3Df
	eyWW4oxEQy3mouJEABZM4kVdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents allocating lv2 page table for the lv1 page table entry
that already has 1MB page mapping. In addition some BUG_ON() is
changed to WARN_ON().

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index e3be3e5..2bfe9fa 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -862,12 +862,14 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 
 		*sent = mk_lv1ent_page(__pa(pent));
 		*pgcounter = NUM_LV2ENTRIES;
 		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
 		pgtable_flush(sent, sent + 1);
+	} else if (lv1ent_section(sent)) {
+		return ERR_PTR(-EADDRINUSE);
 	}
 
 	return page_entry(sent, iova);
@@ -944,16 +946,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
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
 
 	if (ret) {
-		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
-							__func__, iova, size);
+		pr_err("%s: Failed(%d) to map iova 0x%#x bytes @ %#lx\n",
+						__func__, ret, size, iova);
 	}
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
@@ -968,6 +970,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
+	size_t err_page;
 
 	BUG_ON(priv->pgtable == NULL);
 
@@ -976,7 +979,8 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		BUG_ON(size < SECT_SIZE);
+		if (WARN_ON(size < SECT_SIZE))
+			goto err;
 
 		*ent = 0;
 		pgtable_flush(ent, ent + 1);
@@ -1008,7 +1012,8 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	BUG_ON(size < LPAGE_SIZE);
+	if (WARN_ON(size < LPAGE_SIZE))
+		goto err;
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
 	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
@@ -1023,8 +1028,21 @@ done:
 		sysmmu_tlb_invalidate_entry(data->dev, iova);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-
 	return size;
+err:
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	err_page = (
+		((unsigned long)ent - (unsigned long)priv->pgtable)
+			< (NUM_LV1ENTRIES * sizeof(long))
+			   ) ?  SECT_SIZE : LPAGE_SIZE;
+
+	pr_err("%s: Failed due to size(%#lx) @ %#x is"\
+		" smaller than page size %#x\n",
+		__func__, iova, size, err_page);
+
+	       return 0;
+
 }
 
 static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
-- 
1.7.2.5


