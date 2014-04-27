Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaD0HlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8600 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaD0Hj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:27 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-a0-535cb42e2ab5
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
Subject: [PATCH v12 14/31] iommu/exynos: remove custom fault handler
Date: Sun, 27 Apr 2014 13:07:46 +0530
Message-id: <1398584283-22846-15-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkTldvS0ywwfwrhhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8azefcZ
	C26rVcyZeZa5gfGPfBcjJ4eEgInEm65f7BC2mMSFe+vZuhi5OIQEljJK7Dg4i7WLkQOsaNHT
	WIj4IkaJX6snsEA4E5gkHs04wwbSzSZgKLH93hVWkISIwGpGib6LZ9hBHGaBu0wSc1a9YwSp
	EhZwkfg89zYziM0ioCpx7NQyJhCbV8BDYsLiK2wQ6xQk5kyyAQlzAoWf3NnDAmILCbhLvD31
	BWyBhMBcDolb596xQ8wRkPg2+RALRK+sxKYDzBDvSEocXHGDZQKj8AJGhlWMoqkFyQXFSelF
	hnrFibnFpXnpesn5uZsYgfF4+t+z3h2Mtw9YH2JMBho3kVlKNDkfGM95JfGGxmZGFqYmpsZG
	5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDo0/e+9oR2/uz07w33+np7
	djsVpk5rucZ/XIfTa4Fv0Owg4Reu++/PeX7p78Kj02VLJDjXuPGuDkucfqFqr/8lf+9/Aua/
	+2ULFzz837sk2nbJYrn5E4Vsvp58dvNFD5e67KGrB5qUXE8+2s4Yc9OAzf+eR5es0wz5F7uX
	e4kGaoVb7l9q3+SnxFKckWioxVxUnAgAHIGoUN0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV29LTHBBvN61Czu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWh9+0s1qc/NPLaNFyvZfJYv2M1ywWq3b9YbSYeWsNi4Owx5OD85g8ZjdcZPH4d7ifyWPn
	rLvsHneu7WHz2Lyk3mPyjeWMHn1bVjF6fN4k53Hl6BmmAK6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDXlBTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZz+bdZyy4rVYxZ+ZZ5gbGP/JdjBwcEgImEouexnYxcgKZYhIX
	7q1n62Lk4hASWMQo8Wv1BBYIZwKTxKMZZ9hAqtgEDCW237vCCpIQEVjNKNF38Qw7iMMscJdJ
	Ys6qd4wgVcICLhKf595mBrFZBFQljp1axgRi8wp4SExYfIUNYrWCxJxJNiBhTqDwkzt7WEBs
	IQF3ibenvrBOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM42p9J72Bc1WBxiFGA
	g1GJh/eHdEywEGtiWXFl7iFGCQ5mJRFezulAId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4H
	JqK8knhDYxNzU2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDMkuiZwKys
	ZygvbmqcoFOWrO3H7m9vUPoke72ykb+qj+whqfsOepsnizSvuXpGp+Hx74hNWsdLDp15KRc/
	jeNn/JWPr5wr6x5K3D46d/38S76iRr/2xuztPtSov+XVymtr81abbrDen/mVO6xQIHfflm2T
	EnI6OyYaTo73Dui8fXiDCU/wE2slluKMREMt5qLiRABi/nJ2OgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This commit removes custom fault handler. The device drivers that
need to register fault handler can register
with iommu_set_fault_handler().

CC: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   80 +++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index ba477c4..b07b78b 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -125,16 +125,6 @@ enum exynos_sysmmu_inttype {
 	SYSMMU_FAULTS_NUM
 };
 
-/*
- * @itype: type of fault.
- * @pgtable_base: the physical address of page table base. This is 0 if @itype
- *                is SYSMMU_BUSERROR.
- * @fault_addr: the device (virtual) address that the System MMU tried to
- *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
- */
-typedef int (*sysmmu_fault_handler_t)(enum exynos_sysmmu_inttype itype,
-			unsigned long pgtable_base, unsigned long fault_addr);
-
 static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
 	REG_PAGE_FAULT_ADDR,
 	REG_AR_FAULT_ADDR,
