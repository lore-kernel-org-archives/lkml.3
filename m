Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaCNFEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:04:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56085 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaCNFES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:04:18 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-23-53228dd0c7fa
Date: Fri, 14 Mar 2014 14:04:16 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 06/27] iommu/exynos: allocate lv2 page table from own slab
Message-id: <20140314140416.215fb91cdfeacc322c607308@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zQ90LvUrBBrN+G1jcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXx+cl35oJ3ohVXdr9la2BsE+pi5OSQEDCR2N/0hBXC
	FpO4cG89WxcjF4eQwDJGiUvfVjDCFP0+3AJmCwksYpRYMNMUomgyk8Syi+uZQRIsAqoS729N
	AZvEJqAlsXrucUaQIhGBNiaJr42HWEAcZoG5zBIfv81hA6kSFvCT2HXuGROIzSvgKHGyYSET
	xDoLiQtNHewQcUGJH5PvsYDYzEBTN29rYoWw5SU2r3nLDDJUQqCXQ+LCEYhbWQQEJL5NBtnG
	AZSQldh0gBlipqTEwRU3WCYwisxCMnYWkrGzkIxdwMi8ilE0tSC5oDgpvchUrzgxt7g0L10v
	OT93EyMkfifuYLx/wPoQYzLQyonMUqLJ+cD4zyuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1RUpCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpq8IzOKo6wiN0xy8ZGdu/ra8sYVist+z627Yi77
	8HzO097cuJURr3dv3D91b4tjW9nB05uuLGTw+Gx1bWbNjp0f9/CUmq/JlD1a8m65n2D4k5Oz
	5mzmNtkgw7drxczlqyRjonY3XHQ4HnClwqFeRXfDwQ6TuFm+RYYC6UeUHwd4lhQdX3zZxFGJ
	pTgj0VCLuag4EQAjOkEI9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd0LvUrBBovPalncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/OT78wF70Qr
	rux+y9bA2CbUxcjJISFgIvH7cAsjhC0mceHeejYQW0hgEaPEgpmmXYxcQPZkJollF9czgyRY
	BFQl3t+awgpiswloSayee5wRpEhEoI1J4mvjIRYQh1lgLrPEx29zwEYJC/hJ7Dr3jAnE5hVw
	lDjZsJAJYp2FxIWmDnaIuKDEj8n3WEBsZqCpm7c1sULY8hKb17xlnsDINwtJ2SwkZbOQlC1g
	ZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwcnknvYFzVYHGIUYCDUYmHd8ZRxWAh1sSy
	4srcQ4wSHMxKIrxVEUrBQrwpiZVVqUX58UWlOanFhxiTgf6eyCwlmpwPTFx5JfGGxiZmRpZG
	ZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCY99REsTM/yNah9uWDbrfnvaVH
	rRv+sMVVu21OWdqqGi/Y4L1n73TehkSbH55qhxnP5K5P6C84HL7iyOpvLYfqkhRClYoapu1k
	3DJtqc6LnNZFaV/Tvx4yvV39yk7uWcOTSl+5bervf0z1W6/7UvaS3PeZwncfNAX9ma22L4hR
	501Pf63Pgn4lluKMREMt5qLiRADPauNwUgMAAA==
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
 drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 647fc46..bee1bb1 100644
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
@@ -726,7 +728,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -825,7 +828,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
@@ -855,8 +858,7 @@ static int lv1set_section(unsigned long *sent, unsigned long iova,
 			return -EADDRINUSE;
 		}
 
-		kfree(page_entry(sent, 0));
-
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 		*pgcnt = 0;
 	}
 
@@ -1061,11 +1063,31 @@ static int __init exynos_iommu_init(void)
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

