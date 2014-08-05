Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaHEKt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:49:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44638 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaHEKtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:13 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ea-53e0b6a7d7ab
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 26/29] iommu: exynos: rename variables to reflect their purpose
Date: Tue, 05 Aug 2014 12:47:54 +0200
Message-id: <1407235677-26324-27-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7rLtz0INmg+rmjxd9IxdovmxevZ
	LCbdn8BisWC/tUXn7A3sFr0LrrJZnG16w27ROXEJu8WXKw+ZLDY9vsZqcXnXHDaLGef3MVms
	PXKX3eLU9c9sFv96DzJanDl9idXi/54d7BaH37SzWhx5uJvdYtWuP4wWt3/zOYh6PDk4j8nj
	969JjB47Z91l95jdMZPVY9OqTjaP/XPXsHtsXlLvcfvfY2aPyTeWM3pcOdHE6tHb/I7NY8vV
	dhaPvi2rGD0+b5IL4IvisklJzcksSy3St0vgypjQ9pu94FtpxcLLF5gaGOcndTFyckgImEgc
	mniaHcIWk7hwbz1bFyMXh5DAUkaJSR0XWEASQgJ9TBKTH1mB2GwChhJdb7vAikQEehkl+pt+
	MIE4zALrWCX2914H6xAW8Jf407OeGcRmEVCV2PJnCtgKXgFPiZOf9rBCrJOT+P9yBROIzQkU
	P3zzACvENg+JnxvWsE9g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyRyvuxgXHzM
	6hCjAAejEg+vwem7wUKsiWXFlbmHGCU4mJVEeCXWPAgW4k1JrKxKLcqPLyrNSS0+xMjEwSnV
	wDj3tPKRA3PyJ98J2r+W49vzEmbhh+Z5qZ2yq2Tn3fqSu2BmSJP5p5LHtfyzn3If6mH/m7f8
	3mfHlINvw47OvBQqa21Ysiswov5L/nSDdOdPWoJeC7dt6N5R+S72/56wDy8ZtxTM3nz1/Maf
	Wy9Wij/fl3biLqOpYIneyZvZ2ToJX7a5XpPqnZ6jxFKckWioxVxUnAgAn9tGz3oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames some variables to make the code easier to understand.
'domain' is replaced by 'iommu_domain' (more generic entity) and really
meaning less 'priv' by 'domain' to reflect its purpose.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 191 ++++++++++++++++++++++---------------------
 1 file changed, 97 insertions(+), 94 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 5cd91b11..7600861 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -440,8 +440,8 @@ static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
 		clk_disable(data->clk_master);
 }
 
-static int __sysmmu_enable(struct sysmmu_drvdata *data,
-			phys_addr_t pgtable, struct iommu_domain *domain)
+static int __sysmmu_enable(struct sysmmu_drvdata *data, phys_addr_t pgtable,
+			   struct iommu_domain *iommu_domain)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -449,7 +449,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	spin_lock_irqsave(&data->lock, flags);
 	if (set_sysmmu_active(data)) {
 		data->pgtable = pgtable;
-		data->domain = domain;
+		data->domain = iommu_domain;
 
 		__sysmmu_enable_nocount(data);
 
@@ -664,92 +664,93 @@ static inline void pgtable_flush(void *vastart, void *vaend)
 				virt_to_phys(vaend));
 }
 
