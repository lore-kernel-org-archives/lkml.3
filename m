Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab3GEM31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36093 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab3GEM3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:24 -0400
X-AuditID: cbfee68e-b7f276d000002279-87-51d6bc23fb6e
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
Subject: [PATCH v7 4/9] iommu/exynos: allocate lv2 page table from own slab
Date: Fri, 05 Jul 2013 21:29:22 +0900
Message-id: <002c01ce797b$47a1fde0$d6e5f9a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55d6nbz05YrQSpTiGFdAu6bwYANw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zQ13lPdcCDab957B4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZaxY
	eYatoFOkYt2aj6wNjAcFuhg5OSQETCQWHDzPCmGLSVy4t56ti5GLQ0hgGaPE3tZJLDBF967s
	YO9i5ABKLGKUuGABUfOXUeL+oj/MIDVsAloSq+ceZwSxRQTuMkq8PM8DUsQscINJYsOnNrBB
	wgLeEjsvTWMDsVkEVCXmzNoA1sArYCnxe8MPNghbUOLH5Htg9cxAQ9fvPM4EYctLbF7zlhni
	IAWJHWdfQy3Tk7j6YRJUjYjEvhfvGCFqWjkkrm7MhNglIPFt8iEWkAckBGQlNh2AGiMpcXDF
	DZYJjGKzkGyehWTzLCSbZyHZsICRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSDz37WC8
	ecD6EGMy0PqJzFKiyfnAdJBXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBkbGgNnvur9vyjZUnSMa+dLtaaj7gb4wK3m3rTekz+frrGLQ/e9++xdT
	o1Gd8i+3dVeNS29Wb2N3NS0rfrnCv8hRfYd7Y4DlxLQXJnzumeEKf58+0XWyfrXkxLw/8Ue6
	nuXsqmN52pjsbiu853eE5abIpv9BZ5wfWUj7yz6Lf9T4fLXzkgdHziixFGckGmoxFxUnAgAv
	lFL9/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAV3lPdcCDaafZLF4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8xYsfIMW0GnSMW6NR9ZGxgPCnQxcnJICJhI3Luygx3CFpO4
	cG89WxcjB4eQwCJGiQsWXYxcQOZfRon7i/4wg9SwCWhJrJ57nBHEFhG4yyjx8jwPSBGzwA0m
	iQ2f2lhAEsIC3hI7L01jA7FZBFQl5szaANbAK2Ap8XvDDzYIW1Dix+R7YPXMQEPX7zzOBGHL
	S2xe85YZ4iAFiR1nX0Mt05O4+mESVI2IxL4X7xgnMArMQjJqFpJRs5CMmoWkZQEjyypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4HTxTHoH46oGi0OMAhyMSjy8D+qvBgqxJpYVV+YeYpTg
	YFYS4bVPuBYoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnAVJZXEm9obGJmZGlkZmFkYm5O
	mrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwis4+7Hovdsy3bwupIwHrRmk1H9ezeMYkd
	kItb41DBelZ9acErDjkD48vrcqX8ZnyQOnD3+/mQ9PnnV1UE/G95lLvy+5UjoSJ5c+O70hUz
	f/R7eO1f7DBX7JaEeniWgc7s8OPPWbaZ1f5cfT975sb4JTw5CVXfdPQEqurbfJe8nv3z5exc
	z0lKLMUZiYZazEXFiQCsA+XJWwMAAA==
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
index 2bfe9fa..390f8b7 100644
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
@@ -1088,10 +1091,23 @@ static int __init exynos_iommu_init(void)
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


