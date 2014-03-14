Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaCNFLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:11:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57710 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaCNFLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:11:43 -0400
X-AuditID: cbfee68f-b7f156d00000276c-eb-53228f8db11c
Date: Fri, 14 Mar 2014 14:11:40 +0900
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
Subject: [PATCH v11 21/27] iommu/exynos: change rwlock to spinlock
Message-id: <20140314141140.8c05452abfa2375b739845d6@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zY93efqVgg0n9+hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGXs+byKseCXTsW6znNsDYzzVbsYOTkkBEwkJh97wARh
	i0lcuLeeDcQWEljGKPFgQQxMzefDz1gg4tMZJdoOAMW5gOzJTBLbpzWCNbMIqEq0nesAs9kE
	tCRWzz3OCFIkItDGJPG18RALiMMsMJdZ4uO3OWArhAWcJI59WccIYvMKOEpc/rqYGWKdhcSF
	pg52iLigxI/J98BWMwNN3bytiRXClpfYvOYtM8hQCYFODokpt4+zQJwhIPFtMsg2DqCErMSm
	A1AzJSUOrrjBMoFRZBaSsbOQjJ2FZOwCRuZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCHR
	27+D8e4B60OMyUArJzJLiSbnA6M/ryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+TgoQE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwLthTNe/rVR4btu2CqokPTpf93nzg8bQp057KZjVWFNme0Fyc
	7MgkzX7qcYLF9kdCtts160zMxB58nzB7k/OGORUVE7YsZbq2pWX3zVeOnkIR35V3/nZ9KvC7
	cefk9IWhX9xO/dQ/XSpbU73CfXW2gf9yp5aezKifsd85HXw4Xq1hm5rKNfWdqhJLcUaioRZz
	UXEiAPo2OQP0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQd3efqVggylNmhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gB9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2PN5FWPBL52K
	dZ3n2BoY56t2MXJySAiYSHw+/IwFwhaTuHBvPRuILSQwnVGi7UBMFyMXkD2ZSWL7tEYmkASL
	gKpE27kOMJtNQEti9dzjjCBFIgJtTBJfGw+xgDjMAnOZJT5+mwM2SljASeLYl3WMIDavgKPE
	5a+LmSHWWUhcaOpgh4gLSvyYfA/sDGagqZu3NbFC2PISm9e8ZZ7AyDcLSdksJGWzkJQtYGRe
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcHJ5J7WBc2WBxiFGAg1GJh9fhsGKwEGtiWXFl
	7iFGCQ5mJRHeqgilYCHelMTKqtSi/Pii0pzU4kOMyUB/T2SWEk3OByauvJJ4Q2MTMyNLIzML
	IxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgXOSR0R/e5anSsUlrmpXOUrWbPC/W
	cFzr4c90Y9SwfquiZsoWJ6+l4Wyl5z+5L3Fejesx+3MVf1/rTInaffc3a8KS6nkZ9levTX4k
	4WfUe3k39/fTzx1OLSl92mD6OmqX8P+/H2zO3RTabOdacJMvSI9p1iu2W+ELblT9ZTQSCLK4
	WMzkce2zEktxRqKhFnNRcSIAHFzLalIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since acquiring read_lock is not more frequent than write_lock, it is
not beneficial to use rwlock, this commit changes rwlock to spinlock.

Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7489343..543ea2e0 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -211,7 +211,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	struct clk *clk_master;
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	bool runtime_active;
 	bool suspended;
@@ -334,11 +334,12 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	unsigned long addr = -1;
 	int ret = -ENOSYS;
 
-	read_lock(&data->lock);
-
 	WARN_ON(!is_sysmmu_active(data));
 
+	spin_lock(&data->lock);
+
 	__master_clk_enable(data);
+
 	itype = (enum exynos_sysmmu_inttype)
 		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
 	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -371,7 +372,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	__master_clk_disable(data);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 
 	return IRQ_HANDLED;
 }
@@ -392,7 +393,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	disabled = set_sysmmu_inactive(data);
 
@@ -409,7 +410,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 					data->activations);
 	}
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return disabled;
 }
@@ -457,7 +458,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	int ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (set_sysmmu_active(data)) {
 		data->pgtable = pgtable;
 		data->domain = domain;
@@ -475,7 +476,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	if (WARN_ON(ret < 0))
 		set_sysmmu_inactive(data); /* decrement count */
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -562,7 +563,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
-		read_lock(&data->lock);
+		spin_lock(&data->lock);
 		if (is_sysmmu_active(data) && data->runtime_active) {
 			unsigned int num_inv = 1;
 
@@ -594,7 +595,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 				iova);
 		}
 
-		read_unlock(&data->lock);
+		spin_unlock(&data->lock);
 	}
 
 	spin_unlock_irqrestore(&owner->lock, flags);
@@ -610,7 +611,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
-		read_lock(&data->lock);
+		spin_lock(&data->lock);
 		if (is_sysmmu_active(data) && data->runtime_active) {
 			__master_clk_enable(data);
 			if (sysmmu_block(data->sfrbase)) {
@@ -621,7 +622,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		} else {
 			dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 		}
-		read_unlock(&data->lock);
+		spin_unlock(&data->lock);
 	}
 
 	spin_unlock_irqrestore(&owner->lock, flags);
@@ -819,7 +820,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	if (!ret) {
 		data->runtime_active = !pm_runtime_enabled(dev);
 		data->sysmmu = dev;
-		rwlock_init(&data->lock);
+		spin_lock_init(&data->lock);
 
 		platform_set_drvdata(pdev, data);
 	}
@@ -1269,12 +1270,12 @@ static int sysmmu_pm_genpd_suspend(struct device *dev)
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
 		unsigned long flags;
-		write_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (!data->suspended && is_sysmmu_active(data) &&
 			(!pm_runtime_enabled(dev) || data->runtime_active))
 			__sysmmu_disable_nocount(data);
 		data->suspended = true;
-		write_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 
 	return 0;
@@ -1288,12 +1289,12 @@ static int sysmmu_pm_genpd_resume(struct device *dev)
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
 		unsigned long flags;
-		write_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (data->suspended && is_sysmmu_active(data) &&
 			(!pm_runtime_enabled(dev) || data->runtime_active))
 			__sysmmu_enable_nocount(data);
 		data->suspended = false;
-		write_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 
 	return pm_generic_resume(dev);
@@ -1448,12 +1449,12 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
 					dev_get_drvdata(list->sysmmu);
 			unsigned long flags;
 
-			write_lock_irqsave(&data->lock, flags);
+			spin_lock_irqsave(&data->lock, flags);
 			if (is_sysmmu_active(data) && !data->runtime_active)
 				__sysmmu_enable_nocount(data);
 			data->runtime_active = true;
 			pm_runtime_disable(data->sysmmu);
-			write_unlock_irqrestore(&data->lock, flags);
+			spin_unlock_irqrestore(&data->lock, flags);
 		}
 
 		break;
-- 
1.7.9.5

