Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3JGB6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:58:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65476 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3JGB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:58:11 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-39-52521531ea5c
Date: Mon, 07 Oct 2013 10:58:09 +0900
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
Subject: [PATCH v10 17/20] iommu/exynos: add support for power management
 subsystems.
Message-id: <20131007105809.46d54d3b201ca56b663cc5fd@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zfV1D0aAgg3vfTCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlbFsTTdzwUP3iqVTlBsYF1h3MXJySAiYSEy5
	f4cJwhaTuHBvPVsXIxeHkMAyRomf/bPZYIratq5lhEgsYpTYdWAnlDOJSWLPoeOsIFUsAqoS
	W753M4PYbAJaEqvnHgcrEhFoY5L42niIBcRhFjjNLLFq9wqwKmGBcInt/x4wgti8Ao4Sm3pu
	M0Pss5C40NTBDhEXlPgx+R4LiM0MNHXztiZWCFteYvOat1D1Ezkk3nVXQFwhIPFtMsgyDqC4
	rMSmA1AlkhIHV9xgmcAoMgvJ1FlIps5CMnUBI/MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxN
	jJA47t/BePeA9SHGZKCVE5mlRJPzgWkgryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2Mzvufdc3j/7I2deX6d+yT8nO35sx+zfrl7+2ASTvLMlcH
	rz5k+yCLVdm6V2hV8TLOFhmRrWIbX7fWyItfnaU7u33h4skL2sXmfu5xUhAXuM4QGufI5zF7
	Nvs9Di+rOS9mx6Yr128PV+Cc4fa2p3/tlK2bNaNKN0rPOfHH9NqRiRcXZ3Jvqr2ap8RSnJFo
	qMVcVJwIAGt8Rrv5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAV1D0aAggx+d+hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6NFy/VeJov1M16zWMy8tYbFQcDjycF5TB6zGy6yePw73M/kcefaHjaPzUvqPSbfWM7o0bdl
	FaPH501yHleOnmEK4IxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAXpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ixbE03
	c8FD94qlU5QbGBdYdzFyckgImEi0bV3LCGGLSVy4t56ti5GLQ0hgEaPErgM7GSGcSUwSew4d
	ZwWpYhFQldjyvZsZxGYT0JJYPfc4WJGIQBuTxNfGQywgDrPAaWaJVbtXgFUJC4RLbP/3AGwH
	r4CjxKae28wQ+ywkLjR1sEPEBSV+TL7HAmIzA03dvK2JFcKWl9i85i3zBEa+WUjKZiEpm4Wk
	bAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4DTxTHoH46oGi0OMAhyMSjy8O+4HBgmx
	JpYVV+YeYpTgYFYS4b1UBxTiTUmsrEotyo8vKs1JLT7EmAz090RmKdHkfGAKyyuJNzQ2MTOy
	NDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxtRHbj17ZD4qsk6tfTmFeen5
	21nqgjKevU5S08/s/yDy6+P1kOgzTQf3bXjMzhb99Fq3yXIjz70aBStuGiTEGZ7+LFfsUR7z
	Qv3Jl9+zv79c3K225MXdubHJtW+/njw719CWc6b47YaYBb8Fpk98NOHGxk+7tJIZhR73PRPm
	jPV03Xr9oMzxxFNKLMUZiYZazEXFiQAXbqNVVwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for Suspend to RAM and Runtime Power Management.

Since System MMU is located in the same local power domain of its
master H/W, System MMU must be initialized before it is working if
its power domain was ever turned off. TLB invalidation according to
unmapping on page tables must also be performed while power domain is
turned on.

This patch ensures that resume and runtime_resume(restore_state)
functions in this driver is called before the calls to resume and
runtime_resume callback functions in the drivers of master H/Ws.
Likewise, suspend and runtime_suspend(save_state) functions in this
driver is called after the calls to suspend and runtime_suspend in the
drivers of master H/Ws.

