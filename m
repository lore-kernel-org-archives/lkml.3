Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3JGB54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:57:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65411 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab3JGB5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:57:53 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-7e-5252151fdc73
Date: Mon, 07 Oct 2013 10:57:50 +0900
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
Subject: [PATCH v10 15/20] iommu/exynos: remove calls to Runtime PM API
 functions
Message-id: <20131007105750.f59fd8e2d2930432cbebfdd3@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zQ1150aAggz1blSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlfGpdy9jway6iub5b1gaGL+kdTFyckgImEis
	3nmfFcIWk7hwbz1bFyMXh5DAMkaJk90TWWGK3m7dywqRmM4osXDCE0YIZxKTxMkHv5hAqlgE
	VCUaV29gAbHZBLQkVs89DlYkItDGJPG18RALiMMscJpZYtXuFcwgVcICwRL/1l4F6+AVcJQ4
	2tMOtc9C4kJTBztEXFDix+R7YDXMQFM3b2tihbDlJTavecsMMlRCoJdDYlXzbVaIMwQkvk0G
	2cYBlJCV2HSAGWKmpMTBFTdYJjCKzEIydhaSsbOQjF3AyLyKUTS1ILmgOCm9yFivODG3uDQv
	XS85P3cTIySW+3cw3j1gfYgxGWjlRGYp0eR8YCrIK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6
	UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjsvpJbZkWfaWYV0wJe5kOXnqbxZX+c5v0l6xn
	h0Ur5cN2KEZPTzqs/M9519eySW0FTiFWb6pUopU2N09I1p/qNG3K4q69vEzVM6Ytacu8K3Oz
	gmnD1sJczbq9akKyhlff31uxtEiRq2Xz/d8CrOvytYXueK1wySoVDhDoU7zWa91kLpX5/JoS
	S3FGoqEWc1FxIgAaTCed+wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQV150aAgg1nPpC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjU+9e
	xoJZdRXN89+wNDB+Seti5OSQEDCReLt1LyuELSZx4d56ti5GLg4hgemMEgsnPGGEcCYxSZx8
	8IsJpIpFQFWicfUGFhCbTUBLYvXc42BFIgJtTBJfGw+xgDjMAqeZJVbtXsEMUiUsECzxb+1V
	sA5eAUeJoz3tUPssJC40dbBDxAUlfky+B1bDDDR187YmVghbXmLzmrfMExj5ZiEpm4WkbBaS
	sgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxghPFM+kdjKsaLA4xCnAwKvHw7rgfGCTE
	mlhWXJl7iFGCg1lJhPdSHVCINyWxsiq1KD++qDQntfgQYzLQ3xOZpUST84FJLK8k3tDYxMzI
	0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGBPFtitL7ivX3iUmf86v4ZXO
	Q87Kb4c1vnkHGx3bcavwrtj8A7s+/Uz4XXrN+Zsyd7Bu32NND96Xh9izVUSv13JcWq/sWi8m
	W1mnsf+us3qTu9GXSs2sD9VzDf9pMNvPsFH7Vnda/m7qyi3rLq8p1zM5I8Fqlr9m+rPYsws2
	tUmFsZ6fW8H2XomlOCPRUIu5qDgRALkadUtYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime power management by exynos-iommu driver independently from
master H/W's runtime pm is not useful for power saving since attaching
master H/W in probing time turns on its local power endlessly.
Thus this removes runtime pm API calls.
Runtime PM support is added in the following commits to exynos-iommu
driver.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  337 +++++++++++++++++++++++++-----------------
 1 files changed, 201 insertions(+), 136 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 976b88a..d9c5416 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -27,6 +27,8 @@
 #include <linux/memblock.h>
 #include <linux/export.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/notifier.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
@@ -154,6 +156,12 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
 	"UNKNOWN FAULT"
 };
 
+struct exynos_iommu_client {
+	struct list_head node;	/* entry of exynos_iommu_domain.clients */
+	struct device *dev;
+	struct device *sysmmu;
+};
+
 struct exynos_iommu_domain {
 	struct list_head clients; /* list of sysmmu_drvdata.node */
 	unsigned long *pgtable; /* lv1 page table, 16KB */
@@ -163,9 +171,8 @@ struct exynos_iommu_domain {
 };
 
 struct sysmmu_drvdata {
-	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
-	struct device *dev;	/* Owner of system MMU */
+	struct device *master;	/* Owner of system MMU */
 	void __iomem *sfrbase;
 	struct clk *clk;
 	struct clk *clk_master;
@@ -250,7 +257,6 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 				       unsigned long pgd)
 {
-	__raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
 	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
 
 	__sysmmu_tlb_invalidate(sfrbase);
@@ -310,7 +316,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 					itype, base, addr);
 		if (data->domain)
 			ret = report_iommu_fault(data->domain,
-					data->dev, addr, itype);
+					data->master, addr, itype);
 	}
 
 	/* fault is not recovered by fault handler */
