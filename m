Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932Ab3HHJlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:41:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50866 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab3HHJlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:41:19 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-bf-520367bdaf96
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 14/16] iommu/exynos: add support for power management
 subsystems.
Date: Thu, 08 Aug 2013 18:41:17 +0900
Message-id: <003201ce941b$6e5a90e0$4b0fb2a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF7ynEN2W3cdIQLO38uml+XLTKw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zoe7edOYgg1XTrCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUVw2Kak5mWWpRfp2CVwZz16+ZCl45Vuxfs1BtgbGNvsuRk4OCQETiXWnfrJD2GISF+6t
	Z+ti5OIQEljGKHH+Xi8bTNHepV+YQGwhgemMEieep0IU/WWUOL71BwtIgk1AS2L13OOMIAkR
	gd+MEreezWEFcZgF/jNJbL3dBLZDWCBMYuK/eUCjODhYBFQl/rwFO4NXwFLi557XTBC2oMSP
	yffAhjIDDV2/8zgThC0vsXnNW2aIixQkdpx9zQhiiwjoSUw938gOUSMise/FO7AjJAQWckjc
	ap4N9gKLgIDEt8mHWED2SgjISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHU
	guSC4qT0IhO94sTc4tK8dL3k/NxNjJDYn7CD8d4B60OMyUDrJzJLiSbnA1NHXkm8obGZkYWp
	iamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYdawSTL4vEFihHWb1
	O6vpnKdcu0935vE1QhrCWzovWt2T05MrnXlitZbLw0nlj10/uX4MT+E876vuqdDVekWc6XRV
	xwm2LT1/2VXenfu5aNoi9s1x0yX5PsimMB6//Nb23q0X3sr/og7JPWTobJ3VuT1nyvWJ4ucb
	cwvXTC3Wu80zSYHP5tBJJZbijERDLeai4kQAhJNJwBMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQd296cxBBv83mFjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZjx7+ZKl4JVvxfo1B9ka
	GNvsuxg5OSQETCT2Lv3CBGGLSVy4t54NxBYSmM4oceJ5ahcjF5D9l1Hi+NYfLCAJNgEtidVz
	jzOCJEQEfjNK3Ho2hxXEYRb4zySx9XYTO0iVsECYxMR/84DGcnCwCKhK/HkLto1XwFLi557X
	TBC2oMSPyffAhjIDDV2/8zgThC0vsXnNW2aIixQkdpx9zQhiiwjoSUw938gOUSMise/FO8YJ
	jAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOLE8k9rBuLLB
	4hCjAAejEg9vRwBTkBBrYllxZe4hRgkOZiUR3ovFQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSW
	Ek3OBya9vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg3C15
	tdfBuXbei03/056XRO6y2jDp3Ln7DA3rPtzrjuu3iEttncsdfVZSccX/Fc8O1JQ3in/9G1fR
	1/3D6c+ieC2rbcyGvtfSzt/lKnJ431788WhXW8x5dwXNHXW8eptiPHzitErqo048/LRWw4+n
	+8zsKwbbrjbk7+S5lazGkLd5mtDp9jMrlFiKMxINtZiLihMBEQWlRHADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for Advance Power Management and Runtime Power
Management.

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
 drivers/iommu/exynos-iommu.c |  235 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 231 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 9e64483..56aead9 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/pm_domain.h>
 #include <linux/notifier.h>
 
 #include <asm/cacheflush.h>
@@ -186,6 +187,7 @@ struct sysmmu_drvdata {
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
+	bool runtime_active;
 	unsigned long pgtable;
 	void __iomem *sfrbases[0];
 };
@@ -438,7 +440,8 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 		data->pgtable = 0;
 		data->domain = NULL;
 
