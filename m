Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaELGRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:17:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25891 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaELGR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:17:28 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-11-5370676e3ace
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
Subject: [PATCH v13 19/19] iommu/exynos: apply workaround of caching fault page
 table entries
Date: Mon, 12 May 2014 11:45:04 +0530
Message-id: <1399875304-19948-20-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWyRsSkTjcvvSDY4McBZYs7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6M99vPsBS8yql4fTivgXFdRBcjB4eEgInEsed8XYycQKaYxIV769lAbCGB
	pYwSU7rdIOImEi9v7GHtYuQCii9ilHg69TIbhDOBSeLEhB6wDjYBQ4nt966AVYkIrGaU6Lt4
	hh3EYRaYzSxx5NFiRpAqYYF4iV8vm8E6WARUJVrWbgOL8wp4SMzbMJcZ4iQFiTmTbEDCnEDh
	z6unQJ3kLnHs1VWwBRICazkkWh89ZoSYIyDxbfIhFoheWYlNB5ghzpaUOLjiBssERuEFjAyr
	GEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQIj9fS/Z307GG8esD7EmAw0biKzlGhyPjDS80ri
	DY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo/8SZ82N
	Dw4a2Ap7PW+w2ndkmYrWtJuFj2xEQ/8GSrHZvJpXHbHyTKKF6ITMn8+f2dtJmJ4V8pm4ZPXs
	zXHb5R7+4Wx4GZj89L3ihBkvz188aus1UUzCrlv8847/nZcZz82ZVsz65GBOrcv5sqef/dkr
	5imZqsepLP+iFFras6m1b+akQs/z7kosxRmJhlrMRcWJANAm6hbqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd289IJggzfbxC3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZrzffoal4FVOxevDeQ2M6yK6GDk5
	JARMJF7e2MMKYYtJXLi3nq2LkYtDSGARo8TTqZehnAlMEicm9LCBVLEJGEpsv3eFFSQhIrCa
	UaLv4hl2EIdZYDazxJFHixlBqoQF4iV+vWwG62ARUJVoWbsNLM4r4CExb8Nc5i5GDqB9ChJz
	JtmAhDmBwp9XTwErFxJwlzj26irrBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC
	U8EzqR2MKxssDjEKcDAq8fB+YCgIFmJNLCuuzD3EKMHBrCTC+9EfKMSbklhZlVqUH19UmpNa
	fIgxGeioicxSosn5wDSVVxJvaGxibmpsamliYWJmSZqwkjjvgVbrQCGB9MSS1OzU1ILUIpgt
	TBycUg2Me7+sVORU/fNQ5v5DA6P8TY803rcqeM3bWmH+R+H1XJZvfZxrzi1l1pocti/9mscn
	B/f3VZ9kZFX4bSu6/s7aOEWxK3RXVriQa9Rdm6B5+x2bbogrKyyr+rnD0/dr9OxLu89n3tmd
	MS/n7fx3vfrnF0UabWE4/zDcbueOg3VV0naf9Lobl3p8VGIpzkg01GIuKk4EAHw0FSpJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch contains 2 workaround for the System MMU v3.x.

System MMU v3.2 and v3.3 has FLPD cache that caches first level page
table entries to reduce page table walking latency. However, the
FLPD cache is filled with a first level page table entry even though
it is not accessed by a master H/W because System MMU v3.3
speculatively prefetches page table entries that may be accessed
in the near future by the master H/W.
The prefetched FLPD cache entries are not invalidated by iommu_unmap()
because iommu_unmap() only unmaps and invalidates the page table
entries that is mapped.

Because exynos-iommu driver discards a second level page table when
it needs to be replaced with another second level page table or
a first level page table entry with 1MB mapping, It is required to
invalidate FLPD cache that may contain the first level page table
entry that points to the second level page table.

Another workaround of System MMU v3.3 is initializing the first level
page table entries with the second level page table which is filled
with all zeros. This prevents System MMU prefetches 'fault' first
level page table entry which may lead page fault on access to 16MiB
wide.

System MMU 3.x fetches consecutive page table entries by a page
table walking to maximize bus utilization and to minimize TLB miss
panelty.
Unfortunately, functional problem is raised with the fetching behavior
because it fetches 'fault' page table entries that specifies no
translation information and that a valid translation information will
be written to in the near future. The logic in the System MMU generates
page fault with the cached fault entries that is no longer coherent
with the page table which is updated.

