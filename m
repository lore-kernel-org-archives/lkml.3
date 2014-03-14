Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaCNFIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:08:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11104 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaCNFIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:08:35 -0400
X-AuditID: cbfee690-b7f266d00000287c-f6-53228eccdd30
Date: Fri, 14 Mar 2014 14:08:27 +0900
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
Subject: [PATCH v11 16/27] iommu/exynos: remove custom fault handler
Message-id: <20140314140827.a81ab9845150eec5a2ebf7fe@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI90zfUrBBquWa1jcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXRs/sCW0GXWsWHl1wNjFvluxg5OSQETCR+XdjACGGL
	SVy4t56ti5GLQ0hgGaPE9sNngBwOsKK/D60g4tMZJbadPsgI4Uxmkti0dgJYEYuAqsSBX+wg
	g9gEtCRWzz0OViMi0MYk8bXxEAuIwywwl1ni47c5bCBVwgIuEs+PHQBbzSvgKHF3wX5miDMs
	JC40dbBDxAUlfky+xwJiMwNN3bytiRXClpfYvOYtM8hQCYFODokbE0+DFbEICEh8mwyyDeRs
	WYlNB6BmSkocXHGDZQKjyCwkY2chGTsLydgFjMyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3
	MUJid8IOxnsHrA8xJgOtnMgsJZqcD4z9vJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeW
	pGanphakFsUXleakFh9iZOLglGpgbE6Rnyi+fFn3cX7GE3tf8JWbGrA/WZTuIXCsYbH1s+T7
	QRb/gk52nJNjemJU3GRYle5ioJf6KMD9hXJn8/27c/o/JHtyCHo1RBT4qM3/8e5BfVErt+Cp
	B58mC51ruRW0NPPJHJGnpw2Xc/z0e73ocXDvIxPue9PO+hXwLjmfYCLisk5mxg1mJZbijERD
	Leai4kQAbZEoqfMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd0zfUrBBiuvKlrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo2f3BbaCLrWK
	Dy+5Ghi3yncxcnBICJhI/H1o1cXICWSKSVy4t56ti5GLQ0hgOqPEttMHGSGcyUwSm9ZOYANp
	YBFQlTjwix2kgU1AS2L13ONgNSICbUwSXxsPsYA4zAJzmSU+fpvDBlIlLOAi8fzYAUYQm1fA
	UeLugv3MEOssJC40dbBDxAUlfky+xwJiMwNN3bytiRXClpfYvOYt8wRGvllIymYhKZuFpGwB
	I/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODE8ExqB+PKBotDjAIcjEo8vA6HFYOFWBPL
	iitzDzFKcDArifBWRSgFC/GmJFZWpRblxxeV5qQWH2JMBnp7IrOUaHI+MGnllcQbGpuYGVka
	mVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjbVvlW6Z1H1oWMBu65TZFq39X
	T9bOnOR1O1z80YkFIf/2S5XICljuL4/cszHze6KmDGOeVVHMGY7zp3/bCKwNZHvjvj3dTnqh
	SlzizqcfH1me1WQJcZ7MKc7p6jHZ5+GEr3OMyox+aOo6JkToRmswyx7METbo/rBWapmJ9GfD
	8vKwtzcrW5VYijMSDbWYi4oTAXA59v5QAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes custom fault handler. The device drivers that
need to register fault handler can register
with iommu_set_fault_handler().

CC: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   80 +++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index cef62d0..3458349 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -136,16 +136,6 @@ enum exynos_sysmmu_inttype {
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
@@ -187,7 +177,6 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
-	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
 };
 
@@ -256,34 +245,17 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
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
@@ -292,12 +264,6 @@ static int default_fault_handler(enum exynos_sysmmu_inttype itype,
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
@@ -320,24 +286,28 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
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
 
 	__master_clk_disable(data);
 
@@ -583,8 +553,6 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	rwlock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
-	__set_fault_handler(data, &default_fault_handler);
-
 	platform_set_drvdata(pdev, data);
 
 	pm_runtime_enable(dev);
-- 
1.7.9.5

