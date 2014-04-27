Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaD0HlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31159 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaD0Hjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:31 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-89-535cb431783e
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
Subject: [PATCH v12 15/31] iommu/exynos: handle 'mmu-masters' property of DT
 and improve handling sysmmu
Date: Sun, 27 Apr 2014 13:07:47 +0530
Message-id: <1398584283-22846-16-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkWtdwS0ywwYl1ahZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV0b303ns
	Bbv7GSvO7lvG1sB4tqSLkZNDQsBE4uj+EywQtpjEhXvr2boYuTiEBJYySsz7eI65i5EDrKir
	TxIivohRomV1MyOEM4FJ4urUfjaQbjYBQ4nt966wgiREBFYzSvRdPMMO4jAL3GWSmLPqHSPI
	KGGBLImvcyJAGlgEVCUedPUxgti8Ah4Sr34tYofYpiAxZ5INSJgTKPzkzh6w64QE3CXenvoC
	Nl9CYCaHxIJT5xkh5ghIfJt8iAWiV1Zi0wFmiG8kJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJj
	veLE3OLSvHS95PzcTYzAeDz971n/Dsa7B6wPMSYDjZvILCWanA+M57ySeENjMyMLUxNTYyNz
	SzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOh/dplf/jSrKxnTDL/+cxIX
	/Mq89kyJYnJf/y3xWyn+NkuYxYNFV87zKCialS2zbX3qPG61TVsqZ4Yxfl/MYOfooqE0x1h9
	1txngW2rQ0qkZNYImnJXqE686TvFOfQES8+xhWt1/5yfY3Ux+ELpPIVNsU8uzJkju+GlEmOs
	Rvsk9+iJH08ryCmxFGckGmoxFxUnAgC9CAF13QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3DLTHBBnNuSFjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzup/OYy/Y3c9YcXbfMrYGxrMlXYwcHBICJhJdfZJdjJxAppjE
	hXvr2boYuTiEBBYxSrSsbmaEcCYwSVyd2s8GUsUmYCix/d4VVpCEiMBqRom+i2fYQRxmgbtM
	EnNWvWMEGSsskCXxdU4ESAOLgKrEg64+RhCbV8BD4tWvRewQmxUk5kyyAQlzAoWf3NnDAmIL
	CbhLvD31hXUCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR/kx6B+OqBotDjAIc
	jEo8vD+kY4KFWBPLiitzDzFKcDArifByTgcK8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4w
	EeWVxBsam5ibGptamliYmFmSJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2O5x/b7B9m/
	/GeYEqnl5/Z2gdLvl0eP1bzb/ieyvG+xPFvaYa6rk+be6L3VOX9dyWNDh3CtS6HCLOXPXXv8
	du5ZITzlcEHeN6n/hcnSt74lxbTJt5726PMOmvi14Yk4C1tHyjkxg00aRv8l9YKSpf8aHOg6
	ftz5TVF5tZVwhopJyfYQhU0/W5VYijMSDbWYi4oTAUs28RE6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

"iommu/exynos: support for device tree" patch just binds exynos-iommu
driver with the compatible strings of System MMUs but the important
information of the DT, 'mmu-masters' is not processed by the driver.
This patch process 'mmu-masters' so that the master device driver can
handle its system mmu.

Also, system mmu handling is improved. Previously, an IOMMU domain is
bound to a System MMU which is not correct. This patch binds an IOMMU
domain with the master device of a System MMU.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  381 ++++++++++++++++++++++++++++--------------
 1 file changed, 253 insertions(+), 128 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index b07b78b..45c792c 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -26,6 +26,8 @@
 #include <linux/memblock.h>
 #include <linux/export.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/notifier.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
@@ -100,6 +102,8 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+#define has_sysmmu(dev)		(dev->archdata.iommu != NULL)
+
 static struct kmem_cache *lv2table_kmem_cache;
 
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
@@ -148,6 +152,16 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
 	"UNKNOWN FAULT"
 };
 
+/* attached to dev.archdata.iommu of the master device */
+struct exynos_iommu_owner {
+	struct list_head client; /* entry of exynos_iommu_domain.clients */
+	struct device *dev;
+	struct device *sysmmu;
+	struct iommu_domain *domain;
+	void *vmm_data;         /* IO virtual memory manager's data */
+	spinlock_t lock;        /* Lock to preserve consistency of System MMU */
+};
+
 struct exynos_iommu_domain {
 	struct list_head clients; /* list of sysmmu_drvdata.node */
 	unsigned long *pgtable; /* lv1 page table, 16KB */
@@ -157,9 +171,8 @@ struct exynos_iommu_domain {
 };
 
 struct sysmmu_drvdata {
-	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
-	struct device *dev;	/* Owner of system MMU */
+	struct device *master;	/* Owner of system MMU */
 	void __iomem *sfrbase;
 	struct clk *clk;
 	struct clk *clk_master;
@@ -228,7 +241,6 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 				       unsigned long pgd)
 {
-	__raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
 	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
 
 	__sysmmu_tlb_invalidate(sfrbase);
@@ -289,7 +301,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 					itype, base, addr);
 		if (data->domain)
 			ret = report_iommu_fault(data->domain,
-					data->dev, addr, itype);
+					data->master, addr, itype);
 	}
 
 	/* fault is not recovered by fault handler */
