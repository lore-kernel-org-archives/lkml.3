Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaELGRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:17:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35654 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaELGRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:17:11 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-98-53706766b294
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
Subject: [PATCH v13 17/19] iommu/exynos: support for device tree
Date: Mon, 12 May 2014 11:45:02 +0530
Message-id: <1399875304-19948-18-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWyRsSkRjctvSDY4OwLAYs7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6M3glVBUurKrY0rGBrYFyZ0sXIySEhYCLx+flKNghbTOLCvfVgtpDAUkaJ
	64dFYGpuL9/B3sXIBRRfxCjR+LmVGcKZwCRx79B/sA42AUOJ7feusIIkRARWM0r0XTwD1sIs
	MJtZ4sijxYwgVcICDhJbO+ewg9gsAqoSh88+YgaxeQU8JL63tADZHED7FCTmTLIBCXMChT+v
	ngJ1krvEsVdXwRZICGzhkHh//yozxBwBiW+TD7FA9MpKbDrADHG2pMTBFTdYJjAKL2BkWMUo
	mlqQXFCclF5kpFecmFtcmpeul5yfu4kRGKun/z3r28F484D1IcZkoHETmaVEk/OBsZ5XEm9o
	bGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjNNms/Da16
	ferTvgWd91qXptz+oNQt8jEhaLOtwXK5BW+O3dnYbKjObbuVxbDucUG7an19Yx1n6g3OcIYO
	4T/ClvuNVvJWXy870Rrn4JTL//XPaSGLtPNn1qxWbs8ul9VRbzRtOPWCRcdw/omQoNj1+1kE
	/LsaHthwL9ISezvFZEvUt93xIkosxRmJhlrMRcWJAGOel2DrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd209IJggwcfmC3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZvROqCpYWlWxpWEFWwPjypQuRk4O
	CQETidvLd7BD2GISF+6tZ+ti5OIQEljEKNH4uZUZwpnAJHHv0H82kCo2AUOJ7feusIIkRARW
	M0r0XTzDDuIwC8xmljjyaDEjSJWwgIPE1s45YHNZBFQlDp99xAxi8wp4SHxvaQGyOYD2KUjM
	mWQDEuYECn9ePQVsgZCAu8SxV1dZJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	nAqeSe9gXNVgcYhRgINRiYf3A0NBsBBrYllxZe4hRgkOZiUR3o/+QCHelMTKqtSi/Pii0pzU
	4kOMyUBHTWSWEk3OB6apvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7ZaBwoJpCeWpGanphakFsFs
	YeLglGpg3LTp24JJGfdtnE25ExKM9sZKVNbk/FvFvU/YsmVZsn7iz1PPFmz7L7HXwbRFhunA
	9h3fmpmOxtaLnWqoOPP+zapK+/UZt7W+sPMbbYldNmXaeTWWDfNPxP56udLl0rkdcpIVp4yy
	pHasrJ88wUx2+rGn81Xn1z7zPHFhvorXjZn582qi9p7QslJiKc5INNRiLipOBADYsxysSQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This commit adds device tree support for System MMU.

Also, system mmu handling is improved. Previously, an IOMMU domain is
bound to a System MMU which is not correct. This patch binds an IOMMU
domain with the master device of a System MMU.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |  283 +++++++++++++++++++++++-------------------
 1 file changed, 158 insertions(+), 125 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7188b47..b937490 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -114,6 +114,8 @@ static u32 lv2ent_offset(sysmmu_iova_t iova)
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
+#define has_sysmmu(dev)		(dev->archdata.iommu != NULL)
+
 static struct kmem_cache *lv2table_kmem_cache;
 
 static sysmmu_pte_t *section_entry(sysmmu_pte_t *pgtable, sysmmu_iova_t iova)
@@ -163,6 +165,16 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
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
 	sysmmu_pte_t *pgtable; /* lv1 page table, 16KB */
@@ -172,9 +184,8 @@ struct exynos_iommu_domain {
 };
 
 struct sysmmu_drvdata {
-	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
-	struct device *dev;	/* Owner of system MMU */
+	struct device *master;	/* Owner of system MMU */
 	void __iomem *sfrbase;
 	struct clk *clk;
 	struct clk *clk_master;
@@ -243,7 +254,6 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 				       phys_addr_t pgd)
 {
-	__raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
 	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
 
 	__sysmmu_tlb_invalidate(sfrbase);
@@ -305,7 +315,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 					itype, base, addr);
 		if (data->domain)
 			ret = report_iommu_fault(data->domain,
-					data->dev, addr, itype);
+					data->master, addr, itype);
 	}
 
 	/* fault is not recovered by fault handler */
