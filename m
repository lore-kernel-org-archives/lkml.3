Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaELGQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:16:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25627 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaELGQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:28 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-07-5370673b4036
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 03/19] iommu/exynos: allocate lv2 page table from own slab
Date: Mon, 12 May 2014 11:44:48 +0530
Message-id: <1399875304-19948-4-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkStc6vSDY4PlVDos7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6Myy3zWAsei1VcmbqGtYHxvVAXIyeHhICJxPNHM9ghbDGJC/fWs3UxcnEI
	CSxllHjwdCETTNGKqROYIRKLGCXOLfzKAuFMYJK4++0QK0gVm4ChxPZ7V1hBEiICqxkl+i6e
	YQdxmAVmM0scebSYEaRKWMBP4sjiuywgNouAqsSyi5vYQGxeAXeJo+/PAO3gANqnIDFnkg1I
	mFPAQ+Lz6ilgJUJAJcdeXQVbICGwhUPi7NMrrBBzBCS+TT7EAtErK7HpADPE2ZISB1fcYJnA
	KLyAkWEVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmC8nv73rG8H480D1ocYk4HGTWSWEk3O
	B8Z7Xkm8obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg
	DJbIu5S+4uGjhp5qjXl7zDWm/t2Tm3n9hbf2pgeb+fb92riq9jHXduXJvI7/1OZPm6Th1H6M
	4ffVLiej+Agbm+Y7tfFvg49pxui6tP9763PtxsWz/2cK1qiae/bqt08Junz0vJYi17v83RsT
	Vy68n/TFv2zdl49BU6NnfirLKHid4v17F0/kFSWW4oxEQy3mouJEAL7S2LvtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAV2r9IJgg6UnLC3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZlxumcda8Fis4srUNawNjO+Fuhg5
	OSQETCRWTJ3ADGGLSVy4t56ti5GLQ0hgEaPEuYVfWSCcCUwSd78dYgWpYhMwlNh+7worSEJE
	YDWjRN/FM+wgDrPAbGaJI48WM4JUCQv4SRxZfJcFxGYRUJVYdnETG4jNK+AucfT9GaB9HED7
	FCTmTLIBCXMKeEh8Xj0FrEQIqOTYq6usExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P
	3cQITgbPpHcwrmqwOMQowMGoxMP7gaEgWIg1say4MvcQowQHs5II70d/oBBvSmJlVWpRfnxR
	aU5q8SHGZKCjJjJLiSbnAxNVXkm8obGJuamxqaWJhYmZJWnCSuK8B1utA4UE0hNLUrNTUwtS
	i2C2MHFwSjUw8kyf/+PDkVn7TT5t3qBl1h+9YcXEFwLni2sy3twM/Nd5NWN30t6OT/mLAtQn
	rGPs2FsuZDq998zntO9sS8RWNFy7YfnVyzosXSxqctsywf8rJt+RmfLV4eDtj8ITdStqOm3T
	O3pF9sZmiYbs+pHnw+t0unz9zkOZNevSBP8xrD906vQskZyYWCWW4oxEQy3mouJEAOqY7S5K	AwAA
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
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index aec7fd7..4ff4b0b 100644
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
@@ -637,7 +639,8 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(phys_to_virt(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+				phys_to_virt(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -736,7 +739,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
@@ -766,8 +769,7 @@ static int lv1set_section(unsigned long *sent, unsigned long iova,
 			return -EADDRINUSE;
 		}
 
-		kfree(page_entry(sent, 0));
-
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 		*pgcnt = 0;
 	}
 
@@ -970,11 +972,31 @@ static int __init exynos_iommu_init(void)
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