@@ -307,120 +319,152 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
+static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
 {
-	unsigned long flags;
-	bool disabled = false;
-
-	write_lock_irqsave(&data->lock, flags);
-
-	if (!set_sysmmu_inactive(data))
-		goto finish;
-
 	if (!IS_ERR(data->clk_master))
 		clk_enable(data->clk_master);
 
 	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
+	__raw_writel(0, data->sfrbase + REG_MMU_CFG);
 
 	clk_disable(data->clk);
 	if (!IS_ERR(data->clk_master))
 		clk_disable(data->clk_master);
-
-	disabled = true;
-	data->pgtable = 0;
-	data->domain = NULL;
-finish:
-	write_unlock_irqrestore(&data->lock, flags);
-
-	if (disabled)
-		dev_dbg(data->sysmmu, "Disabled\n");
-	else
-		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
-					data->activations);
-
-	return disabled;
 }
 
-/* __exynos_sysmmu_enable: Enables System MMU
- *
- * returns -error if an error occurred and System MMU is not enabled,
- * 0 if the System MMU has been just enabled and 1 if System MMU was already
- * enabled before.
- */
-static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
-			unsigned long pgtable, struct iommu_domain *domain)
+static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 {
-	int ret = 0;
+	bool disabled;
 	unsigned long flags;
 
 	write_lock_irqsave(&data->lock, flags);
 
-	if (!set_sysmmu_active(data)) {
-		if (WARN_ON(pgtable != data->pgtable)) {
-			ret = -EBUSY;
-			set_sysmmu_inactive(data);
-		} else {
-			ret = 1;
-		}
+	disabled = set_sysmmu_inactive(data);
+
+	if (disabled) {
+		data->pgtable = 0;
+		data->domain = NULL;
+
+		__sysmmu_disable_nocount(data);
 
-		dev_dbg(data->sysmmu, "Already enabled\n");
-		goto finish;
+		dev_dbg(data->sysmmu, "Disabled\n");
+	} else  {
+		dev_dbg(data->sysmmu, "%d times left to disable\n",
+					data->activations);
 	}
 
-	data->pgtable = pgtable;
+	write_unlock_irqrestore(&data->lock, flags);
+
+	return disabled;
+}
+
+static void __sysmmu_init_config(struct sysmmu_drvdata *data)
+{
+	unsigned long cfg = 0;
+
+	__raw_writel(cfg, data->sfrbase + REG_MMU_CFG);
+}
 
+static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
+{
 	if (!IS_ERR(data->clk_master))
 		clk_enable(data->clk_master);
 	clk_enable(data->clk);
 
-	__sysmmu_set_ptbase(data->sfrbase, pgtable);
+	__raw_writel(CTRL_BLOCK, data->sfrbase + REG_MMU_CTRL);
+
+	__sysmmu_init_config(data);
+
+	__sysmmu_set_ptbase(data->sfrbase, data->pgtable);
 
 	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
 
 	if (!IS_ERR(data->clk_master))
 		clk_disable(data->clk_master);
+}
+
+static int __sysmmu_enable(struct sysmmu_drvdata *data,
+			unsigned long pgtable, struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
 
-	data->domain = domain;
+	write_lock_irqsave(&data->lock, flags);
+	if (set_sysmmu_active(data)) {
+		data->pgtable = pgtable;
+		data->domain = domain;
+
+		__sysmmu_enable_nocount(data);
+
+		dev_dbg(data->sysmmu, "Enabled\n");
+	} else {
+		ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
+
+		dev_dbg(data->sysmmu, "already enabled\n");
+	}
+
+	if (WARN_ON(ret < 0))
+		set_sysmmu_inactive(data); /* decrement count */
 
-	dev_dbg(data->sysmmu, "Enabled\n");
-finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
 
-int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
+/* __exynos_sysmmu_enable: Enables System MMU
+ *
+ * returns -error if an error occurred and System MMU is not enabled,
+ * 0 if the System MMU has been just enabled and 1 if System MMU was already
+ * enabled before.
+ */
+static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
+				  struct iommu_domain *domain)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-	int ret;
+	int ret = 0;
+	unsigned long flags;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct sysmmu_drvdata *data;
 
-	BUG_ON(!memblock_is_memory(pgtable));
+	BUG_ON(!has_sysmmu(dev));
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0) {
-		dev_dbg(data->sysmmu, "Failed to enable\n");
-		return ret;
-	}
+	spin_lock_irqsave(&owner->lock, flags);
 
