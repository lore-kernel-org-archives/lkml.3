Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab3HHJiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:38:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28724 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097Ab3HHJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:38:06 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-1d-520366fdac47
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
Subject: [PATCH v9 04/16] iommu/exynos: allocate lv2 page table from own slab
Date: Thu, 08 Aug 2013 18:38:04 +0900
Message-id: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF2PSyzrnM+9kRc6rp0eiQ7kQXQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zge7fNOYgg92XmS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUVw2Kak5mWWpRfp2CVwZ755yFUwQqfj89itbA+MpgS5GTg4JAROJ3VN2sULYYhIX7q1n
	62Lk4hASWMYo8enLE5YuRg6wott7qiHiixgldpx/xwLh/GWUmPpmKhNIN5uAlsTquccZQRIi
	Ar8ZJW49m8MK4jAL/GeS2Hq7iR2kSljAV+Lt62NgHSwCqhLTlr0G280rYCmx5M42RghbUOLH
	5HssIDYz0NT1O48zQdjyEpvXvGWGuFVBYsfZ12D1IgJ6EvsaDjBC1IhI7HvxDuwKCYGlHBI3
	Xx5lhFgmIPFt8iGof2QlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFx
	UnqRoV5xYm5xaV66XnJ+7iZGSOz37mC8fcD6EGMy0PqJzFKiyfnA1JFXEm9obGZkYWpiamxk
	bmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbtZad0w/c2c3ebqzJlL1dn
	vPy+zuP7uQSz0rd2nNW3X/IHPPO9eT2j6vok9T2t/7pY0yujf6t/e52UfePe4nBD+5WTJoZd
	t/Q3vcr04E6PytGjBZmilXXP7pySN3E9tbXHzHsN63MWx0lXPj++sUNpxm82husbHxnkeq5/
	8/BN3f23akG6TsxKLMUZiYZazEXFiQAq7g7yEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAd0/acxBBpNnWFvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZrx7ylUwQaTi89uvbA2M
	pwS6GDk4JARMJG7vqe5i5AQyxSQu3FvP1sXIxSEksIhRYsf5dywQzl9GialvpjKBVLEJaEms
	nnucESQhIvCbUeLWszmsIA6zwH8mia23m9hBqoQFfCXevj4G1sEioCoxbdlrVhCbV8BSYsmd
	bYwQtqDEj8n3WEBsZqCp63ceZ4Kw5SU2r3nLDHGTgsSOs6/B6kUE9CT2NRxghKgRkdj34h3j
	BEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxYnknvYFzV
	YHGIUYCDUYmHd6Ebc5AQa2JZcWXuIUYJDmYlEd6LxUxBQrwpiZVVqUX58UWlOanFhxiTgT6d
	yCwlmpwPTHp5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDI
	MEXc5NGm2M+vnuo9mMpqwX77yp9JpTf6FsnLJWmtzFCouHiRjed7fiDX8r/vrfbIXRG6pX0i
	Nl6tvWS528lJC8LWPT5Z/sJGnHd61ASuP5a6dyYdfbaStSe2pyBn4zIhlfArkv72anZiXxIW
	TjXde0ngk3jhLPn7n+zfHNrFey3yaFLTVb8EJZbijERDLeai4kQAaDaT23ADAAA=
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
index d90e6fa..a318049 100644
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
@@ -861,7 +864,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
@@ -881,7 +884,7 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 
 	if (lv1ent_page(sent)) {
 		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
-		kfree(page_entry(sent, 0));
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 		*pgcnt = 0;
 	}
 
@@ -1082,10 +1085,23 @@ static int __init exynos_iommu_init(void)
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


