Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab3HHJhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:37:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50265 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210Ab3HHJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:37:45 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-66-520366e7686d
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 03/16] iommu/exynos: fix page table maintenance
Date: Thu, 08 Aug 2013 18:37:43 +0900
Message-id: <002701ce941a$eecebdb0$cc6c3910$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF1wiqpgTyfXjSuapcrtO0oW7xA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zQ90XacxBBm0iFnfunmO1mH8ESLw6
	8oPJYsF+a4vO2RvYLXoXXGWz+HjqOLvFpsfXWC0u75rDZjHj/D4miwsrNrJbTFl0mNXi5J9e
	RouW671MDnweTw7OY/KY3XCRxePOtT1sHuc3rWH22Lyk3mPyjeWMHn1bVjF6fN4k53Hl6Bmm
	AM4oLpuU1JzMstQifbsEroxJJ5azFLxQr1h94AtLA+Nb+S5GTg4JAROJH0f2MULYYhIX7q1n
	62Lk4hASWMYo8Wj+U2a4ouanrBCJRYwSx7buYYJw/jJKNE77xApSxSagJbF67nFGkISIwG9G
	iVvP5oC1MAv8Z5LYeruJvYuRg0NYwEli/xx/kAYWAVWJ12efsoCEeQUsJRasiQUJ8woISvyY
	fI8FxGYGmrl+53EmCFteYvOat1AXKUjsOPsa7GwRAT2Jztt7GCFqRCT2vXgHdoOEwFIOiSuz
	PjBC7BKQ+Db5ENguCQFZiU0HoOZIShxccYNlAqPYLCSrZyFZPQvJ6llIVixgZFnFKJpakFxQ
	nJReZKhXnJhbXJqXrpecn7uJERL5vTsYbx+wPsSYDLR+IrOUaHI+MHHklcQbGpsZWZiamBob
	mVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxX/iRRffsN+izHGhZc1a1
	TuvNVtN5JTFKie/6VU40/Cz7M8Ns3pwvfHx7V7EWZBxu2S+w//iFTUpLV/C6dSpZfYv0V1V0
	KM/aIaW20XD5uvLJczQURQokDX6lPzmQ+uz3WfPajWqt8dYqjDGtW/6+ujp9uuXaR1c2nsmp
	1Q7aLBw071jiJV13JZbijERDLeai4kQAKopu/xIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAd3nacxBBnsOmFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZkw6sZyl4IV6xeoDX1ga
	GN/KdzFyckgImEj8aH7KCmGLSVy4t56ti5GLQ0hgEaPEsa17mCCcv4wSjdM+gVWxCWhJrJ57
	nBEkISLwm1Hi1rM5rCAOs8B/Jomtt5vYuxg5OIQFnCT2z/EHaWARUJV4ffYpC0iYV8BSYsGa
	WJAwr4CgxI/J91hAbGagmet3HmeCsOUlNq95ywxxkYLEjrOvGUFsEQE9ic7bexghakQk9r14
	xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5ZnUjsY
	VzZYHGIU4GBU4uHtCGAKEmJNLCuuzD3EKMHBrCTCe7EYKMSbklhZlVqUH19UmpNafIgxGejR
	icxSosn5wKSXVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M
	IfVqp2PO1kf8vcdmtv6K/g9GxdcXYtgYosv3z3Ga5y94Nvb53Ij5tuek78048++MTJxtbZ/7
	xqp+w9wgIWWXaH7L1c+Un2831bVmEGIx21rrHnMo7a7nmV1p55qYBa7sfzw9Za458/uJE/yU
	ptrNnyfK265x5cn6jP/9vM3BgstT/WJ3eVUrsRRnJBpqMRcVJwIAvXDga3ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents allocating lv2 page table for the lv1 page table entry
that already has 1MB page mapping. In addition, changed to BUG_ON
instead of returning -EADDRINUSE.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   68 ++++++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index d545a25..d90e6fa 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -52,11 +52,11 @@
 #define lv2ent_large(pent) ((*(pent) & 3) == 1)
 
 #define section_phys(sent) (*(sent) & SECT_MASK)