-		__sysmmu_disable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_disable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Disabled\n");
 	} else  {
@@ -505,7 +508,8 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 		data->pgtable = pgtable;
 		data->domain = domain;
 
-		__sysmmu_enable_nocount(data);
+		if (data->runtime_active)
+			__sysmmu_enable_nocount(data);
 
 		dev_dbg(data->sysmmu, "Enabled\n");
 	} else {
@@ -609,7 +613,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 		data = dev_get_drvdata(client->sysmmu[i]);
 
 		read_lock_irqsave(&data->lock, flags);
-		if (is_sysmmu_active(data)) {
+		if (is_sysmmu_active(data) && data->runtime_active) {
 			int i;
 			clk_enable(data->clk_master);
 			for (i = 0; i < data->nsfrs; i++)
@@ -637,7 +641,8 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		data = dev_get_drvdata(client->sysmmu[i]);
 
 		read_lock_irqsave(&data->lock, flags);
-		if (is_sysmmu_active(data)) {
+		if (is_sysmmu_active(data) &&
+				data->runtime_active) {
 			int i;
 			for (i = 0; i < data->nsfrs; i++) {
 				clk_enable(data->clk_master);
@@ -711,6 +716,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		}
 	}
 
+	pm_runtime_enable(dev);
+
 	data->sysmmu = dev;
 
 	data->clk = devm_clk_get(dev, "sysmmu");
@@ -736,6 +743,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	data->runtime_active = !pm_runtime_enabled(dev);
+
 	rwlock_init(&data->lock);
 
 	platform_set_drvdata(pdev, data);
@@ -744,6 +753,34 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	return ret;
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
@@ -756,6 +793,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.driver	= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.pm		= &sysmmu_pm_ops,
 		.of_match_table	= of_match_ptr(sysmmu_of_match),
 	}
 };
@@ -1141,6 +1179,163 @@ static int __init exynos_iommu_init(void)
 }
 subsys_initcall(exynos_iommu_init);
 
+#ifdef CONFIG_PM_SLEEP
+static int sysmmu_pm_genpd_suspend(struct device *dev)
+{
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < client->num_sysmmu; i++) {
+		ret = pm_generic_suspend(client->sysmmu[i]);
+		if (ret)
+			break;
+	}
+
+	if (!ret)
+		ret = pm_generic_suspend(dev);
+
+	if (ret) {
+		int j;
+
+		for (j = 0; j < i; j++)
+			pm_generic_resume(client->sysmmu[j]);
+	}
+
+	return ret;
+}
+
+static int sysmmu_pm_genpd_resume(struct device *dev)
+{
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < client->num_sysmmu; i++) {
+		ret = pm_generic_resume(client->sysmmu[i]);
+		if (ret)
+			break;
+	}
+
+	if (!ret)
+		ret = pm_generic_resume(dev);
+
+	if (ret) {
+		int j;
+
+		for (j = 0; j < i; j++)
+			pm_generic_suspend(client->sysmmu[j]);
+	}
+
+	return ret;
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
+	int i;
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
+	if (cb) {
+		int ret;
+
+		ret = cb(dev);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < client->num_sysmmu; i++)
+		sysmmu_save_state(client->sysmmu[i]);
+
+	return 0;
+}
+
+static int sysmmu_pm_genpd_restore_state(struct device *dev)
+{
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	int (*cb)(struct device *__dev);
+	int i;
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
+	for (i = 0; i < client->num_sysmmu; i++)
+		sysmmu_restore_state(client->sysmmu[i]);
+
+	if (cb) {
+		int ret;
+		ret = cb(dev);
+		if (ret) {
+			for (i = 0; i < client->num_sysmmu; i++)
+				sysmmu_save_state(client->sysmmu[i]);
+			return ret;
+		}
+	}
+
+	return 0;
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
@@ -1197,12 +1392,44 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
 			return -ENODEV;
 		}
 
+		i = pm_genpd_add_callbacks(dev, &sysmmu_devpm_ops, NULL);
+		if (i && (i != -ENOSYS)) {
+			dev_err(dev,
+				"Failed to register 'dev_pm_ops' for iommu\n");
+			devm_kfree(dev, client);
+			return i;
+		}
+
 		dev->archdata.iommu = client;
 		break;
 	}
+	case BUS_NOTIFY_BOUND_DRIVER:
+	{
+		struct exynos_iommu_client *client = dev->archdata.iommu;
+		if (dev->archdata.iommu &&
+				(!pm_runtime_enabled(dev) ||
+					 IS_ERR(dev_to_genpd(dev)))) {
+			int i;
+			for (i = 0; i < client->num_sysmmu; i++) {
+				struct sysmmu_drvdata *data;
+				pm_runtime_disable(client->sysmmu[i]);
+				data = dev_get_drvdata(client->sysmmu[i]);
+				if (!data)
+					continue;
+				data->runtime_active =
+					!pm_runtime_enabled(data->sysmmu);
+				if (data->runtime_active &&
+						is_sysmmu_active(data))
+					__sysmmu_enable_nocount(data);
+			}
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