@@ -327,125 +333,145 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
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
 	clk_enable(data->clk_master);
 
 	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
+	__raw_writel(0, data->sfrbase + REG_MMU_CFG);
 
+	clk_disable(data->clk);
 	clk_disable(data->clk_master);
+}
 
-	clk_disable(data->clk);
+static bool __sysmmu_disable(struct sysmmu_drvdata *data)
+{
+	bool disabled;
+	unsigned long flags;
 
-	disabled = true;
-	data->pgtable = 0;
-	data->domain = NULL;
-finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	write_lock_irqsave(&data->lock, flags);
+
+	disabled = set_sysmmu_inactive(data);
+
+	if (disabled) {
+		data->pgtable = 0;
+		data->domain = NULL;
+
+		__sysmmu_disable_nocount(data);
 
-	if (disabled)
 		dev_dbg(data->sysmmu, "Disabled\n");
-	else
-		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
+	} else  {
+		dev_dbg(data->sysmmu, "%d times left to disable\n",
 					data->activations);
+	}
+
+	write_unlock_irqrestore(&data->lock, flags);
 
 	return disabled;
 }
 
-/* __exynos_sysmmu_enable: Enables System MMU
- *
- * returns -error if an error occurred and System MMU is not enabled,
- * 0 if the System MMU has been just enabled and 1 if System MMU was already
- * enabled before.
- */
-static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
-			unsigned long pgtable, struct iommu_domain *domain)
+static void __sysmmu_init_config(struct sysmmu_drvdata *data)
 {
-	int ret = 0;
-	unsigned long flags;
-	unsigned int min;
+	unsigned long cfg = 0;
+	int maj, min = 0;
 
-	write_lock_irqsave(&data->lock, flags);
+	maj = __sysmmu_version(data, &min);
+	if ((maj == 3) && (min > 1))
+		cfg |= CFG_FLPDCACHE;
 
-	if (!set_sysmmu_active(data)) {
-		if (WARN_ON(pgtable != data->pgtable)) {
-			ret = -EBUSY;
-			set_sysmmu_inactive(data);
-		} else {
-			ret = 1;
-		}
-
-		dev_dbg(data->sysmmu, "Already enabled\n");
-		goto finish;
-	}
-
-
-	data->pgtable = pgtable;
+	__raw_writel(cfg, data->sfrbase + REG_MMU_CFG);
+}
 
+static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
+{
 	clk_enable(data->clk);
 	clk_enable(data->clk_master);
 
-	__sysmmu_set_ptbase(data->sfrbase, pgtable);
+	__raw_writel(CTRL_BLOCK, data->sfrbase + REG_MMU_CTRL);
 
-	if ((__sysmmu_version(data, &min) == 3) && (min > 1)) {
-		unsigned long cfg;
-		cfg = __raw_readl(data->sfrbase + REG_MMU_CFG);
-		__raw_writel(cfg | CFG_FLPDCACHE, data->sfrbase + REG_MMU_CFG);
-	}
+	__sysmmu_init_config(data);
+
+	__sysmmu_set_ptbase(data->sfrbase, data->pgtable);
 
 	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
 
 	clk_disable(data->clk_master);
+}
 
-	data->domain = domain;
+static int __sysmmu_enable(struct sysmmu_drvdata *data,
+			unsigned long pgtable, struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
+
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
 	int ret;
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	struct sysmmu_drvdata *data;
 
-	BUG_ON(!memblock_is_memory(pgtable));
+	if (WARN_ON(!client))
+		return -ENODEV;
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0) {
-		dev_dbg(data->sysmmu, "Failed to enable\n");
-		return ret;
-	}
+	data = dev_get_drvdata(client->sysmmu);
 
-	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
-	if (WARN_ON(ret < 0)) {
-		pm_runtime_put(data->sysmmu);
-		dev_err(data->sysmmu, "Already enabled with page table %#lx\n",
-			data->pgtable);
-	} else {
-		data->dev = dev;
-	}
+	ret = __sysmmu_enable(data, pgtable, domain);
+	if (ret >= 0)
+		data->master = dev;
 
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
 	bool disabled;
+	struct exynos_iommu_client *client = dev->archdata.iommu;
+	struct sysmmu_drvdata *data;
+
+	if (WARN_ON(!client))
+		return true;
 
-	disabled = __exynos_sysmmu_disable(data);
-	pm_runtime_put(data->sysmmu);
+	data = dev_get_drvdata(client->sysmmu);
+
+	disabled = __sysmmu_disable(data);
+	if (disabled)
+		data->master = NULL;
 
 	return disabled;
 }