-#define section_offs(iova) ((iova) & 0xFFFFF)
+#define section_offs(iova) ((iova) & ~SECT_MASK)
 #define lpage_phys(pent) (*(pent) & LPAGE_MASK)
-#define lpage_offs(iova) ((iova) & 0xFFFF)
+#define lpage_offs(iova) ((iova) & ~LPAGE_MASK)
 #define spage_phys(pent) (*(pent) & SPAGE_MASK)
-#define spage_offs(iova) ((iova) & 0xFFF)
+#define spage_offs(iova) ((iova) & ~SPAGE_MASK)
 
 #define lv1ent_offset(iova) ((iova) >> SECT_ORDER)
 #define lv2ent_offset(iova) (((iova) & 0xFF000) >> SPAGE_ORDER)
@@ -856,13 +856,15 @@ finish:
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 					short *pgcounter)
 {
+	BUG_ON(lv1ent_section(sent));
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
@@ -875,15 +877,11 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 
 static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 {
-	if (lv1ent_section(sent))
-		return -EADDRINUSE;
+	BUG_ON(lv1ent_section(sent));
 
 	if (lv1ent_page(sent)) {
-		if (*pgcnt != NUM_LV2ENTRIES)
-			return -EADDRINUSE;
-
+		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
 		kfree(page_entry(sent, 0));
-
 		*pgcnt = 0;
 	}
 
@@ -894,24 +892,24 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 	return 0;
 }
 
+static void clear_page_table(unsigned long *ent, int n)
+{
+	if (n > 0)
+		memset(ent, 0, sizeof(*ent) * n);
+}
+
 static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 								short *pgcnt)
 {
 	if (size == SPAGE_SIZE) {
-		if (!lv2ent_fault(pent))
-			return -EADDRINUSE;
-
+		BUG_ON(!lv2ent_fault(pent));
 		*pent = mk_lv2ent_spage(paddr);
 		pgtable_flush(pent, pent + 1);
 		*pgcnt -= 1;
 	} else { /* size == LPAGE_SIZE */
 		int i;
 		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
-			if (!lv2ent_fault(pent)) {
-				memset(pent, 0, sizeof(*pent) * i);
-				return -EADDRINUSE;
-			}
-
+			BUG_ON(!lv2ent_fault(pent));
 			*pent = mk_lv2ent_lpage(paddr);
 		}
 		pgtable_flush(pent - SPAGES_PER_LPAGE, pent);
@@ -944,17 +942,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
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
-		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
-							__func__, iova, size);
-	}
+	if (ret)
+		pr_err("%s: Failed(%d) to map 0x%#x bytes @ %#lx\n",
+			__func__, ret, size, iova);
 
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
@@ -968,6 +965,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
+	size_t err_pgsize;
 
 	BUG_ON(priv->pgtable == NULL);
 
@@ -976,7 +974,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		BUG_ON(size < SECT_SIZE);
+		if (WARN_ON(size < SECT_SIZE)) {
+			err_pgsize = SECT_SIZE;
+			goto err;
+		}
 
 		*ent = 0;
 		pgtable_flush(ent, ent + 1);
@@ -1008,9 +1009,12 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	}
 
 	/* lv1ent_large(ent) == true here */
-	BUG_ON(size < LPAGE_SIZE);
+	if (WARN_ON(size < LPAGE_SIZE)) {
+		err_pgsize = LPAGE_SIZE;
+		goto err;
+	}
 
-	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+	clear_page_table(ent, SPAGES_PER_LPAGE);
 	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
@@ -1023,8 +1027,16 @@ done:
 		sysmmu_tlb_invalidate_entry(data->dev, iova);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-
 	return size;
+err:
+	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+
+	pr_err("%s: Failed due to size(%#x) @ %#lx is"\
+		" smaller than page size %#x\n",
+		__func__, size, iova, err_pgsize);
+
+	return 0;
+
 }
 
 static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
-- 
1.7.2.5