There is another workaround that must be implemented by I/O virtual
memory manager: any two consecutive I/O virtual memory area must have
a hole between the two that is larger than or equal to 128KiB.
Also, next I/O virtual memory area must be started from the next
128KiB boundary.

0            128K           256K               384K             512K
|-------------|---------------|-----------------|----------------|
|area1---------------->|.........hole...........|<--- area2 -----

The constraint is depicted above.
The size is selected by the calculation followed:
 - System MMU can fetch consecutive 64 page table entries at once
   64 * 4KiB = 256KiB. This is the size between 128K ~ 384K of the
   above picture. This style of fetching is 'block fetch'. It fetches
   the page table entries predefined consecutive page table entries
   including the entry that is the reason of the page table walking.
 - System MMU can prefetch upto consecutive 32 page table entries.
   This is the size between 256K ~ 384K.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  163 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 146 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 26fb4d7..82aecd0 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -45,8 +45,12 @@ typedef u32 sysmmu_pte_t;
 #define LPAGE_MASK (~(LPAGE_SIZE - 1))
 #define SPAGE_MASK (~(SPAGE_SIZE - 1))
 
-#define lv1ent_fault(sent) (((*(sent) & 3) == 0) || ((*(sent) & 3) == 3))
-#define lv1ent_page(sent) ((*(sent) & 3) == 1)
+#define lv1ent_fault(sent) ((*(sent) == ZERO_LV2LINK) || \
+			   ((*(sent) & 3) == 0) || ((*(sent) & 3) == 3))
+#define lv1ent_zero(sent) (*(sent) == ZERO_LV2LINK)
+#define lv1ent_page_zero(sent) ((*(sent) & 3) == 1)
+#define lv1ent_page(sent) ((*(sent) != ZERO_LV2LINK) && \
+			  ((*(sent) & 3) == 1))
 #define lv1ent_section(sent) ((*(sent) & 3) == 2)
 
 #define lv2ent_fault(pent) ((*(pent) & 3) == 0)
@@ -130,6 +134,8 @@ static u32 lv2ent_offset(sysmmu_iova_t iova)
 #define has_sysmmu(dev)		(dev->archdata.iommu != NULL)
 
 static struct kmem_cache *lv2table_kmem_cache;
+static sysmmu_pte_t *zero_lv2_table;
+#define ZERO_LV2LINK mk_lv1ent_page(virt_to_phys(zero_lv2_table))
 
 static sysmmu_pte_t *section_entry(sysmmu_pte_t *pgtable, sysmmu_iova_t iova)
 {
@@ -515,6 +521,32 @@ static bool exynos_sysmmu_disable(struct device *dev)
 	return disabled;
 }
 