-	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
-	if (WARN_ON(ret < 0)) {
-		pm_runtime_put(data->sysmmu);
-		dev_err(data->sysmmu, "Already enabled with page table %#lx\n",
-			data->pgtable);
-	} else {
-		data->dev = dev;
-	}
+	data = dev_get_drvdata(owner->sysmmu);
+
+	ret = __sysmmu_enable(data, pgtable, domain);
+	if (ret >= 0)
+		data->master = dev;
+
+	spin_unlock_irqrestore(&owner->lock, flags);
 
 	return ret;
 }
 
+int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
+{
+	BUG_ON(!memblock_is_memory(pgtable));
+
+	return __exynos_sysmmu_enable(dev, pgtable, NULL);
+}
+
 static bool exynos_sysmmu_disable(struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-	bool disabled;
+	unsigned long flags;
+	bool disabled = true;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct sysmmu_drvdata *data;
+
+	BUG_ON(!has_sysmmu(dev));
 
-	disabled = __exynos_sysmmu_disable(data);
-	pm_runtime_put(data->sysmmu);
+	spin_lock_irqsave(&owner->lock, flags);
+
+	data = dev_get_drvdata(owner->sysmmu);
+
+	disabled = __sysmmu_disable(data);
+	if (disabled)
+		data->master = NULL;
+
+	spin_unlock_irqrestore(&owner->lock, flags);
 
 	return disabled;
 }
@@ -428,11 +472,13 @@ static bool exynos_sysmmu_disable(struct device *dev)
 static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 					size_t size)
 {
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct sysmmu_drvdata *data;
 
-	read_lock_irqsave(&data->lock, flags);
+	data = dev_get_drvdata(owner->sysmmu);
 
+	read_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data)) {
 		unsigned int maj;
 		unsigned int num_inv = 1;
@@ -462,19 +508,21 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 		if (!IS_ERR(data->clk_master))
 			clk_disable(data->clk_master);
 	} else {
-		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
+		dev_dbg(dev, "disabled. Skipping TLB invalidation @ %#lx\n",
+			iova);
 	}
-
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
 {
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct sysmmu_drvdata *data;
 
-	read_lock_irqsave(&data->lock, flags);
+	data = dev_get_drvdata(owner->sysmmu);
 
+	read_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data)) {
 		if (!IS_ERR(data->clk_master))
 			clk_enable(data->clk_master);
@@ -485,18 +533,20 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		if (!IS_ERR(data->clk_master))
 			clk_disable(data->clk_master);
 	} else {
-		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
+		dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 	}
-
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
+static int __init exynos_iommu_prepare(void);
+
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int irq, ret;
 	struct device *dev = &pdev->dev;
 	struct sysmmu_drvdata *data;
 	struct resource *res;
+	struct device_node *node;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -542,14 +592,41 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Relation between master and System MMU is 1:1. */
+	node = of_parse_phandle(dev->of_node, "mmu-masters", 0);
+	if (node) {
+		struct platform_device *master = of_find_device_by_node(node);
+
+		if (!master) {
+			dev_err(dev, "%s: mmu-master '%s' not found\n",
+				__func__, node->name);
+			return -EINVAL;
+		}
+
+		if (master->dev.archdata.iommu != NULL) {
+			dev_err(dev, "%s: '%s' is master of other MMU\n",
+				__func__, node->name);
+			return -EINVAL;
+		}
+
+		/*
+		 * archdata.iommu will be initialized with exynos_iommu_client
+		 * in sysmmu_hook_driver_register().
+		 */
+		master->dev.archdata.iommu = dev;
+	}
+
 	data->sysmmu = dev;
 	rwlock_init(&data->lock);
-	INIT_LIST_HEAD(&data->node);
 
 	platform_set_drvdata(pdev, data);
 
 	pm_runtime_enable(dev);
 
+	ret = exynos_iommu_prepare();
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -619,7 +696,7 @@ err_pgtable:
 static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner;
 	unsigned long flags;
 	int i;
 