-static int exynos_iommu_domain_init(struct iommu_domain *domain)
+static int exynos_iommu_domain_init(struct iommu_domain *iommu_domain)
 {
-	struct exynos_iommu_domain *priv;
+	struct exynos_iommu_domain *domain;
 	int i;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
 		return -ENOMEM;
 
-	priv->pgtable = (sysmmu_pte_t *)__get_free_pages(GFP_KERNEL, 2);
-	if (!priv->pgtable)
+	domain->pgtable = (sysmmu_pte_t *)__get_free_pages(GFP_KERNEL, 2);
+	if (!domain->pgtable)
 		goto err_pgtable;
 
-	priv->lv2entcnt = (short *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
-	if (!priv->lv2entcnt)
+	domain->lv2entcnt = (short *)
+			    __get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	if (!domain->lv2entcnt)
 		goto err_counter;
 
 	/* w/a of System MMU v3.3 to prevent caching 1MiB mapping */
 	for (i = 0; i < NUM_LV1ENTRIES; i += 8) {
-		priv->pgtable[i + 0] = ZERO_LV2LINK;
-		priv->pgtable[i + 1] = ZERO_LV2LINK;
-		priv->pgtable[i + 2] = ZERO_LV2LINK;
-		priv->pgtable[i + 3] = ZERO_LV2LINK;
-		priv->pgtable[i + 4] = ZERO_LV2LINK;
-		priv->pgtable[i + 5] = ZERO_LV2LINK;
-		priv->pgtable[i + 6] = ZERO_LV2LINK;
-		priv->pgtable[i + 7] = ZERO_LV2LINK;
+		domain->pgtable[i + 0] = ZERO_LV2LINK;
+		domain->pgtable[i + 1] = ZERO_LV2LINK;
+		domain->pgtable[i + 2] = ZERO_LV2LINK;
+		domain->pgtable[i + 3] = ZERO_LV2LINK;
+		domain->pgtable[i + 4] = ZERO_LV2LINK;
+		domain->pgtable[i + 5] = ZERO_LV2LINK;
+		domain->pgtable[i + 6] = ZERO_LV2LINK;
+		domain->pgtable[i + 7] = ZERO_LV2LINK;
 	}
 
-	pgtable_flush(priv->pgtable, priv->pgtable + NUM_LV1ENTRIES);
+	pgtable_flush(domain->pgtable, domain->pgtable + NUM_LV1ENTRIES);
 
-	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->pgtablelock);
-	INIT_LIST_HEAD(&priv->clients);
+	spin_lock_init(&domain->lock);
+	spin_lock_init(&domain->pgtablelock);
+	INIT_LIST_HEAD(&domain->clients);
 
-	domain->geometry.aperture_start = 0;
-	domain->geometry.aperture_end   = ~0UL;
-	domain->geometry.force_aperture = true;
+	iommu_domain->geometry.aperture_start = 0;
+	iommu_domain->geometry.aperture_end   = ~0UL;
+	iommu_domain->geometry.force_aperture = true;
 
-	domain->priv = priv;
+	iommu_domain->priv = domain;
 	return 0;
 
 err_counter:
-	free_pages((unsigned long)priv->pgtable, 2);
+	free_pages((unsigned long)domain->pgtable, 2);
 err_pgtable:
-	kfree(priv);
+	kfree(domain);
 	return -ENOMEM;
 }
 
-static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
+static void exynos_iommu_domain_destroy(struct iommu_domain *iommu_domain)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *domain = iommu_domain->priv;
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	int i;
 
-	WARN_ON(!list_empty(&priv->clients));
+	WARN_ON(!list_empty(&domain->clients));
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&domain->lock, flags);
 
-	list_for_each_entry(data, &priv->clients, domain_node) {
+	list_for_each_entry(data, &domain->clients, domain_node) {
 		if (__sysmmu_disable(data))
 			data->master = NULL;
 		list_del_init(&data->domain_node);
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&domain->lock, flags);
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
-		if (lv1ent_page(priv->pgtable + i))
+		if (lv1ent_page(domain->pgtable + i))
 			kmem_cache_free(lv2table_kmem_cache,
-				phys_to_virt(lv2table_base(priv->pgtable + i)));
+			      phys_to_virt(lv2table_base(domain->pgtable + i)));
 
-	free_pages((unsigned long)priv->pgtable, 2);
-	free_pages((unsigned long)priv->lv2entcnt, 1);
-	kfree(domain->priv);
-	domain->priv = NULL;
+	free_pages((unsigned long)domain->pgtable, 2);
+	free_pages((unsigned long)domain->lv2entcnt, 1);
+	kfree(iommu_domain->priv);
+	iommu_domain->priv = NULL;
 }
 
