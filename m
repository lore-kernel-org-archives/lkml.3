Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaCNFLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:11:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52051 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaCNFK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:10:59 -0400
X-AuditID: cbfee68e-b7f566d000002344-d7-53228f455cd7
Date: Fri, 14 Mar 2014 14:10:28 +0900
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
Subject: [PATCH v11 19/27] iommu/exynos: add support for power management
 subsystems.
Message-id: <20140314141028.4b0b62d895905988ab5dda88@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ13XfqVgg64pQhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGVsOdHCUvA8pGL6/euMDYwHXLsYOTkkBEwkvlybxg5h
	i0lcuLeeDcQWEljGKPGqQRamZuWCmUA1XEDxRYwSXw88Y4VwJjNJNJ/axwpSxSKgKnH6xkxm
	EJtNQEti9dzjjCBFIgJtTBJfGw+xgDjMAnOZJT5+mwO2Q1ggXOL40rVANgcHr4CjxNsFkRDr
	LCQuNHWAncQrICjxY/I9FhCbGWjo5m1NrBC2vMTmNW+ZQWZKCEzkkLjeswHqCgGJb5NBlnEA
	JWQlNh1ghpgpKXFwxQ2WCYwis5CMnYVk7CwkYxcwMq9iFE0tSC4oTkovMtIrTswtLs1L10vO
	z93ECInevh2MNw9YH2JMBlo5kVlKNDkfGP15JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoFxup591pcnBkXXpKa1nWw5xcZyYdt/+fcXpsZfEjsg
	HWfJ9oXf+vZ3zZvPf79gi7vGe3LFjVOaG1lnXJZs5zvvoHhg+8mP31je8fKYvL59KOOUppt5
	spiXzxVvf4kTBxbNizBcqXtau8w/USniS8DxVcrH7lyr2mWSPiV9zpS+0OgG2+t6tuwpSizF
	GYmGWsxFxYkAiQ+/zvQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV3XfqVgg5lHuC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYseVEC0vB85CK
	6fevMzYwHnDtYuTkkBAwkVi5YCY7hC0mceHeerYuRi4OIYFFjBJfDzxjhXAmM0k0n9rHClLF
	IqAqcfrGTGYQm01AS2L13OOMIEUiAm1MEl8bD7GAOMwCc5klPn6bwwZSJSwQLnF86Vogm4OD
	V8BR4u2CSIh1FhIXmjrAVvMKCEr8mHyPBcRmBhq6eVsTK4QtL7F5zVvmCYx8s5CUzUJSNgtJ
	2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwcnhmfQOxlUNFocYBTgYlXh4ZxxVDBZi
	TSwrrsw9xCjBwawkwlsVoRQsxJuSWFmVWpQfX1Sak1p8iDEZ6O2JzFKiyfnAxJVXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxND+OD/rc6NOn/SO/8VeBh
	uPGi/+oXG0MCQydln76xjufeN82vf/uDsqOCbY//+Lzsr/H6mTvfv1R58W96nqxC7fdiqSMi
	YXe15ton/f9Xwhx0u7T7gfbm1a/3mDxvq1fgWptsaiQo36Cr0Wz+wEvS4YtRVtT0GzIPnl/c
	uUNdetr2/UfKr2oosRRnJBpqMRcVJwIA2iewhlIDAAA=
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
 drivers/iommu/exynos-iommu.c |  220 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 201 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 9037da0..84ba29a 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/pm_domain.h>
 #include <linux/notifier.h>
 
 #include <asm/cacheflush.h>
@@ -203,6 +204,7 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
+	bool runtime_active;
 	unsigned long pgtable;
 };
 
@@ -388,7 +390,8 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 		data->pgtable = 0;
 		data->domain = NULL;
 
-		__sysmmu_disable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_disable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Disabled\n");
 	} else  {
@@ -449,7 +452,8 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 		data->pgtable = pgtable;
 		data->domain = domain;
 
-		__sysmmu_enable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_enable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Enabled\n");
 	} else {
@@ -534,13 +538,11 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 	data = dev_get_drvdata(owner->sysmmu);
 
 	read_lock_irqsave(&data->lock, flags);
-	if (is_sysmmu_active(data)) {
-		unsigned int maj;
+	if (is_sysmmu_active(data) && data->runtime_active) {
 		unsigned int num_inv = 1;
 
 		__master_clk_enable(data);
 
-		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
 		/*
 		 * L2TLB invalidation required
 		 * 4KB page: 1 invalidation
@@ -551,7 +553,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 		 * 1MB page can be cached in one of all sets.
 		 * 64KB page can be one of 16 consecutive sets.
 		 */
-		if ((maj >> 28) == 2) /* major version number */
+		if (__sysmmu_version(data, NULL) == 2) /* major version number */
 			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
 
 		if (sysmmu_block(data->sfrbase)) {
@@ -576,7 +578,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	data = dev_get_drvdata(owner->sysmmu);
 
 	read_lock_irqsave(&data->lock, flags);
-	if (is_sysmmu_active(data)) {
+	if (is_sysmmu_active(data) && data->runtime_active) {
 		__master_clk_enable(data);
 		if (sysmmu_block(data->sfrbase)) {
 			__sysmmu_tlb_invalidate(data->sfrbase);
@@ -677,11 +679,40 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
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
 	{ .compatible	= "samsung,sysmmu-v1", },
@@ -698,6 +729,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.driver	= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.pm		= &sysmmu_pm_ops,
 		.of_match_table	= of_match_ptr(sysmmu_of_match),
 	}
 };
@@ -1111,24 +1143,152 @@ err_reg_driver:
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
 
@@ -1136,22 +1296,44 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
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
+				data->runtime_active = true;
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
@@ -1165,4 +1347,4 @@ static int __init exynos_iommu_prepare(void)
 {
 	return bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
 }
-arch_initcall(exynos_iommu_prepare);
+subsys_initcall_sync(exynos_iommu_prepare);
-- 
1.7.9.5