In order to get benefit of this support, the master H/W and its System
MMU must resides in the same power domain in terms of Linux kernel. If
a master H/W does not use generic I/O power domain, its driver must
call iommu_attach_device() after its local power domain is turned on,
iommu_detach_device before turned off.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  190 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 186 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 03031dc..e48c2fb 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/pm_domain.h>
 #include <linux/notifier.h>
 
 #include <asm/cacheflush.h>
@@ -184,6 +185,7 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
+	bool runtime_active;
 	unsigned long pgtable;
 };
 
@@ -362,7 +364,8 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 		data->pgtable = 0;
 		data->domain = NULL;
 
-		__sysmmu_disable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_disable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Disabled\n");
 	} else  {
@@ -423,7 +426,8 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 		data->pgtable = pgtable;
 		data->domain = domain;
 
-		__sysmmu_enable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_enable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Enabled\n");
 	} else {
@@ -500,7 +504,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 	data = dev_get_drvdata(client->sysmmu);
 
 	read_lock_irqsave(&data->lock, flags);
-	if (is_sysmmu_active(data)) {
+	if (is_sysmmu_active(data) && data->runtime_active) {
 		unsigned int num_inv = 1;
 		/*
 		 * L2TLB invalidation required
@@ -534,7 +538,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	data = dev_get_drvdata(client->sysmmu);
 
 	read_lock_irqsave(&data->lock, flags);
-	if (is_sysmmu_active(data)) {
+	if (is_sysmmu_active(data) && data->runtime_active) {
 		clk_enable(data->clk_master);
 		if (sysmmu_block(data->sfrbase)) {
 			__sysmmu_tlb_invalidate(data->sfrbase);
@@ -610,11 +614,40 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, data);
 
 	pm_runtime_enable(dev);
+	data->runtime_active = !pm_runtime_enabled(dev);
 
 	dev_dbg(dev, "Probed and initialized\n");
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int sysmmu_suspend(struct device *dev)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
+	unsigned long flags;
+	read_lock_irqsave(&data->lock, flags);
+	if (is_sysmmu_active(data) &&
+		(!pm_runtime_enabled(dev) || data->runtime_active))
+		__sysmmu_disable_nocount(data);
+	read_unlock_irqrestore(&data->lock, flags);
+	return 0;
+}
+
+static int sysmmu_resume(struct device *dev)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
+	unsigned long flags;
+	read_lock_irqsave(&data->lock, flags);
+	if (is_sysmmu_active(data) &&
+		(!pm_runtime_enabled(dev) || data->runtime_active))
+		__sysmmu_enable_nocount(data);
+	read_unlock_irqrestore(&data->lock, flags);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(sysmmu_pm_ops, sysmmu_suspend, sysmmu_resume);
+
 #ifdef CONFIG_OF
 static struct of_device_id sysmmu_of_match[] __initconst = {
 	{ .compatible	= "samsung,exynos4210-sysmmu", },
@@ -627,6 +660,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.driver	= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.pm		= &sysmmu_pm_ops,
 		.of_match_table	= of_match_ptr(sysmmu_of_match),
 	}
 };
@@ -1036,6 +1070,127 @@ err_reg_driver:
 }
 subsys_initcall(exynos_iommu_init);
 
+#ifdef CONFIG_PM_SLEEP
+static int sysmmu_pm_genpd_suspend(struct device *dev)
+{
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	int ret;
+
+	ret = pm_generic_suspend(client->sysmmu);
+	if (ret)
+		return ret;
+
+	return pm_generic_suspend(dev);
+}
+
+static int sysmmu_pm_genpd_resume(struct device *dev)
+{
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	int ret;
+
+	ret = pm_generic_resume(client->sysmmu);
+	if (ret)
+		return ret;
+
+	return pm_generic_resume(dev);
+}
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+static void sysmmu_restore_state(struct device *sysmmu)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->runtime_active = true;
+	if (is_sysmmu_active(data))
+		__sysmmu_enable_nocount(data);
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static void sysmmu_save_state(struct device *sysmmu)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	if (is_sysmmu_active(data))
+		__sysmmu_disable_nocount(data);
+	data->runtime_active = false;
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static int sysmmu_pm_genpd_save_state(struct device *dev)
+{
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	int (*cb)(struct device *__dev);
+	int ret = 0;
+
+	if (dev->type && dev->type->pm)
+		cb = dev->type->pm->runtime_suspend;
+	else if (dev->class && dev->class->pm)
+		cb = dev->class->pm->runtime_suspend;
+	else if (dev->bus && dev->bus->pm)
+		cb = dev->bus->pm->runtime_suspend;
+	else
+		cb = NULL;
+
+	if (!cb && dev->driver && dev->driver->pm)
+		cb = dev->driver->pm->runtime_suspend;
+
+	if (cb)
+		ret = cb(dev);
+
+	if (ret == 0)
+		sysmmu_save_state(client->sysmmu);
+
+	return ret;
+}
+
+static int sysmmu_pm_genpd_restore_state(struct device *dev)
+{
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	int (*cb)(struct device *__dev);
+	int ret = 0;
+
+	if (dev->type && dev->type->pm)
+		cb = dev->type->pm->runtime_resume;
+	else if (dev->class && dev->class->pm)
+		cb = dev->class->pm->runtime_resume;
+	else if (dev->bus && dev->bus->pm)
+		cb = dev->bus->pm->runtime_resume;
+	else
+		cb = NULL;
+
+	if (!cb && dev->driver && dev->driver->pm)
+		cb = dev->driver->pm->runtime_resume;
+
+	sysmmu_restore_state(client->sysmmu);
+
+	if (cb)
+		ret = cb(dev);
+
+	if (ret)
+		sysmmu_save_state(client->sysmmu);
+
+	return ret;
+}
+#endif
+
+#ifdef CONFIG_PM_GENERIC_DOMAINS
+struct gpd_dev_ops sysmmu_devpm_ops = {
+#ifdef CONFIG_PM_RUNTIME
+	.save_state = &sysmmu_pm_genpd_save_state,
+	.restore_state = &sysmmu_pm_genpd_restore_state,
+#endif
+#ifdef CONFIG_PM_SLEEP
+	.suspend = &sysmmu_pm_genpd_suspend,
+	.resume = &sysmmu_pm_genpd_resume,
+#endif
+};
+#endif /* CONFIG_PM_GENERIC_DOMAINS */
+
 static int sysmmu_hook_driver_register(struct notifier_block *nb,
 					unsigned long val,
 					void *p)
@@ -1048,6 +1203,7 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
 		struct exynos_iommu_client *client;
 		struct device_node *np;
 		struct platform_device *sysmmu;
+		int ret;
 
 		np = of_parse_phandle(dev->of_node, "iommu", 0);
 		if (!np)
@@ -1071,12 +1227,38 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
 
 		client->sysmmu = &sysmmu->dev;
 
+		ret = pm_genpd_add_callbacks(dev, &sysmmu_devpm_ops, NULL);
+		if (ret && (ret != -ENOSYS)) {
+			dev_err(dev,
+				"Failed to register 'dev_pm_ops' for iommu\n");
+			devm_kfree(dev, client);
+			return ret;
+		}
+
 		dev->archdata.iommu = client;
 		break;
 	}
+	case BUS_NOTIFY_BOUND_DRIVER:
+	{
+		struct exynos_iommu_client *client = dev->archdata.iommu;
+		if ((client != NULL) &&
+		    (!pm_runtime_enabled(dev) || IS_ERR(dev_to_genpd(dev)))) {
+			struct sysmmu_drvdata *data;
+			data = dev_get_drvdata(client->sysmmu);
+			if (!data)
+				break;
+			pm_runtime_disable(client->sysmmu);
+			data->runtime_active = !pm_runtime_enabled(data->sysmmu);
+			if (data->runtime_active && is_sysmmu_active(data))
+				__sysmmu_enable_nocount(data);
+		}
+		break;
+	}
 	case BUS_NOTIFY_UNBOUND_DRIVER:
 	{
 		if (dev->archdata.iommu) {
+			__pm_genpd_remove_callbacks(dev, false);
+
 			devm_kfree(dev, dev->archdata.iommu);
 			dev->archdata.iommu = NULL;
 		}
-- 
1.7.2.5