-static int exynos_iommu_attach_device(struct iommu_domain *domain,
+static int exynos_iommu_attach_device(struct iommu_domain *iommu_domain,
 				   struct device *dev)
 {
 	struct exynos_iommu_owner *owner = dev->archdata.iommu;
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *domain = iommu_domain->priv;
 	struct sysmmu_drvdata *data;
-	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
+	phys_addr_t pagetable = virt_to_phys(domain->pgtable);
 	unsigned long flags;
 	int ret = -ENODEV;
 
@@ -758,13 +759,13 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	list_for_each_entry(data, &owner->clients, owner_node) {
 		pm_runtime_get_sync(data->sysmmu);
-		ret = __sysmmu_enable(data, pagetable, domain);
+		ret = __sysmmu_enable(data, pagetable, iommu_domain);
 		if (ret >= 0) {
 			data->master = dev;
 
-			spin_lock_irqsave(&priv->lock, flags);
-			list_add_tail(&data->domain_node, &priv->clients);
-			spin_unlock_irqrestore(&priv->lock, flags);
+			spin_lock_irqsave(&domain->lock, flags);
+			list_add_tail(&data->domain_node, &domain->clients);
+			spin_unlock_irqrestore(&domain->lock, flags);
 		}
 		pm_runtime_put(data->sysmmu);
 	}
@@ -781,11 +782,11 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	return ret;
 }
 
-static void exynos_iommu_detach_device(struct iommu_domain *domain,
+static void exynos_iommu_detach_device(struct iommu_domain *iommu_domain,
 				    struct device *dev)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
-	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
+	struct exynos_iommu_domain *domain = iommu_domain->priv;
+	phys_addr_t pagetable = virt_to_phys(domain->pgtable);
 	struct sysmmu_drvdata *data, *next;
 	unsigned long flags;
 	int found = 0;
@@ -793,8 +794,8 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 	if (!has_sysmmu(dev))
 		return;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry_safe(data, next, &priv->clients, domain_node) {
+	spin_lock_irqsave(&domain->lock, flags);
+	list_for_each_entry_safe(data, next, &domain->clients, domain_node) {
 		if (data->master == dev) {
 			if (__sysmmu_disable(data)) {
 				data->master = NULL;
@@ -803,7 +804,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 			found = true;
 		}
 	}
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&domain->lock, flags);
 
 	if (found)
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %pa\n",
@@ -812,7 +813,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 		dev_err(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
-static sysmmu_pte_t *alloc_lv2entry(struct exynos_iommu_domain *priv,
+static sysmmu_pte_t *alloc_lv2entry(struct exynos_iommu_domain *domain,
 		sysmmu_pte_t *sent, sysmmu_iova_t iova, short *pgcounter)
 {
 	if (lv1ent_section(sent)) {
@@ -854,17 +855,17 @@ static sysmmu_pte_t *alloc_lv2entry(struct exynos_iommu_domain *priv,
 		if (need_flush_flpd_cache) {
 			struct sysmmu_drvdata *data;
 
-			spin_lock(&priv->lock);
-			list_for_each_entry(data, &priv->clients, domain_node)
+			spin_lock(&domain->lock);
+			list_for_each_entry(data, &domain->clients, domain_node)
 				sysmmu_tlb_invalidate_flpdcache(data, iova);
-			spin_unlock(&priv->lock);
+			spin_unlock(&domain->lock);
 		}
 	}
 
 	return page_entry(sent, iova);
 }
 
-static int lv1set_section(struct exynos_iommu_domain *priv,
+static int lv1set_section(struct exynos_iommu_domain *domain,
 			  sysmmu_pte_t *sent, sysmmu_iova_t iova,
 			  phys_addr_t paddr, short *pgcnt)
 {
@@ -889,17 +890,17 @@ static int lv1set_section(struct exynos_iommu_domain *priv,
 
 	pgtable_flush(sent, sent + 1);
 
-	spin_lock(&priv->lock);
+	spin_lock(&domain->lock);
 	if (lv1ent_page_zero(sent)) {
 		struct sysmmu_drvdata *data;
 		/*
 		 * Flushing FLPD cache in System MMU v3.3 that may cache a FLPD
 		 * entry by speculative prefetch of SLPD which has no mapping.
 		 */
-		list_for_each_entry(data, &priv->clients, domain_node)
+		list_for_each_entry(data, &domain->clients, domain_node)
 			sysmmu_tlb_invalidate_flpdcache(data, iova);
 	}
-	spin_unlock(&priv->lock);
+	spin_unlock(&domain->lock);
 
 	return 0;
 }
@@ -959,74 +960,76 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
  *   than or equal size to 128KiB.
  * - Start address of an I/O virtual region must be aligned by 128KiB.
  */
-static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
-			 phys_addr_t paddr, size_t size, int prot)
+static int exynos_iommu_map(struct iommu_domain *iommu_domain,
+			unsigned long l_iova, phys_addr_t paddr, size_t size,
+			int prot)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *domain = iommu_domain->priv;
 	sysmmu_pte_t *entry;
 	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
 	unsigned long flags;
 	int ret = -ENOMEM;
 
-	BUG_ON(priv->pgtable == NULL);
+	BUG_ON(domain->pgtable == NULL);
 
-	spin_lock_irqsave(&priv->pgtablelock, flags);
+	spin_lock_irqsave(&domain->pgtablelock, flags);
 
-	entry = section_entry(priv->pgtable, iova);
+	entry = section_entry(domain->pgtable, iova);
 
 	if (size == SECT_SIZE) {
-		ret = lv1set_section(priv, entry, iova, paddr,
-					&priv->lv2entcnt[lv1ent_offset(iova)]);
+		ret = lv1set_section(domain, entry, iova, paddr,
+				     &domain->lv2entcnt[lv1ent_offset(iova)]);
 	} else {
 		sysmmu_pte_t *pent;
 
-		pent = alloc_lv2entry(priv, entry, iova,
-					&priv->lv2entcnt[lv1ent_offset(iova)]);
+		pent = alloc_lv2entry(domain, entry, iova,
+				      &domain->lv2entcnt[lv1ent_offset(iova)]);
 
 		if (IS_ERR(pent))
 			ret = PTR_ERR(pent);
 		else
 			ret = lv2set_page(pent, paddr, size,
-					&priv->lv2entcnt[lv1ent_offset(iova)]);
+				       &domain->lv2entcnt[lv1ent_offset(iova)]);
 	}
 
 	if (ret)
 		pr_err("%s: Failed(%d) to map %#zx bytes @ %#x\n",
 			__func__, ret, size, iova);
 
-	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+	spin_unlock_irqrestore(&domain->pgtablelock, flags);
 
 	return ret;
 }
 
-static void exynos_iommu_tlb_invalidate_entry(struct exynos_iommu_domain *priv,
-						sysmmu_iova_t iova, size_t size)
+static
+void exynos_iommu_tlb_invalidate_entry(struct exynos_iommu_domain *domain,
+					sysmmu_iova_t iova, size_t size)
 {
 	struct sysmmu_drvdata *data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&domain->lock, flags);
 
-	list_for_each_entry(data, &priv->clients, domain_node)
+	list_for_each_entry(data, &domain->clients, domain_node)
 		sysmmu_tlb_invalidate_entry(data, iova, size);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
-static size_t exynos_iommu_unmap(struct iommu_domain *domain,
+static size_t exynos_iommu_unmap(struct iommu_domain *iommu_domain,
 					unsigned long l_iova, size_t size)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *domain = iommu_domain->priv;
 	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
 	sysmmu_pte_t *ent;
 	size_t err_pgsize;
 	unsigned long flags;
 
-	BUG_ON(priv->pgtable == NULL);
+	BUG_ON(domain->pgtable == NULL);
 
-	spin_lock_irqsave(&priv->pgtablelock, flags);
+	spin_lock_irqsave(&domain->pgtablelock, flags);
 
-	ent = section_entry(priv->pgtable, iova);
+	ent = section_entry(domain->pgtable, iova);
 
 	if (lv1ent_section(ent)) {
 		if (WARN_ON(size < SECT_SIZE)) {
@@ -1059,7 +1062,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 		*ent = 0;
 		size = SPAGE_SIZE;
 		pgtable_flush(ent, ent + 1);
-		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
+		domain->lv2entcnt[lv1ent_offset(iova)] += 1;
 		goto done;
 	}
 
@@ -1073,15 +1076,15 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
-	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
+	domain->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
 done:
-	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+	spin_unlock_irqrestore(&domain->pgtablelock, flags);
 
-	exynos_iommu_tlb_invalidate_entry(priv, iova, size);
+	exynos_iommu_tlb_invalidate_entry(domain, iova, size);
 
 	return size;
 err:
-	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+	spin_unlock_irqrestore(&domain->pgtablelock, flags);
 
 	pr_err("%s: Failed: size(%#zx) @ %#x is smaller than page size %#zx\n",
 		__func__, size, iova, err_pgsize);
@@ -1089,17 +1092,17 @@ err:
 	return 0;
 }
 
-static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
+static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *iommu_domain,
 					  dma_addr_t iova)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *domain = iommu_domain->priv;
 	sysmmu_pte_t *entry;
 	unsigned long flags;
 	phys_addr_t phys = 0;
 
-	spin_lock_irqsave(&priv->pgtablelock, flags);
+	spin_lock_irqsave(&domain->pgtablelock, flags);
 
-	entry = section_entry(priv->pgtable, iova);
+	entry = section_entry(domain->pgtable, iova);
 
 	if (lv1ent_section(entry)) {
 		phys = section_phys(entry) + section_offs(iova);
@@ -1112,7 +1115,7 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 			phys = spage_phys(entry) + spage_offs(iova);
 	}
 
-	spin_unlock_irqrestore(&priv->pgtablelock, flags);
+	spin_unlock_irqrestore(&domain->pgtablelock, flags);
 
 	return phys;
 }
-- 
1.9.2

