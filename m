Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3JGByg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:54:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13385 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3JGByc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:54:32 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-64-5252145789c0
Date: Mon, 07 Oct 2013 10:54:30 +0900
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
Subject: [PATCH v10 07/20] iommu/exynos: always use a single clock descriptor
Message-id: <20131007105430.1783e044165cea7e41745b57@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zI91wkaAgg55GRYs7d8+xWsw/AiRe
	HfnBZLFgv7VF5+wN7Ba9C66yWWx6fI3V4vKuOWwWM87vY7K4sGIju8WURYdZLQ6/aWe1OPmn
	l9Gi5Xovk8X6Ga9ZLGbeWsPiIODx5OA8Jo/ZDRdZPP4d7mfyuHNtD5vH5iX1HpNvLGf06Nuy
	itHj8yY5jytHzzAFcEZx2aSk5mSWpRbp2yVwZZxc6F4wK6ji893tbA2Mixy7GDk5JARMJM7d
	/swGYYtJXLi3Hsjm4hASWMYo8WLpV1aYooamWWBFQgKLGCXe/C+DsCcxSSxar9/FyMHBIqAq
	8W4rD0iYTUBLYvXc44wgc0QE2pgkvjYeYgFxmAVOM0us2r2CGaRKWMBX4teOKWBDeQUcJe7d
	XMAEscxC4kJTBztEXFDix+R7LCA2M9DUzduaWCFseYnNa94ygwyVEOjlkHjc8AhsEIuAgMS3
	ySDbOIASshKbDjBDzJSUOLjiBssERpFZSMbOQjJ2FpKxCxiZVzGKphYkFxQnpRcZ6hUn5haX
	5qXrJefnbmKExHDvDsbbB6wPMSYDrZzILCWanA9MAXkl8YbGZkYWpiamxkbmlmakCSuJ86q1
	WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJxSGrab7dqpjw11jFMuiad0stdGq7VMmV8t
	/44nZKmH83LmJf+YPNyid3yZe2iilOGtaIs577gT1n/W2ZSxePJu/X+Xzs7M6GqwrDVdfL46
	yI75nJaUwo0UhpSZ/wW65955fXve3aJ515c56u9l2vPu1sca34Ayd94vhyyO1VX8YmM9t/bV
	9L1KLMUZiYZazEXFiQAH7zAQ9wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd1wkaAgg8NLpCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj5EL3
	gllBFZ/vbmdrYFzk2MXIySEhYCLR0DSLDcIWk7hwbz2YLSSwiFHizf8yCHsSk8Si9fpdjBwc
	LAKqEu+28oCE2QS0JFbPPc7YxcjFISLQxiTxtfEQC4jDLHCaWWLV7hXMIFXCAr4Sv3ZMARvK
	K+Aoce/mAiaIZRYSF5o62CHighI/Jt9jAbGZgaZu3tbECmHLS2xe85Z5AiPfLCRls5CUzUJS
	toCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcIJ4JrWDcWWDxSFGAQ5GJR7eHfcDg4RY
	E8uKK3MPMUpwMCuJ8F6qAwrxpiRWVqUW5ccXleakFh9iTAZ6eyKzlGhyPjB55ZXEGxqbmBlZ
	GplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD43GRa4IKhVzO5XLLEo4/dlr9
	L7Zpno+X/crAQ6lu3N+bdD6tYUzW+FovNmPDtH9ayocNrZXF5/zcaXJQ7FhC9/Jn6z1KG1Ka
	vHSks84cdIyp0ilqEzQ1WZXYVvTA/+UyjW8rNyR6bvn3+tS2/Rn3rfOvLgp6/+d4XNIesYye
	zdM+szbev53prsRSnJFoqMVcVJwIABg9KzhUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System MMU driver is changed to control only a single instance of
