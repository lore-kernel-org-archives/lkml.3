Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab3GZL1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:27:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3GZL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:27:30 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a4-51f25d217f93
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
Subject: [PATCH v8 04/12] iommu/exynos: allocate lv2 page table from own slab
Date: Fri, 26 Jul 2013 20:27:29 +0900
Message-id: <003a01ce89f3$1cb475d0$561d6170$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8Z2ypPmTMYEVRSqFifaSBb+1lg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zga5i7KdAg/fHZCzu3D3HavHqyA8m
	iwX7rS06Z29gt9h8cB2LRe+Cq2wWjfcmsFl8PHWc3WLT42usFpd3zWGzmHF+H5PFhRUb2S2m
	LDrManHyTy+jRcv1XiYHfo8nB+cxecxuuMjicefaHjaP85vWMHtsXlLvMfnGckaPvi2rGD0+
	b5LzuHL0DFMAZxSXTUpqTmZZapG+XQJXxqLFm5gKOkUqfi9rZmpgPCjQxcjJISFgInHoZzsj
	hC0mceHeerYuRi4OIYFljBK9h26ywRR1P/3IDpGYzijxu+EwE4Tzl1HiaN9ZdpAqNgEtidVz
	j4ONEhG4yyjx8jwPSBGzwG1miWk/X4ElhAV8JTbunskKYrMIqEqc6P0FtoJXwFJi3un/TBC2
	oMSPyfdYQGxmoKHrdx5ngrDlJTavecsMcZKCxI6zr6GW6UlcvrCaDaJGRGLfi3eMIIslBFZy
	SHxcc5gFYpmAxLfJh4BsDqCErMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRN
	LUguKE5KLzLVK07MLS7NS9dLzs/dxAhJAxN3MN4/YH2IMRlo/URmKdHkfGAaySuJNzQ2M7Iw
	NTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD4/64f2fOJs1r3blu
	U7xM0mmZH6V237LevX+tYMpp7mt4/a0Ow/cz21OPsupq81RP4WRM8Du0Wu3/x+3V7/UfNi/0
	XRRSYLX2YPzcLMkEBvc5D52YmbuCNmr+tTgSsW/9tq4PHMZ9R9f3WFi9YIjgjS3bZf2eb+eN
	NKHG0oWsTupcO73XKqxOUmIpzkg01GIuKk4EALYYtI8ZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQV3F2E+BBst+i1ncuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmLFm9iKugU
	qfi9rJmpgfGgQBcjJ4eEgIlE99OP7BC2mMSFe+vZuhi5OIQEpjNK/G44zATh/GWUONp3FqyK
	TUBLYvXc44wgtojAXUaJl+d5QIqYBW4zS0z7+QosISzgK7Fx90xWEJtFQFXiRO8vNhCbV8BS
	Yt7p/0wQtqDEj8n3WEBsZqCh63ceZ4Kw5SU2r3nLDHGSgsSOs6+hlulJXL6wmg2iRkRi34t3
	jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwknkmvYNx
	VYPFIUYBDkYlHl4Fp4+BQqyJZcWVuYcYJTiYlUR4r3t/ChTiTUmsrEotyo8vKs1JLT7EmAz0
	6URmKdHkfGACzCuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkG
	RlGBJZEL+38d/OrFcCknpcnbduVa/4XfTzkbvDW/fG9d8rfFX1ftu3D9w/16RdbyoJ1J28pf
	vfbqd1qadvJI399XoVNkv/wQ3n+x9NilALFj246yST3foxHjedKhwPGC++HuoqVvn908s/K6
	/atr/bc4XlZ2u1Z6bxGICusr2NT8u1x4ziLbViYlluKMREMt5qLiRADxdnHvdgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kmalloc() does not guarantee that the allignment of 1KiB when it
allocates 1KiB, it is required to allocate lv2 page table from own
slab that guarantees alignment of 1KiB

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 6c4ecce..093eea5 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -100,6 +100,8 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+static struct kmem_cache *lv2table_kmem_cache;
+
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 {
 	return pgtable + lv1ent_offset(iova);
@@ -765,7 +767,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -859,7 +862,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
@@ -884,7 +887,7 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 		if (*pgcnt != NUM_LV2ENTRIES)
 			return -EADDRINUSE;
 
-		kfree(page_entry(sent, 0));
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 
 		*pgcnt = 0;
 	}
@@ -1092,10 +1095,23 @@ static int __init exynos_iommu_init(void)
 {
 	int ret;
 
+	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
+				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
+	if (!lv2table_kmem_cache) {
+		pr_err("%s: Failed to create kmem cache\n", __func__);
+		return -ENOMEM;
+	}
+
 	ret = platform_driver_register(&exynos_sysmmu_driver);
 
 	if (ret == 0)
-		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+		ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+
+	if (ret) {
+		pr_err("%s: Failed to register exynos-iommu driver.\n",
+								__func__);
+		kmem_cache_destroy(lv2table_kmem_cache);
+	}
 
 	return ret;
 }
-- 
1.7.2.5