@@ -627,11 +704,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each_entry(data, &priv->clients, node) {
-		while (!exynos_sysmmu_disable(data->dev))
+	list_for_each_entry(owner, &priv->clients, client) {
+		while (!exynos_sysmmu_disable(owner->dev))
 			; /* until System MMU is actually disabled */
 	}
 
+	while (!list_empty(&priv->clients))
+		list_del_init(priv->clients.next);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
@@ -648,42 +728,30 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 static int exynos_iommu_attach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	struct exynos_iommu_domain *priv = domain->priv;
 	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
 	int ret;
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0)
-		return ret;
-
-	ret = 0;
-
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
 
+	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
 	if (ret == 0) {
-		/* 'data->node' must not be appeared in priv->clients */
-		BUG_ON(!list_empty(&data->node));
-		data->dev = dev;
-		list_add_tail(&data->node, &priv->clients);
+		list_add_tail(&owner->client, &priv->clients);
+		owner->domain = domain;
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %pa\n",
 					__func__, &pagetable);
-		pm_runtime_put(data->sysmmu);
-	} else if (ret > 0) {
-		dev_dbg(dev, "%s: IOMMU with pgtable %pa already attached\n",
-					__func__, &pagetable);
-	} else {
-		dev_dbg(dev, "%s: Attached new IOMMU with pgtable %pa\n",
-					__func__, &pagetable);
-	}
+	else
+		dev_dbg(dev, "%s: Attached IOMMU with pgtable %pa%s\n",
+					__func__, &pagetable,
+					(ret == 0) ? "" : ", again");
 
 	return ret;
 }
@@ -691,40 +759,30 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 static void exynos_iommu_detach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner;
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct list_head *pos;
 	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
-	bool found = false;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each(pos, &priv->clients) {
-		if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
-			found = true;
+	list_for_each_entry(owner, &priv->clients, client) {
+		if (owner == dev->archdata.iommu) {
+			if (exynos_sysmmu_disable(dev)) {
+				list_del_init(&owner->client);
+				owner->domain = NULL;
+			}
 			break;
 		}
 	}
 
-	if (!found)
-		goto finish;
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (__exynos_sysmmu_disable(data)) {
+	if (owner == dev->archdata.iommu)
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %pa\n",
 					__func__, &pagetable);
-		list_del_init(&data->node);
-
-	} else {
-		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %pa delayed",
-					__func__, &pagetable);
-	}
-
-finish:
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (found)
-		pm_runtime_put(data->sysmmu);
+	else
+		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
@@ -854,7 +912,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					       unsigned long iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner;
 	unsigned long flags;
 	unsigned long *ent;
 	size_t err_pgsize;
@@ -915,8 +973,8 @@ done:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
+	list_for_each_entry(owner, &priv->clients, client)
+		sysmmu_tlb_invalidate_entry(owner->dev, iova, size);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return size;
@@ -1001,3 +1059,70 @@ err_reg_driver:
 	return ret;
 }
 subsys_initcall(exynos_iommu_init);
+
+static int sysmmu_hook_driver_register(struct notifier_block *nb,
+					unsigned long val,
+					void *p)
+{
+	struct device *dev = p;
+
+	switch (val) {
+	case BUS_NOTIFY_BIND_DRIVER:
+	{
+		struct exynos_iommu_owner *owner;
+
+		/* No System MMU assigned. See exynos_sysmmu_probe(). */
+		if (dev->archdata.iommu == NULL)
+			break;
+
+		owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
+		if (!owner) {
+			dev_err(dev, "No Memory for exynos_iommu_owner\n");
+			return -ENOMEM;
+		}
+
+		owner->dev = dev;
+		INIT_LIST_HEAD(&owner->client);
+		owner->sysmmu = dev->archdata.iommu;
+
+		dev->archdata.iommu = owner;
+		break;
+	}
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+	{
+		struct exynos_iommu_owner *owner = dev->archdata.iommu;
+		if (owner) {
+			struct device *sysmmu = owner->sysmmu;
+			/* if still attached to an iommu_domain. */
+			if (WARN_ON(!list_empty(&owner->client)))
+				iommu_detach_device(owner->domain, owner->dev);
+			devm_kfree(dev, owner);
+			dev->archdata.iommu = sysmmu;
+		}
+		break;
+	}
+	} /* switch (val) */
+
+	return 0;
+}
+
+static struct notifier_block sysmmu_notifier = {
+	.notifier_call = &sysmmu_hook_driver_register,
+};
+
+static int __init exynos_iommu_prepare(void)
+{
+	static bool registered = false;
+	int ret;
+
+	if (registered)
+		return 0;
+
+	ret = bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
+	if (!ret)
+		registered = true;
+	else
+		pr_err("Failed to register sysmmu_notifier\n");
+
+	return ret;
+}
-- 
1.7.9.5