System MMU at a time. Since a single instance of System MMU has only
a single clock descriptor for its clock gating, there is no need to
obtain two or more clock descriptors.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  222 ++++++++++++++----------------------------
 1 files changed, 73 insertions(+), 149 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 20b032f..0092359 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -171,9 +171,8 @@ struct sysmmu_drvdata {
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *dev;	/* Owner of system MMU */
 	char *dbgname;
-	int nsfrs;
-	void __iomem **sfrbases;
-	struct clk *clk[2];
+	void __iomem *sfrbase;
+	struct clk *clk;
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
@@ -301,56 +300,39 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 {
 	/* SYSMMU is in blocked when interrupt occurred. */
 	struct sysmmu_drvdata *data = dev_id;
-	struct resource *irqres;
-	struct platform_device *pdev;
 	enum exynos_sysmmu_inttype itype;
 	unsigned long addr = -1;
-
-	int i, ret = -ENOSYS;
+	int ret = -ENOSYS;
 
 	read_lock(&data->lock);
 
 	WARN_ON(!is_sysmmu_active(data));
 
-	pdev = to_platform_device(data->sysmmu);
-	for (i = 0; i < (pdev->num_resources / 2); i++) {
-		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
-		if (irqres && ((int)irqres->start == irq))
-			break;
-	}
-
-	if (i == pdev->num_resources) {
+	itype = (enum exynos_sysmmu_inttype)
+		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
+	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
 		itype = SYSMMU_FAULT_UNKNOWN;
-	} else {
-		itype = (enum exynos_sysmmu_inttype)
-			__ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
-		if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
-			itype = SYSMMU_FAULT_UNKNOWN;
-		else
-			addr = __raw_readl(
-				data->sfrbases[i] + fault_reg_offset[itype]);
-	}
+	else
+		addr = __raw_readl(data->sfrbase + fault_reg_offset[itype]);
 
 	if (data->domain)
-		ret = report_iommu_fault(data->domain, data->dev,
-				addr, itype);
+		ret = report_iommu_fault(data->domain, data->dev, addr, itype);
 
 	if ((ret == -ENOSYS) && data->fault_handler) {
 		unsigned long base = data->pgtable;
 		if (itype != SYSMMU_FAULT_UNKNOWN)
-			base = __raw_readl(
-					data->sfrbases[i] + REG_PT_BASE_ADDR);
+			base = __raw_readl(data->sfrbase + REG_PT_BASE_ADDR);
 		ret = data->fault_handler(itype, base, addr);
 	}
 
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
-		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
+		__raw_writel(1 << itype, data->sfrbase + REG_INT_CLEAR);
 	else
 		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
 				data->dbgname, sysmmu_fault_name[itype]);
 
 	if (itype != SYSMMU_FAULT_UNKNOWN)
-		sysmmu_unblock(data->sfrbases[i]);
+		sysmmu_unblock(data->sfrbase);
 
 	read_unlock(&data->lock);
 
@@ -368,13 +350,10 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	if (!set_sysmmu_inactive(data))
 		goto finish;
 
-	for (i = 0; i < data->nsfrs; i++)
-		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
+	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
 
-	if (data->clk[1])
-		clk_disable(data->clk[1]);
-	if (data->clk[0])
-		clk_disable(data->clk[0]);
+	if (data->clk)
+		clk_disable(data->clk);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -417,27 +396,22 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		goto finish;
 	}
 
-	if (data->clk[0])
-		clk_enable(data->clk[0]);
-	if (data->clk[1])
-		clk_enable(data->clk[1]);
+	if (data->clk)
+		clk_enable(data->clk);
 
 	data->pgtable = pgtable;
 
-	for (i = 0; i < data->nsfrs; i++) {
-		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
-
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
-					data->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
-		}
+	__sysmmu_set_ptbase(data->sfrbase, pgtable);
 
-		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
+	if ((readl(data->sfrbase + REG_MMU_VERSION) >> 28) == 3) {
+		/* System MMU version is 3.x */
+		__raw_writel((1 << 12) | (2 << 28), data->sfrbase + REG_MMU_CFG);
+		__sysmmu_set_prefbuf(data->sfrbase, 0, -1, 0);
+		__sysmmu_set_prefbuf(data->sfrbase, 0, -1, 1);
 	}
 
+	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
+
 	data->domain = domain;
 
 	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