@@ -323,120 +333,152 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
+static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
 {
-	unsigned long flags;
-	bool disabled = false;
-
-	spin_lock_irqsave(&data->lock, flags);
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
-	spin_unlock_irqrestore(&data->lock, flags);
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
-			phys_addr_t pgtable, struct iommu_domain *domain)
+static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 {
-	int ret = 0;
+	bool disabled;
 	unsigned long flags;
 
 	spin_lock_irqsave(&data->lock, flags);
 
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
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return disabled;
+}
 
+static void __sysmmu_init_config(struct sysmmu_drvdata *data)
+{
+	unsigned int cfg = 0;
+
+	__raw_writel(cfg, data->sfrbase + REG_MMU_CFG);
+}
+
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
 
-	data->domain = domain;
+static int __sysmmu_enable(struct sysmmu_drvdata *data,
+			phys_addr_t pgtable, struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
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
 	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
 
-int exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable)
+/* __exynos_sysmmu_enable: Enables System MMU
+ *
+ * returns -error if an error occurred and System MMU is not enabled,
+ * 0 if the System MMU has been just enabled and 1 if System MMU was already
+ * enabled before.
+ */
+static int __exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable,
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
-		dev_err(data->sysmmu, "Already enabled with page table %#x\n",
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
 
+int exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable)
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
@@ -444,11 +486,13 @@ static bool exynos_sysmmu_disable(struct device *dev)
 static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 					size_t size)
 {
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct sysmmu_drvdata *data;
 
-	spin_lock_irqsave(&data->lock, flags);
+	data = dev_get_drvdata(owner->sysmmu);
 
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data)) {
 		unsigned int maj;
 		unsigned int num_inv = 1;
@@ -478,19 +522,21 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, sysmmu_iova_t iova,
 		if (!IS_ERR(data->clk_master))
 			clk_disable(data->clk_master);
 	} else {
-		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
+		dev_dbg(dev, "disabled. Skipping TLB invalidation @ %#x\n",
+			iova);
 	}
-
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
 {
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct sysmmu_drvdata *data;
 
-	spin_lock_irqsave(&data->lock, flags);
+	data = dev_get_drvdata(owner->sysmmu);
 
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data)) {
 		if (!IS_ERR(data->clk_master))
 			clk_enable(data->clk_master);
@@ -501,13 +547,12 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		if (!IS_ERR(data->clk_master))
 			clk_disable(data->clk_master);
 	} else {
-		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
+		dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 	}
-
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
-static int exynos_sysmmu_probe(struct platform_device *pdev)
+static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int irq, ret;
 	struct device *dev = &pdev->dev;
@@ -560,7 +605,6 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	data->sysmmu = dev;
 	spin_lock_init(&data->lock);
-	INIT_LIST_HEAD(&data->node);
 
 	platform_set_drvdata(pdev, data);
 
@@ -569,11 +613,17 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver exynos_sysmmu_driver = {
-	.probe		= exynos_sysmmu_probe,
-	.driver		= {
+static const struct of_device_id sysmmu_of_match[] __initconst = {
+	{ .compatible	= "samsung,exynos-sysmmu", },
+	{ },
+};
+
+static struct platform_driver exynos_sysmmu_driver __refdata = {
+	.probe	= exynos_sysmmu_probe,
+	.driver	= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.of_match_table	= sysmmu_of_match,
 	}
 };
 
@@ -625,7 +675,7 @@ err_pgtable:
 static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner;
 	unsigned long flags;
 	int i;
 
@@ -633,11 +683,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
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
@@ -654,27 +707,18 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
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
 
-	ret = __exynos_sysmmu_enable(data, pagetable, domain);
-
+	ret = __exynos_sysmmu_enable(dev, pagetable, domain);
 	if (ret == 0) {
-		/* 'data->node' must not be appeared in priv->clients */
-		BUG_ON(!list_empty(&data->node));
-		data->dev = dev;
-		list_add_tail(&data->node, &priv->clients);
+		list_add_tail(&owner->client, &priv->clients);
+		owner->domain = domain;
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -682,7 +726,6 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %pa\n",
 					__func__, &pagetable);
-		pm_runtime_put(data->sysmmu);
 		return ret;
 	}
 
@@ -695,40 +738,30 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
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
+		dev_err(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
 static sysmmu_pte_t *alloc_lv2entry(sysmmu_pte_t *sent, sysmmu_iova_t iova,
@@ -855,7 +888,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					unsigned long l_iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner;
 	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
 	sysmmu_pte_t *ent;
 	size_t err_pgsize;
@@ -917,8 +950,8 @@ done:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
+	list_for_each_entry(owner, &priv->clients, client)
+		sysmmu_tlb_invalidate_entry(owner->dev, iova, size);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return size;
-- 
1.7.9.5

