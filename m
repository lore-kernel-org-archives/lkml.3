Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaD0Hk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41708 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaD0HjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:05 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-15-535cb41866da
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
Subject: [PATCH v12 06/31] iommu/exynos: allocate lv2 page table from own slab
Date: Sun, 27 Apr 2014 13:07:38 +0530
Message-id: <1398584283-22846-7-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkTldiS0ywwac1EhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bkOT0s
	BbPEKk7OO8jawLhaqIuRk0NCwETi3I9jbBC2mMSFe+uBbC4OIYGljBLzX59lgymauew0C0Ri
	EaNE0/XNjBDOBCaJxTs6mUGq2AQMJbbfu8IKkhARWM0o0XfxDDuIwyxwl0lizqp3jCBVwgJ+
	EluOfGQBsVkEVCUuX3kE1s0r4C5x4vAsoAYOoH0KEnMm2YCEOQU8JJ7c2QNWLgRU8vbUF7AF
	EgIzOSTeHvjJDjFHQOLb5EMsEL2yEpsOMEOcLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGesV
	J+YWl+al6yXn525iBEbk6X/P+ncw3j1gfYgxGWjcRGYp0eR8YETnlcQbGpsZWZiamBobmVua
	kSasJM57/2FSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG7Cm6huXLZ169MrWK58S84Agz
	/sSsM91qfD6Hv+S/bss4cp3bas7fO6vf3F7i/KLp7dKnhZt1X6mvFDZfyau8dKfuuzdKj96v
	jV+6gvtTcLV64/2Ma6e317zZblHQrFyxzS7o3oKLk7d6ZNp7VL1umzz9sfB9txeC7uqKf57s
	3Pf56edSXp1IEyWW4oxEQy3mouJEAAVdenzeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV2JLTHBBt9u8lrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzJs/pYSmYJVZxct5B1gbG1UJdjJwcEgImEjOXnWaBsMUkLtxb
	z9bFyMUhJLCIUaLp+mZGCGcCk8TiHZ3MIFVsAoYS2+9dYQVJiAisZpTou3iGHcRhFrjLJDFn
	1TtGkCphAT+JLUc+gs1lEVCVuHzlEVg3r4C7xInDs4AaOID2KUjMmWQDEuYU8JB4cmcPWLkQ
	UMnbU19YJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHO/PpHYwrmywOMQowMGo
	xMO7QDImWIg1say4MvcQowQHs5IIL+d0oBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnA1NR
	Xkm8obGJuamxqaWJhYmZJWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwLuO7oi+oxJ4x
	qddm9hrXFam/HlQ3yU08Wn1WvP7CtTsJ+tdc1GLWfWCp7Qr6kXvL+/SehJDdnAJpkQWfb8oc
	5TrhxK8bxhmQZ76kTHjfl5boH2IlOraR/aufnzK882xeTNKu9Dnbfq6auV6v8dmEx9FT+qfo
	fTkpHVT8zMt2u5EFu/Ix1jcZSizFGYmGWsxFxYkA63lxNjsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Since kmalloc() does not guarantee that the allignment of 1KiB when it
allocates 1KiB, it is required to allocate lv2 page table from own
slab that guarantees alignment of 1KiB

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7556177..c7f831c 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -99,6 +99,8 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+static struct kmem_cache *lv2table_kmem_cache;
+
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 {
 	return pgtable + lv1ent_offset(iova);
@@ -725,7 +727,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -824,7 +827,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
@@ -854,8 +857,7 @@ static int lv1set_section(unsigned long *sent, unsigned long iova,
 			return -EADDRINUSE;
 		}
 
-		kfree(page_entry(sent, 0));
-
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 		*pgcnt = 0;
 	}
 
@@ -1060,11 +1062,31 @@ static int __init exynos_iommu_init(void)
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
+	if (ret) {
+		pr_err("%s: Failed to register driver\n", __func__);
+		goto err_reg_driver;
+	}
 
-	if (ret == 0)
-		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	if (ret) {
+		pr_err("%s: Failed to register exynos-iommu driver.\n",
+								__func__);
+		goto err_set_iommu;
+	}
 
+	return 0;
+err_set_iommu:
+	platform_driver_unregister(&exynos_sysmmu_driver);
+err_reg_driver:
+	kmem_cache_destroy(lv2table_kmem_cache);
 	return ret;
 }
 subsys_initcall(exynos_iommu_init);
-- 
1.7.9.5