+static void __sysmmu_tlb_invalidate_flpdcache(struct sysmmu_drvdata *data,
+					      sysmmu_iova_t iova)
+{
+	if (__raw_sysmmu_version(data) == MAKE_MMU_VER(3, 3))
+		__raw_writel(iova | 0x1, data->sfrbase + REG_MMU_FLUSH_ENTRY);
+}
+
+static void sysmmu_tlb_invalidate_flpdcache(struct device *dev,
+					    sysmmu_iova_t iova)
+{
+	unsigned long flags;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct sysmmu_drvdata *data = dev_get_drvdata(owner->sysmmu);
+
+	if (!IS_ERR(data->clk_master))
+		clk_enable(data->clk_master);
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (is_sysmmu_active(data))
+		__sysmmu_tlb_invalidate_flpdcache(data, iova);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	if (!IS_ERR(data->clk_master))
+		clk_disable(data->clk_master);
+}
+
 static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 					size_t size)
 {
@@ -667,21 +699,32 @@ static inline void pgtable_flush(void *vastart, void *vaend)
 static int exynos_iommu_domain_init(struct iommu_domain *domain)
 {
 	struct exynos_iommu_domain *priv;
+	int i;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->pgtable = (sysmmu_pte_t *)__get_free_pages(
-						GFP_KERNEL | __GFP_ZERO, 2);
+	priv->pgtable = (sysmmu_pte_t *)__get_free_pages(GFP_KERNEL, 2);
 	if (!priv->pgtable)
 		goto err_pgtable;
 
-	priv->lv2entcnt = (short *)__get_free_pages(
-						GFP_KERNEL | __GFP_ZERO, 1);
+	priv->lv2entcnt = (short *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
 	if (!priv->lv2entcnt)
 		goto err_counter;
 
+	/* w/a of System MMU v3.3 to prevent caching 1MiB mapping */
+	for (i = 0; i < NUM_LV1ENTRIES; i += 8) {
+		priv->pgtable[i + 0] = ZERO_LV2LINK;
+		priv->pgtable[i + 1] = ZERO_LV2LINK;
+		priv->pgtable[i + 2] = ZERO_LV2LINK;
+		priv->pgtable[i + 3] = ZERO_LV2LINK;
+		priv->pgtable[i + 4] = ZERO_LV2LINK;
+		priv->pgtable[i + 5] = ZERO_LV2LINK;
+		priv->pgtable[i + 6] = ZERO_LV2LINK;
+		priv->pgtable[i + 7] = ZERO_LV2LINK;
+	}
+
 	pgtable_flush(priv->pgtable, priv->pgtable + NUM_LV1ENTRIES);
 
 	spin_lock_init(&priv->lock);
@@ -794,8 +837,8 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 		dev_err(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
-static sysmmu_pte_t *alloc_lv2entry(sysmmu_pte_t *sent, sysmmu_iova_t iova,
-					short *pgcounter)
+static sysmmu_pte_t *alloc_lv2entry(struct exynos_iommu_domain *priv,
+		sysmmu_pte_t *sent, sysmmu_iova_t iova, short *pgcounter)
 {
 	if (lv1ent_section(sent)) {
 		WARN(1, "Trying mapping on %#08x mapped with 1MiB page", iova);
@@ -804,6 +847,7 @@ static sysmmu_pte_t *alloc_lv2entry(sysmmu_pte_t *sent, sysmmu_iova_t iova,
 
 	if (lv1ent_fault(sent)) {
 		sysmmu_pte_t *pent;
+		bool need_flush_flpd_cache = lv1ent_zero(sent);
 
 		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned int)pent & (LV2TABLE_SIZE - 1));
@@ -814,12 +858,39 @@ static sysmmu_pte_t *alloc_lv2entry(sysmmu_pte_t *sent, sysmmu_iova_t iova,
 		*pgcounter = NUM_LV2ENTRIES;
 		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
 		pgtable_flush(sent, sent + 1);
+
+		/*
+		 * If pretched SLPD is a fault SLPD in zero_l2_table, FLPD cache
+		 * may caches the address of zero_l2_table. This function
+		 * replaces the zero_l2_table with new L2 page table to write
+		 * valid mappings.
+		 * Accessing the valid area may cause page fault since FLPD
+		 * cache may still caches zero_l2_table for the valid area
+		 * instead of new L2 page table that have the mapping
+		 * information of the valid area
+		 * Thus any replacement of zero_l2_table with other valid L2
+		 * page table must involve FLPD cache invalidation for System
+		 * MMU v3.3.
+		 * FLPD cache invalidation is performed with TLB invalidation
+		 * by VPN without blocking. It is safe to invalidate TLB without
+		 * blocking because the target address of TLB invalidation is
+		 * not currently mapped.
+		 */
+		if (need_flush_flpd_cache) {
+			struct exynos_iommu_owner *owner;
+			spin_lock(&priv->lock);
+			list_for_each_entry(owner, &priv->clients, client)
+				sysmmu_tlb_invalidate_flpdcache(
+							owner->dev, iova);
+			spin_unlock(&priv->lock);
+		}
 	}
 
 	return page_entry(sent, iova);
 }
 
-static int lv1set_section(sysmmu_pte_t *sent, sysmmu_iova_t iova,
+static int lv1set_section(struct exynos_iommu_domain *priv,
+			  sysmmu_pte_t *sent, sysmmu_iova_t iova,
 			  phys_addr_t paddr, short *pgcnt)
 {
 	if (lv1ent_section(sent)) {
@@ -843,6 +914,18 @@ static int lv1set_section(sysmmu_pte_t *sent, sysmmu_iova_t iova,
 
 	pgtable_flush(sent, sent + 1);
 
+	spin_lock(&priv->lock);
+	if (lv1ent_page_zero(sent)) {
+		struct exynos_iommu_owner *owner;
+		/*
+		 * Flushing FLPD cache in System MMU v3.3 that may cache a FLPD
+		 * entry by speculative prefetch of SLPD which has no mapping.
+		 */
+		list_for_each_entry(owner, &priv->clients, client)
+			sysmmu_tlb_invalidate_flpdcache(owner->dev, iova);
+	}
+	spin_unlock(&priv->lock);
+
 	return 0;
 }
 
@@ -874,6 +957,32 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 	return 0;
 }
 
+/*
+ * *CAUTION* to the I/O virtual memory managers that support exynos-iommu:
+ *
+ * System MMU v3.x have an advanced logic to improve address translation
+ * performance with caching more page table entries by a page table walk.
+ * However, the logic has a bug that caching fault page table entries and System
+ * MMU reports page fault if the cached fault entry is hit even though the fault
+ * entry is updated to a valid entry after the entry is cached.
+ * To prevent caching fault page table entries which may be updated to valid
+ * entries later, the virtual memory manager should care about the w/a about the
+ * problem. The followings describe w/a.
+ *
+ * Any two consecutive I/O virtual address regions must have a hole of 128KiB
+ * in maximum to prevent misbehavior of System MMU 3.x. (w/a of h/w bug)
+ *
+ * Precisely, any start address of I/O virtual region must be aligned by
+ * the following sizes for System MMU v3.1 and v3.2.
+ * System MMU v3.1: 128KiB
+ * System MMU v3.2: 256KiB
+ *
+ * Because System MMU v3.3 caches page table entries more aggressively, it needs
+ * more w/a.
+ * - Any two consecutive I/O virtual regions must be have a hole of larger size
+ *   than or equal size to 128KiB.
+ * - Start address of an I/O virtual region must be aligned by 128KiB.
+ */
 static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 			 phys_addr_t paddr, size_t size, int prot)
 {
@@ -890,12 +999,12 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 	entry = section_entry(priv->pgtable, iova);
 
 	if (size == SECT_SIZE) {
-		ret = lv1set_section(entry, iova, paddr,
+		ret = lv1set_section(priv, entry, iova, paddr,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 	} else {
 		sysmmu_pte_t *pent;
 
-		pent = alloc_lv2entry(entry, iova,
+		pent = alloc_lv2entry(priv, entry, iova,
 					&priv->lv2entcnt[lv1ent_offset(iova)]);
 
 		if (IS_ERR(pent))
@@ -914,11 +1023,24 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 	return ret;
 }
 
+static void exynos_iommu_tlb_invalidate_entry(struct exynos_iommu_domain *priv,
+						sysmmu_iova_t iova, size_t size)
+{
+	struct exynos_iommu_owner *owner;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	list_for_each_entry(owner, &priv->clients, client)
+		sysmmu_tlb_invalidate_entry(owner->dev, iova, size);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
 static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					unsigned long l_iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct exynos_iommu_owner *owner;
 	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
 	sysmmu_pte_t *ent;
 	size_t err_pgsize;
@@ -936,7 +1058,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 			goto err;
 		}
 
-		*ent = 0;
+		*ent = ZERO_LV2LINK; /* w/a for h/w bug in Sysmem MMU v3.3 */
 		pgtable_flush(ent, ent + 1);
 		size = SECT_SIZE;
 		goto done;
@@ -979,10 +1101,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 done:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(owner, &priv->clients, client)
-		sysmmu_tlb_invalidate_entry(owner->dev, iova, size);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	exynos_iommu_tlb_invalidate_entry(priv, iova, size);
 
 	return size;
 err:
@@ -1078,6 +1197,14 @@ static int __init exynos_iommu_init(void)
 		goto err_reg_driver;
 	}
 
+	zero_lv2_table = kmem_cache_zalloc(lv2table_kmem_cache, GFP_KERNEL);
+	if (zero_lv2_table == NULL) {
+		pr_err("%s: Failed to allocate zero level2 page table\n",
+			__func__);
+		ret = -ENOMEM;
+		goto err_zero_lv2;
+	}
+
 	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
 	if (ret) {
 		pr_err("%s: Failed to register exynos-iommu driver.\n",
@@ -1087,6 +1214,8 @@ static int __init exynos_iommu_init(void)
 
 	return 0;
 err_set_iommu:
+	kmem_cache_free(lv2table_kmem_cache, zero_lv2_table);
+err_zero_lv2:
 	platform_driver_unregister(&exynos_sysmmu_driver);
 err_reg_driver:
 	kmem_cache_destroy(lv2table_kmem_cache);
-- 
1.7.9.5

