Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3JGByF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:54:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13270 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3JGByB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:54:01 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-79-525214336971
Date: Mon, 07 Oct 2013 10:53:54 +0900
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
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 05/20] iommu/exynos: allocate lv2 page table from own slab
Message-id: <20131007105354.d1c94b4c2bacb7a3376bfb1a@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zQ11jkaAggwu/ZCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlbF222O2gveiFTv/TGdpYGwX6mLk5JAQMJFo
	+XyMFcIWk7hwbz1bFyMXh5DAMkaJK13b2WCKXt3oZAGxhQQWMUo0LZODsCcxSVz45QBiswio
	Slw+2Ac2iE1AS2L13OOMIINEBNqYJL42HmIBcZgFTjNLrNq9ghmkSljAT+Lmj0VgHbwCjhKn
	nzyFOsNC4kJTBztEXFDix+R7YJuZgaZu3tbECmHLS2xe85YZZKiEwEQOiSet59ggzhCQ+DYZ
	ZBsHUEJWYtMBZoiZkhIHV9xgmcAoMgvJ2FlIxs5CMnYBI/MqRtHUguSC4qT0IkO94sTc4tK8
	dL3k/NxNjJA47t3BePuA9SHGZKCVE5mlRJPzgWkgryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MJaGuxxm4d835HC//yNfZeceZjTaML9e4/pHx
	a7V2tFuzw731iI7FfM/HGVf0+JTtwoMN1vvXJ7uky3lufeEYzbIz6WfzNp/ysKCL//1OzwoL
	viVyfqKW+DvtSb4vXs3Wfrq3wEfrUYlttG7dxRXxzt6F5+Pv608O0ptR793qdvev+qP7a7cr
	sRRnJBpqMRcVJwIAdq+/uvkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV1jkaAgg59bJCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj7bbH
	bAXvRSt2/pnO0sDYLtTFyMkhIWAi8epGJwuELSZx4d56NhBbSGARo0TTMjkIexKTxIVfDiA2
	i4CqxOWDfawgNpuAlsTquccZuxi5OEQE2pgkvjYeYgFxmAVOM0us2r2CGaRKWMBP4uaPRWAd
	vAKOEqefPGWF2GYhcaGpgx0iLijxY/I9sCuYgaZu3tbECmHLS2xe85Z5AiPfLCRls5CUzUJS
	toCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcJJ4Jr2DcVWDxSFGAQ5GJR7eHfcDg4RY
	E8uKK3MPMUpwMCuJ8F6qAwrxpiRWVqUW5ccXleakFh9iTAb6eyKzlGhyPjCB5ZXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo6v1CuOFHaucsuPv8++aHyO8
	YeXcm9lHau99derbp3lz2ok5jTIZzyJvHC9f6hN/I6RKflbkpc2Vewremq19xqN+PGpi7Yz6
	d3/579se3uLhWTwr+UDikinvZrzyLA7NfSJR80jwu0sF/+GqGTvPaxwpMzjaOOf1zquck9j2
	fan5veBF4l+Gc4xKLMUZiYZazEXFiQA9JwpuVgMAAA==
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
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index cbe1e5a..191cb3f 100644
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
@@ -738,7 +740,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -837,7 +840,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
@@ -867,8 +870,7 @@ static int lv1set_section(unsigned long *sent, unsigned long iova,
 			return -EADDRINUSE;
 		}
 
-		kfree(page_entry(sent, 0));
-
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 		*pgcnt = 0;
 	}
 
@@ -1073,11 +1075,31 @@ static int __init exynos_iommu_init(void)
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
1.7.2.5

