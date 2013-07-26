Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3GZL1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:27:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26545 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3GZL1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:27:13 -0400
X-AuditID: cbfee68f-b7f436d000000f81-32-51f25d1078e3
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
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v8 03/12] iommu/exynos: fix page table maintenance
Date: Fri, 26 Jul 2013 20:27:11 +0900
Message-id: <003901ce89f3$126c0390$37440ab0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8ZZIGIZKuGZTRUKYUxqgag68lw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zoa5A7KdAg65FQhZ37p5jtXh15AeT
	xYL91hadszewW2w+uI7FonfBVTaLxnsT2Cw+njrObrHp8TVWi8u75rBZzDi/j8niwoqN7BZT
	Fh1mtTj5p5fRouV6L5MDv8eTg/OYPGY3XGTxuHNtD5vH+U1rmD02L6n3mHxjOaNH35ZVjB6f
	N8l5XDl6himAM4rLJiU1J7MstUjfLoEr4+TrvWwFt5QqJrdsZ25g/CzdxcjJISFgIjHt1hU2
	CFtM4sK99UA2F4eQwDJGiWtbnzLCFH34vZ8VIrGIUWLx70ZmCOcvo8TyWzuYQarYBLQkVs89
	DtYhInCXUeLleR6QImaB28wS036+AksICzhJNNy+DmazCKhKbJm8kh3E5hWwlJj/soMJwhaU
	+DH5HguIzQw0dP3O40wQtrzE5jVvmSFOUpDYcfY11DI9icaT66FqRCT2vXjHCLJYQmAph8T6
	MwuYIJYJSHybfAhoKAdQQlZi0wGoOZISB1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGKphYk
	FxQnpRcZ6xUn5haX5qXrJefnbmKEpIH+HYx3D1gfYkwGWj+RWUo0OR+YRvJK4g2NzYwsTE1M
	jY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwKjd+v664pbIbXKPfaeu
	qNw+dUJ259aJv1YJbhTuYGn9n8lY/tchwV3kOrvq4wcl3gHGs0t3nwp3XtJ5oTlZ103AVUD4
	wf+P805V7jh1fbvs4aK4JWtLJqae6eN8GePstUb49AnrrJSrF07+cBXu+uD5T3kbb6rp9Me3
	WPctqLx00jZ8xwbl5ndKLMUZiYZazEXFiQCS7vyNGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAV2B2E+BBr8X8ljcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBknX+9lK7il
	VDG5ZTtzA+Nn6S5GTg4JAROJD7/3s0LYYhIX7q1n62Lk4hASWMQosfh3IzOE85dRYvmtHcwg
	VWwCWhKr5x5nBLFFBO4ySrw8zwNSxCxwm1li2s9XYAlhASeJhtvXwWwWAVWJLZNXsoPYvAKW
	EvNfdjBB2IISPybfYwGxmYGGrt95nAnClpfYvOYtM8RJChI7zr6GWqYn0XhyPVSNiMS+F+8Y
	JzAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAk80xqB+PK
	BotDjAIcjEo8vApOHwOFWBPLiitzDzFKcDArifBe9/4UKMSbklhZlVqUH19UmpNafIgxGejT
	icxSosn5wASYVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M
	e4K3WpeyNW315/F5lfbg49YJgX1zJBqn+63T0hVYN+Njhdo6nteFKys5DNWuaPabbtu3MT7o
	+jpVjqs7924IfMVzwkxWU6Omfyp/89K1aZy1WXzbpPplmi49kb/3Yg6P2R9lM+c1Rs7+uce2
	7pk1Y8UR9pz/Mh8YX9wXWnstyvAEd1NF9+QIJZbijERDLeai4kQAP5dl53YDAAA=
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
 drivers/iommu/exynos-iommu.c |   52 +++++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index e3be3e5..6c4ecce 100644
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
@@ -894,6 +896,12 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
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
@@ -908,7 +916,7 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 		int i;
 		for (i = 0; i < SPAGES_PER_LPAGE; i++, pent++) {
 			if (!lv2ent_fault(pent)) {
-				memset(pent, 0, sizeof(*pent) * i);
+				clear_page_table(pent - i, i);
 				return -EADDRINUSE;
 			}
 
@@ -944,17 +952,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
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
 
@@ -968,6 +975,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
+	size_t err_pgsize;
 
 	BUG_ON(priv->pgtable == NULL);
 
@@ -976,7 +984,10 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	ent = section_entry(priv->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
-		BUG_ON(size < SECT_SIZE);
+		if (WARN_ON(size < SECT_SIZE)) {
+			err_pgsize = SECT_SIZE;
+			goto err;
+		}
 
 		*ent = 0;
 		pgtable_flush(ent, ent + 1);
@@ -1008,9 +1019,12 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
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
@@ -1023,8 +1037,16 @@ done:
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