@@ -493,24 +467,22 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			unsigned int maj;
-			unsigned int num_inv = 1;
-			maj = __raw_readl(data->sfrbases[i] + REG_MMU_VERSION);
-			/*
-			 * L2TLB invalidation required
-			 * 4KB page: 1 invalidation
-			 * 64KB page: 16 invalidation
-			 * 1MB page: 64 invalidation
-			 */
-			if ((maj >> 28) == 2) /* major version number */
-				num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate_entry(
-					data->sfrbases[i], iova, num_inv);
-				sysmmu_unblock(data->sfrbases[i]);
-			}
+		unsigned int maj;
+		unsigned int num_inv = 1;
+		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
+		/*
+		 * L2TLB invalidation required
+		 * 4KB page: 1 invalidation
+		 * 64KB page: 16 invalidation
+		 * 1MB page: 64 invalidation
+		 */
+		if ((maj >> 28) == 2) /* major version number */
+			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
+
+		if (sysmmu_block(data->sfrbase)) {
+			__sysmmu_tlb_invalidate_entry(data->sfrbase, iova,
+							num_inv);
+			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
 		dev_dbg(data->sysmmu,
@@ -529,12 +501,9 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate(data->sfrbases[i]);
-				sysmmu_unblock(data->sfrbases[i]);
-			}
+		if (sysmmu_block(data->sfrbase)) {
+			__sysmmu_tlb_invalidate(data->sfrbase);
+			sysmmu_unblock(data->sfrbase);
 		}
 	} else {
 		dev_dbg(data->sysmmu,
@@ -547,11 +516,10 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 static int exynos_sysmmu_probe(struct platform_device *pdev)
 {
-	int i, ret;
-	struct device *dev;
+	int ret;
+	struct device *dev = &pdev->dev;
 	struct sysmmu_drvdata *data;
-
-	dev = &pdev->dev;
+	struct resource *res;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data) {
@@ -560,81 +528,42 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
-	ret = dev_set_drvdata(dev, data);
-	if (ret) {
-		dev_dbg(dev, "Unabled to initialize driver data\n");
-		goto err_init;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_dbg(dev, "Unable to find IOMEM region\n");
+		ret = -ENOENT;
+		goto err_res;
 	}
 
-	data->nsfrs = pdev->num_resources / 2;
-	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
-								GFP_KERNEL);
-	if (data->sfrbases == NULL) {
-		dev_dbg(dev, "Not enough memory\n");
-		ret = -ENOMEM;
-		goto err_init;
+	data->sfrbase = ioremap(res->start, resource_size(res));
+	if (!data->sfrbase) {
+		dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n", res->start);
+		ret = -ENOENT;
+		goto err_res;
 	}
 
-	for (i = 0; i < data->nsfrs; i++) {
-		struct resource *res;
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res) {
-			dev_dbg(dev, "Unable to find IOMEM region\n");
-			ret = -ENOENT;
-			goto err_res;
-		}
-
-		data->sfrbases[i] = ioremap(res->start, resource_size(res));
-		if (!data->sfrbases[i]) {
-			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
-							res->start);
-			ret = -ENOENT;
-			goto err_res;
-		}
+	ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
+		dev_dbg(dev, "Unable to find IRQ resource\n");
+		goto err_irq;
 	}
 
-	for (i = 0; i < data->nsfrs; i++) {
-		ret = platform_get_irq(pdev, i);
-		if (ret <= 0) {
-			dev_dbg(dev, "Unable to find IRQ resource\n");
-			goto err_irq;
-		}
-
-		ret = request_irq(ret, exynos_sysmmu_irq, 0,
-					dev_name(dev), data);
-		if (ret) {
-			dev_dbg(dev, "Unabled to register interrupt handler\n");
-			goto err_irq;
-		}
+	ret = request_irq(ret, exynos_sysmmu_irq, 0,
+				dev_name(dev), data);
+	if (ret) {
+		dev_dbg(dev, "Unabled to register interrupt handler\n");
+		goto err_irq;
 	}
 
 	if (dev_get_platdata(dev)) {
-		char *deli, *beg;
 		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
 
-		beg = platdata->clockname;
-
-		for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
-			/* NOTHING */;
-
-		if (*deli == '\0')
-			deli = NULL;
-		else
-			*deli = '\0';
-
-		data->clk[0] = clk_get(dev, beg);
-		if (IS_ERR(data->clk[0])) {
-			data->clk[0] = NULL;
+		data->clk = clk_get(dev, "sysmmu");
+		if (IS_ERR(data->clk)) {
+			data->clk = NULL;
 			dev_dbg(dev, "No clock descriptor registered\n");
 		}
 
-		if (data->clk[0] && deli) {
-			*deli = ',';
-			data->clk[1] = clk_get(dev, deli + 1);
-			if (IS_ERR(data->clk[1]))
-				data->clk[1] = NULL;
-		}
-
 		data->dbgname = platdata->dbgname;
 	}
 
@@ -644,21 +573,16 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	__set_fault_handler(data, &default_fault_handler);
 
+	platform_set_drvdata(pdev, data);
+
 	pm_runtime_enable(dev);
 
 	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
 	return 0;
 err_irq:
-	while (i-- > 0) {
-		int irq;
-
-		irq = platform_get_irq(pdev, i);
-		free_irq(irq, data);
-	}
+	free_irq(platform_get_irq(pdev, 0), data);
 err_res:
-	while (data->nsfrs-- > 0)
-		iounmap(data->sfrbases[data->nsfrs]);
-	kfree(data->sfrbases);
+	iounmap(data->sfrbase);
 err_init:
 	kfree(data);
 err_alloc:
-- 
1.7.2.5

