Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaD0HlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31178 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaD0Hjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:36 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-cc-535cb4374b08
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
Subject: [PATCH v12 17/31] iommu/exynos: add support for power management
 subsystems.
Date: Sun, 27 Apr 2014 13:07:49 +0530
Message-id: <1398584283-22846-18-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkVtd8S0ywweLl3BZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bi6xOY
	CvYHV8xvXsrWwDjNpYuRk0NCwETi+bl9bBC2mMSFe+vBbCGBpYwSt57odzFygNVM+FzWxcgF
	FF7EKPH3Qw8jhDOBSeJn1xuwBjYBQ4nt966wgiREBFYzSvRdPMMO4jAL3GWSmLPqHSNIlbBA
	uERz4zVGkLEsAqoSt06Gg4R5BTwktv58wg6xTUFiziQbkDAnUPjJnT0sEAe5S7w99QVsvoTA
	TA6Jzs89YCNZBAQkvk0+xALRKyux6QAzxDOSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGhXnFi
	bnFpXrpecn7uJkZgLJ7+96x3B+PtA9aHGJOBxk1klhJNzgfGcl5JvKGxmZGFqYmpsZG5pRlp
	wkrivEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MHaJrXy3yL/lmaf7E8GlpldWy8zM
	zHpUsviF/GEOybXLOxtPKQm6bJvb+u/SzPDtrn8/+f3ZbOriKLZkUq2yz7aH5wMdJ97Ozz4q
	WtFXzXqqRNrtDsOkiA3Pu5dffMPOcO5YCOOOc6zHpJPvTDsm/H7tR1FNX/2N0es6D2T7ik1/
	XnB+gWSUbqsSS3FGoqEWc1FxIgDvdN/S2wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV2zLTHBBp/3WVvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzFl+fwFSwP7hifvNStgbGaS5djBwcEgImEhM+l3UxcgKZYhIX
	7q1n62Lk4hASWMQo8fdDDyOEM4FJ4mfXGzaQKjYBQ4nt966wgiREBFYzSvRdPMMO4jAL3GWS
	mLPqHSNIlbBAuERz4zVGkBUsAqoSt06Gg4R5BTwktv58wg6xWUFiziQbkDAnUPjJnT0sILaQ
	gLvE21NfWCcw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzrz6R2MK5ssDjEKMDB
	qMTDu0AyJliINbGsuDL3EKMEB7OSCC/ndKAQb0piZVVqUX58UWlOavEhxmSgmyYyS4km5wPT
	UF5JvKGxibmpsamliYWJmSVpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MF5wOHq1OJx9
	LYNj9iObJSLNq4KN5zn/Utkk9DTCQ0kvnvvRhJkCMewdL15wzb9kNzHDZbODf/38yUwaOp5Z
	exp5I133zptUMUeBny1BUFp7tfK+qs2Bm2vaZli8YJnSefWI8oaiOR43/iZuKXi5Y1GF6Lzs
	rW0P/8d0bm6W8Gb2uHHtYaybmBJLcUaioRZzUXEiAPQp21A5AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

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
 drivers/iommu/exynos-iommu.c |  216 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 198 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 810bcaf..fefedec3 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -27,6 +27,7 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/pm_domain.h>
 #include <linux/notifier.h>
 
 #include <asm/cacheflush.h>
@@ -192,6 +193,7 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
+	bool powered_on;
 	unsigned long pgtable;
 };
 
@@ -381,7 +383,8 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 		data->pgtable = 0;
 		data->domain = NULL;
 