@@ -453,11 +479,13 @@ static bool exynos_sysmmu_disable(struct device *dev)
 static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 					size_t size)
 {
+	struct exynos_iommu_client *client = dev->archdata.iommu;
 	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct sysmmu_drvdata *data;
 
-	read_lock_irqsave(&data->lock, flags);
+	data = dev_get_drvdata(client->sysmmu);
 
+	read_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data)) {
 		unsigned int num_inv = 1;
 		/*
@@ -477,19 +505,21 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 		}
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
+	struct exynos_iommu_client *client = dev->archdata.iommu;
 	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct sysmmu_drvdata *data;
 
-	read_lock_irqsave(&data->lock, flags);
+	data = dev_get_drvdata(client->sysmmu);
 
+	read_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data)) {
 		clk_enable(data->clk_master);
 		if (sysmmu_block(data->sfrbase)) {
@@ -498,9 +528,8 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		}
 		clk_disable(data->clk_master);
 	} else {
-		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
+		dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 	}
-
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
@@ -563,7 +592,6 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	data->sysmmu = dev;
 	rwlock_init(&data->lock);
-	INIT_LIST_HEAD(&data->node);
 
 	platform_set_drvdata(pdev, data);
 
@@ -637,7 +665,7 @@ err_pgtable:
 static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_client *client;
 	unsigned long flags;
 	int i;
 
@@ -645,11 +673,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each_entry(data, &priv->clients, node) {
-		while (!exynos_sysmmu_disable(data->dev))
+	list_for_each_entry(client, &priv->clients, node) {
+		while (!exynos_sysmmu_disable(client->dev))
 			; /* until System MMU is actually disabled */
 	}
 
+	while (!list_empty(&priv->clients))
+		list_del_init(priv->clients.next);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
@@ -666,41 +697,26 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 static int exynos_iommu_attach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_client *client = dev->archdata.iommu;
 	struct exynos_iommu_domain *priv = domain->priv;
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
-
-	if (ret == 0) {
-		/* 'data->node' must not be appeared in priv->clients */
-		BUG_ON(!list_empty(&data->node));
-		data->dev = dev;
-		list_add_tail(&data->node, &priv->clients);
-	}
+	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
+	if (ret == 0)
+		list_add_tail(&client->node, &priv->clients);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-		pm_runtime_put(data->sysmmu);
-	} else if (ret > 0) {
-		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
-					__func__, __pa(priv->pgtable));
-	} else {
-		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
-					__func__, __pa(priv->pgtable));
-	}
+	else
+		dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
+					__func__, __pa(priv->pgtable),
+					(ret == 0) ? "" : ", again");
 
 	return ret;
 }
@@ -708,39 +724,27 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 static void exynos_iommu_detach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_client *client = NULL;
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct list_head *pos;
 	unsigned long flags;
-	bool found = false;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each(pos, &priv->clients) {
-		if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
-			found = true;
+	list_for_each_entry(client, &priv->clients, node) {
+		if (client == dev->archdata.iommu) {
+			if (exynos_sysmmu_disable(dev))
+				list_del_init(&client->node);
 			break;
 		}
 	}
 
-	if (!found)
-		goto finish;
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (__exynos_sysmmu_disable(data)) {
+	if (client == dev->archdata.iommu)
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
 					__func__, __pa(priv->pgtable));
-		list_del_init(&data->node);
-
-	} else {
-		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
-					__func__, __pa(priv->pgtable));
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
@@ -870,7 +874,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					       unsigned long iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_client *client;
 	unsigned long flags;
 	unsigned long *ent;
 	size_t err_pgsize;
@@ -931,8 +935,8 @@ done:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
+	list_for_each_entry(client, &priv->clients, node)
+		sysmmu_tlb_invalidate_entry(client->dev, iova, size);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return size;
@@ -1017,3 +1021,64 @@ err_reg_driver:
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
+		struct exynos_iommu_client *client;
+		struct device_node *np;
+		struct platform_device *sysmmu;
+
+		np = of_parse_phandle(dev->of_node, "iommu", 0);
+		if (!np)
+			break;
+
+		client = devm_kzalloc(dev, sizeof(*client), GFP_KERNEL);
+		if (!client) {
+			dev_err(dev, "No Memory for exynos_iommu_client\n");
+			return -ENOMEM;
+		}
+
+		client->dev = dev;
+		INIT_LIST_HEAD(&client->node);
+
+		sysmmu = of_find_device_by_node(np);
+		if (!sysmmu) {
+			dev_err(dev, "sysmmu node '%s' not found\n", np->name);
+			devm_kfree(dev, client);
+			return -ENODEV;
+		}
+
+		client->sysmmu = &sysmmu->dev;
+
+		dev->archdata.iommu = client;
+		break;
+	}
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+	{
+		if (dev->archdata.iommu) {
+			devm_kfree(dev, dev->archdata.iommu);
+			dev->archdata.iommu = NULL;
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
+	return bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
+}
+arch_initcall(exynos_iommu_prepare);
-- 
1.7.2.5