@@ -176,7 +166,6 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
-	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
 };
 
@@ -245,34 +234,17 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 	__sysmmu_tlb_invalidate(sfrbase);
 }
 
-static void __set_fault_handler(struct sysmmu_drvdata *data,
-					sysmmu_fault_handler_t handler)
-{
-	unsigned long flags;
-
-	write_lock_irqsave(&data->lock, flags);
-	data->fault_handler = handler;
-	write_unlock_irqrestore(&data->lock, flags);
-}
-
-void exynos_sysmmu_set_fault_handler(struct device *dev,
-					sysmmu_fault_handler_t handler)
-{
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-
-	__set_fault_handler(data, handler);
-}
-
-static int default_fault_handler(enum exynos_sysmmu_inttype itype,
-		     unsigned long pgtable_base, unsigned long fault_addr)
+static void show_fault_information(const char *name,
+		enum exynos_sysmmu_inttype itype,
+		unsigned long pgtable_base, unsigned long fault_addr)
 {
 	unsigned long *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at 0x%lx(Page table base: 0x%lx)\n",
-			sysmmu_fault_name[itype], fault_addr, pgtable_base);
+	pr_err("%s occurred at 0x%lx by %s(Page table base: 0x%lx)\n",
+		sysmmu_fault_name[itype], fault_addr, name, pgtable_base);
 
 	ent = section_entry(__va(pgtable_base), fault_addr);
 	pr_err("\tLv1 entry: 0x%lx\n", *ent);
@@ -281,12 +253,6 @@ static int default_fault_handler(enum exynos_sysmmu_inttype itype,
 		ent = page_entry(ent, fault_addr);
 		pr_err("\t Lv2 entry: 0x%lx\n", *ent);
 	}
-
-	pr_err("Generating Kernel OOPS... because it is unrecoverable.\n");
-
-	BUG();
-
-	return 0;
 }
 
 static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
@@ -310,24 +276,28 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	else
 		addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
 
-	if (data->domain)
-		ret = report_iommu_fault(data->domain, data->dev, addr, itype);
-
-	if ((ret == -ENOSYS) && data->fault_handler) {
-		unsigned long base = data->pgtable;
-		if (itype != SYSMMU_FAULT_UNKNOWN)
-			base = __raw_readl(data->sfrbase + REG_PT_BASE_ADDR);
-		ret = data->fault_handler(itype, base, addr);
+	if (itype == SYSMMU_FAULT_UNKNOWN) {
+		pr_err("%s: Fault is not occurred by System MMU '%s'!\n",
+			__func__, dev_name(data->sysmmu));
+		pr_err("%s: Please check if IRQ is correctly configured.\n",
+			__func__);
+		BUG();
+	} else {
+		unsigned long base =
+				__raw_readl(data->sfrbase + REG_PT_BASE_ADDR);
+		show_fault_information(dev_name(data->sysmmu),
+					itype, base, addr);
+		if (data->domain)
+			ret = report_iommu_fault(data->domain,
+					data->dev, addr, itype);
 	}
 
-	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
-		__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
-	else
-		dev_dbg(data->sysmmu, "%s is not handled.\n",
-				sysmmu_fault_name[itype]);
+	/* fault is not recovered by fault handler */
+	BUG_ON(ret != 0);
 
-	if (itype != SYSMMU_FAULT_UNKNOWN)
-		sysmmu_unblock(data->sfrbase);
+	__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
+
+	sysmmu_unblock(data->sfrbase);
 
 	if (!IS_ERR(data->clk_master))
 		clk_disable(data->clk_master);
@@ -576,8 +546,6 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	rwlock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
-	__set_fault_handler(data, &default_fault_handler);
-
 	platform_set_drvdata(pdev, data);
 
 	pm_runtime_enable(dev);
-- 
1.7.9.5

