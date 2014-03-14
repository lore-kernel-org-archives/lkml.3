Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaCNFMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:12:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57869 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaCNFMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:12:40 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-46-53228fc7d547
Date: Fri, 14 Mar 2014 14:12:38 +0900
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
Subject: [PATCH v11 23/27] iommu/exynos: fix address handling
Message-id: <20140314141238.a1c596c349eccf10b869f8d1@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zA93j/UrBBtcf8FjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXx5/ImpoKrKhWHr+1gaWCcJ9fFyMkhIWAisXj9V3YI
	W0ziwr31bF2MXBxCAssYJZbvW8YIU9R6ei4jRGI6o8TxSe2sIAkhgclMEl3nmUFsFgFViVPn
	HoHF2QS0JFbPPQ7WICLQxiTxtfEQC4jDLDCXWeLjtzlAOzg4hAVsJX4fUgdp4BVwlGg708QG
	sc1C4kJTBztEXFDix+R7LCA2M9DQzduaWCFseYnNa94yg8yUEOjlkLh3GWIzi4CAxLfJIMs4
	gBKyEpsOMEPMlJQ4uOIGywRGkVlIxs5CMnYWkrELGJlXMYqmFiQXFCelFxnqFSfmFpfmpesl
	5+duYoREb+8OxtsHrA8xJgOtnMgsJZqcD4z+vJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4mBQkJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgXPiioKN1QmcPU84/meVfZpcsCvt3sj0+28ZV+b5/
	jkGe+ZYWnc7vyhdEZKyfKzWVzcmXWfuwZFr5GeOfM2pk+a3EXhpuVgg6lL/qbYvseQdZhlV7
	sksuM/65JXZXun6J0Y4Wce3jpXNjCmoFjy3yiX516+Ble8+7NWyTr7z/pKuykCPZMdBCiaU4
	I9FQi7moOBEAK4u6BPQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd3j/UrBBi2v2Czu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8efyJqaCqyoV
	h6/tYGlgnCfXxcjJISFgItF6ei4jhC0mceHeerYuRi4OIYHpjBLHJ7WzgiSEBCYzSXSdZwax
	WQRUJU6dewQWZxPQklg99zgjSIOIQBuTxNfGQywgDrPAXGaJj9/mAI3i4BAWsJX4fUgdpIFX
	wFGi7UwTG8Q2C4kLTR3sEHFBiR+T77GA2MxAQzdva2KFsOUlNq95yzyBkW8WkrJZSMpmISlb
	wMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4NTyT3sG4qsHiEKMAB6MSD++Mo4rBQqyJ
	ZcWVuYcYJTiYlUR4qyKUgoV4UxIrq1KL8uOLSnNSiw8xJgO9PZFZSjQ5H5i28kriDY1NzIws
	jcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsefzFsOUj9MnX51uPiPWfs6c
	dPEyluNe0+TPL3jyX/Nw+jI7XrlNbY0pj2a+Eds4VWnO4+Ds2f0MrxLtH9Vfr669dWu9RfBa
	o2zjxPdX5uWL7LJdfFXEhDN5h5vcZzY/lnX2G4/wWezfHmm7LlsndHvYhRqJbXE8s27cyzqj
	6GB8b7LoNAcJKSWW4oxEQy3mouJEAFEXGGhRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of __pa and __va macro is changed to virt_to_phys and phys_to_virt
which are recommended in driver code. printk formatting of physical
address is also fixed to %pa.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   45 +++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 2beb197..e375501 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -142,7 +142,8 @@ static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 
 static unsigned long *page_entry(unsigned long *sent, unsigned long iova)
 {
-	return (unsigned long *)__va(lv2table_base(sent)) + lv2ent_offset(iova);
+	return (unsigned long *)phys_to_virt(
+				lv2table_base(sent)) + lv2ent_offset(iova);
 }
 
 enum exynos_sysmmu_inttype {
@@ -215,7 +216,7 @@ struct sysmmu_drvdata {
 	struct iommu_domain *domain;
 	bool runtime_active;
 	bool suspended;
-	unsigned long pgtable;
+	phys_addr_t pgtable;
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
@@ -307,17 +308,17 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 
 static void show_fault_information(const char *name,
 		enum exynos_sysmmu_inttype itype,
-		unsigned long pgtable_base, unsigned long fault_addr)
+		phys_addr_t pgtable_base, unsigned long fault_addr)
 {
 	unsigned long *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at 0x%lx by %s(Page table base: 0x%lx)\n",
-		sysmmu_fault_name[itype], fault_addr, name, pgtable_base);
+	pr_err("%s occurred at %#lx by %s(Page table base: %pa)\n",
+		sysmmu_fault_name[itype], fault_addr, name, &pgtable_base);
 
-	ent = section_entry(__va(pgtable_base), fault_addr);
+	ent = section_entry(phys_to_virt(pgtable_base), fault_addr);
 	pr_err("\tLv1 entry: 0x%lx\n", *ent);
 
 	if (lv1ent_page(ent)) {
@@ -917,7 +918,7 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
 			kmem_cache_free(lv2table_kmem_cache,
-					__va(lv2table_base(priv->pgtable + i)));
+				phys_to_virt(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -931,11 +932,12 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	struct exynos_iommu_domain *priv = domain->priv;
 	unsigned long flags;
+	phys_addr_t pgtable = virt_to_phys(priv->pgtable);
 	int ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
+	ret = __exynos_sysmmu_enable(dev, pgtable, domain);
 	if (ret == 0) {
 		list_add_tail(&owner->client, &priv->clients);
 		owner->domain = domain;
@@ -943,13 +945,14 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0)
-		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#x\n",
-				__func__, __pa(priv->pgtable));
-	else
-		dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%x%s\n",
-					__func__, __pa(priv->pgtable),
-					(ret == 0) ? "" : ", again");
+	if (ret < 0) {
+		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %pa\n",
+				__func__, &pgtable);
+		return ret;
+	}
+
+	dev_dbg(dev, "%s: Attached IOMMU with pgtable %pa %s\n",
+		__func__, &pgtable, (ret == 0) ? "" : ", again");
 
 	return ret;
 }
@@ -975,11 +978,13 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (owner == dev->archdata.iommu)
-		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#x\n",
-					__func__, __pa(priv->pgtable));
-	else
+	if (owner == dev->archdata.iommu) {
+		phys_addr_t pgtable = virt_to_phys(priv->pgtable);
+		dev_dbg(dev, "%s: Detached IOMMU with pgtable %pa\n",
+					__func__, &pgtable);
+	} else {
 		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
+	}
 }
 
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
@@ -998,7 +1003,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 		if (!pent)
 			return ERR_PTR(-ENOMEM);
 
-		*sent = mk_lv1ent_page(__pa(pent));
+		*sent = mk_lv1ent_page(virt_to_phys(pent));
 		*pgcounter = NUM_LV2ENTRIES;
 		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
 		pgtable_flush(sent, sent + 1);
-- 
1.7.9.5

