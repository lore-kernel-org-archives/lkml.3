Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaELGTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:19:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34182 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaELGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:53 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-32-537067530e2e
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
Subject: [PATCH v13 11/19] iommu/exynos: remove custom fault handler
Date: Mon, 12 May 2014 11:44:56 +0530
Message-id: <1399875304-19948-12-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkWjc4vSDYYMZiI4s7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6MGUt3sBZ0qlc83d7I2sC4VqGLkYNDQsBE4vVPpS5GTiBTTOLCvfVsXYxc
	HEICSxklps57xgaRMJH4efAwO0RiEaNE846ZzBDOBCaJ8233mUCq2AQMJbbfu8IKkhARWM0o
	0XfxDFgLs8BsZokjjxYzglQJC7hITG7YCtbBIqAqcW7bLHYQm1fAQ2LN+Y/MEDcpSMyZZAMS
	5gQKf149BewMIQF3iWOvroItkBDYwiHxfFETO8QcAYlvkw+xQPTKSmw6wAxxtqTEwRU3WCYw
	Ci9gZFjFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERitp/89m7CD8d4B60OMyUDjJjJLiSbn
	A6M9ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	GT78U29w19jrNNHywDvZ2Cw/Hj4TxmdOLVEPZYRkOzc3KQf+ctKVdGxoLZSWEdo/bc0CUb8F
	DTnnj1rJePfF6AZmdSQ+vrx4emWD/KSwYJb0tE1Gey/p3eCwUHs0Y5rcFE7f+4HTez62uYbf
	0t4eEDqj+pVtuevspdsa9Daskn27sfvznlVKLMUZiYZazEXFiQBpDNED7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd3g9IJgg2WbVS3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZsxYuoO1oFO94un2RtYGxrUKXYyc
	HBICJhI/Dx5mh7DFJC7cW8/WxcjFISSwiFGiecdMZghnApPE+bb7TCBVbAKGEtvvXWEFSYgI
	rGaU6Lt4hh3EYRaYzSxx5NFiRpAqYQEXickNW8E6WARUJc5tmwW2g1fAQ2LN+Y9AYzmA9ilI
	zJlkAxLmBAp/Xj2FDcQWEnCXOPbqKusERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3
	MYKTwTPpHYyrGiwOMQpwMCrx8H5gKAgWYk0sK67MPcQowcGsJML70R8oxJuSWFmVWpQfX1Sa
	k1p8iDEZ6KiJzFKiyfnARJVXEm9obGJuamxqaWJhYmZJmrCSOO/BVutAIYH0xJLU7NTUgtQi
	mC1MHJxSDYwlsxZNLjETOLpL8ES7Xaf4xYtHC1OMpYV2JG++X8O6Llj7AOOGxS7pRRvj/A8/
	m73ae6psTeaKi9Un41Z229hJ5jYwmD+7eMw+d1FLw6mwoJ1PfDunB5euvR3/4eqhTRFhHTue
	Cta6Oe14/1uba7WL7vZdAuzrD8xlZq4WPfaq6vQnueXSvh5KLMUZiYZazEXFiQCtWaIwSgMA	AA==
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
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   80 +++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 5af5c5c..c1be65f 100644
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
-			phys_addr_t pgtable_base, unsigned long fault_addr);
-
 static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
 	REG_PAGE_FAULT_ADDR,
 	REG_AR_FAULT_ADDR,
@@ -176,7 +166,6 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
-	sysmmu_fault_handler_t fault_handler;
 	phys_addr_t pgtable;
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
-			phys_addr_t pgtable_base, unsigned long fault_addr)
+static void show_fault_information(const char *name,
+		enum exynos_sysmmu_inttype itype,
+		phys_addr_t pgtable_base, unsigned long fault_addr)
 {
 	unsigned long *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at 0x%lx(Page table base: %pa)\n",
-			sysmmu_fault_name[itype], fault_addr, &pgtable_base);
+	pr_err("%s occurred at %#lx by %s(Page table base: %pa)\n",
+		sysmmu_fault_name[itype], fault_addr, name, &pgtable_base);
 
 	ent = section_entry(phys_to_virt(pgtable_base), fault_addr);
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
@@ -576,8 +546,6 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	rwlock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
-	__set_fault_handler(data, &default_fault_handler);
-
 	platform_set_drvdata(pdev, data);
 
 	pm_runtime_enable(dev);
-- 
1.7.9.5