-		__sysmmu_disable_nocount(data);
+		if (data->powered_on)
+			__sysmmu_disable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Disabled\n");
 	} else  {
@@ -444,7 +447,8 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 		data->pgtable = pgtable;
 		data->domain = domain;
 
-		__sysmmu_enable_nocount(data);
+		if (data->powered_on)
+			__sysmmu_enable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Enabled\n");
 	} else {
@@ -529,14 +533,12 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 	data = dev_get_drvdata(owner->sysmmu);
 
 	read_lock_irqsave(&data->lock, flags);
-	if (is_sysmmu_active(data)) {
-		unsigned int maj;
+	if (is_sysmmu_active(data) && data->powered_on) {
 		unsigned int num_inv = 1;
 
 		if (!IS_ERR(data->clk_master))
 			clk_enable(data->clk_master);
 
-		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
 		/*
 		 * L2TLB invalidation required
 		 * 4KB page: 1 invalidation
@@ -547,7 +549,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 		 * 1MB page can be cached in one of all sets.
 		 * 64KB page can be one of 16 consecutive sets.
 		 */
-		if ((maj >> 28) == 2) /* major version number */
+		if (__sysmmu_version(data, NULL) == 2) /* major version number */
 			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
 
 		if (sysmmu_block(data->sfrbase)) {
@@ -573,7 +575,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	data = dev_get_drvdata(owner->sysmmu);
 
 	read_lock_irqsave(&data->lock, flags);
-	if (is_sysmmu_active(data)) {
+	if (is_sysmmu_active(data) && data->powered_on) {
 		if (!IS_ERR(data->clk_master))
 			clk_enable(data->clk_master);
 		if (sysmmu_block(data->sfrbase)) {
@@ -672,6 +674,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, data);
 
 	pm_runtime_enable(dev);
+	data->powered_on = !pm_runtime_enabled(dev);
 
 	ret = exynos_iommu_prepare();
 	if (ret)
@@ -680,6 +683,34 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int sysmmu_suspend(struct device *dev)
+{
+	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
+	unsigned long flags;
+	read_lock_irqsave(&data->lock, flags);
+	if (is_sysmmu_active(data) &&
+		(!pm_runtime_enabled(dev) || data->powered_on))
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
+		(!pm_runtime_enabled(dev) || data->powered_on))
+		__sysmmu_enable_nocount(data);
+	read_unlock_irqrestore(&data->lock, flags);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(sysmmu_pm_ops, sysmmu_suspend, sysmmu_resume);
+
 static const struct of_device_id sysmmu_of_match[] __initconst = {
 	{ .compatible	= "samsung,sysmmu-v1", },
 	{ .compatible	= "samsung,sysmmu-v2", },
@@ -694,6 +725,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.driver	= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.pm		= &sysmmu_pm_ops,
 		.of_match_table	= sysmmu_of_match,
 	}
 };
@@ -1110,24 +1142,150 @@ err_reg_driver:
 }
 subsys_initcall(exynos_iommu_init);
 
+#ifdef CONFIG_PM_SLEEP
+static int sysmmu_pm_genpd_suspend(struct device *dev)
+{
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	int ret;
+
+	ret = pm_generic_suspend(dev);
+	if (ret)
+		return ret;
+
+	return pm_generic_suspend(owner->sysmmu);
+}
+
+static int sysmmu_pm_genpd_resume(struct device *dev)
+{
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	int ret;
+
+	ret = pm_generic_resume(owner->sysmmu);
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
+	data->powered_on = true;
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
+	data->powered_on = false;
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
+
 static int sysmmu_hook_driver_register(struct notifier_block *nb,
 					unsigned long val,
 					void *p)
 {
 	struct device *dev = p;
 
+	/*
+	 * No System MMU assigned even though in the initial state.
+	 * See exynos_sysmmu_probe().
+	 */
+	if (dev->archdata.iommu == NULL)
+		return 0;
+
 	switch (val) {
 	case BUS_NOTIFY_BIND_DRIVER:
 	{
 		struct exynos_iommu_owner *owner;
+		int ret;
 
-		/* No System MMU assigned. See exynos_sysmmu_probe(). */
-		if (dev->archdata.iommu == NULL)
-			break;
+		BUG_ON(!dev_get_drvdata(dev->archdata.iommu));
 
 		owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
 		if (!owner) {
 			dev_err(dev, "No Memory for exynos_iommu_owner\n");
+			dev->archdata.iommu = NULL;
 			return -ENOMEM;
 		}
 
@@ -1135,22 +1293,44 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
 		INIT_LIST_HEAD(&owner->client);
 		owner->sysmmu = dev->archdata.iommu;
 
+		ret = pm_genpd_add_callbacks(dev, &sysmmu_devpm_ops, NULL);
+		if (ret && (ret != -ENOSYS)) {
+			dev_err(dev,
+				"Failed to register 'dev_pm_ops' for iommu\n");
+			devm_kfree(dev, owner);
+			dev->archdata.iommu = NULL;
+			return ret;
+		}
+
 		dev->archdata.iommu = owner;
 		break;
 	}
-	case BUS_NOTIFY_UNBOUND_DRIVER:
+	case BUS_NOTIFY_BOUND_DRIVER:
 	{
 		struct exynos_iommu_owner *owner = dev->archdata.iommu;
-		if (owner) {
-			struct device *sysmmu = owner->sysmmu;
-			/* if still attached to an iommu_domain. */
-			if (WARN_ON(!list_empty(&owner->client)))
-				iommu_detach_device(owner->domain, owner->dev);
-			devm_kfree(dev, owner);
-			dev->archdata.iommu = sysmmu;
+		if (!pm_runtime_enabled(dev)) {
+			struct sysmmu_drvdata *data =
+					dev_get_drvdata(owner->sysmmu);
+			if (pm_runtime_enabled(data->sysmmu)) {
+				data->powered_on = true;
+				if (is_sysmmu_active(data))
+					__sysmmu_enable_nocount(data);
+				pm_runtime_disable(data->sysmmu);
+			}
 		}
 		break;
 	}
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+	{
+		struct exynos_iommu_owner *owner = dev->archdata.iommu;
+		struct device *sysmmu = owner->sysmmu;
+		if (WARN_ON(!list_empty(&owner->client)))
+			iommu_detach_device(owner->domain, dev);
+		__pm_genpd_remove_callbacks(dev, false);
+		devm_kfree(dev, owner);
+		dev->archdata.iommu = sysmmu;
+		break;
+	}
 	} /* switch (val) */
 
 	return 0;
-- 
1.7.9.5

