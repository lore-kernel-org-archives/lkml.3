Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaD0HlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:41:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8617 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaD0Hjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:41 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-e5-535cb43cd375
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
Subject: [PATCH v12 19/31] iommu/exynos: change rwlock to spinlock
Date: Sun, 27 Apr 2014 13:07:51 +0530
Message-id: <1398584283-22846-20-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkRtdmS0ywwbznOhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8atHZPZ
	Ci7pVly/08XawPhMtYuRk0NCwERi6+GzLBC2mMSFe+vZuhi5OIQEljJKzOnrYoMpOjvpGBNE
	YhGjxIPvu5khnAlMEpcfrASrYhMwlNh+7worSEJEYDWjRN/FM+wgDrPAXSaJOaveMXYxcnAI
	CzhJHJ5oC9LAIqAqsa/7GjOIzSvgIfHn7g9mkBIJAQWJOZNsQMKcQOEnd/aAnSck4C7x9tQX
	sPkSAnM5JH4e3MYKMUdA4tvkQywQvbISmw4wQ1wtKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ
	6hUn5haX5qXrJefnbmIExuPpf896dzDePmB9iDEZaNxEZinR5HxgPOeVxBsamxlZmJqYGhuZ
	W5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2P7o5Q5x+0e5Ewv//Y6lf/Y
	jUNzDk26OCFqQvfpM4vnm1++kK1vvqdDuWvuaiUhJ1Ulwedb3ucsnNAcILOlpPnESybR+QbG
	b27zvly/Id76WAH355a0L9kLWPiMPLLFb28z5aqcWr5mj0h4xupNpb6WJ5vmLg2KW69n/eNY
	1f4CyblPMw89kWpVYinOSDTUYi4qTgQA0rGpW90CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV2bLTHBBkenKVrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzbu2YzFZwSbfi+p0u1gbGZ6pdjJwcEgImEmcnHWOCsMUkLtxb
	z9bFyMUhJLCIUeLB993MEM4EJonLD1aygVSxCRhKbL93hRUkISKwmlGi7+IZdhCHWeAuk8Sc
	Ve8Yuxg5OIQFnCQOT7QFaWARUJXY132NGcTmFfCQ+HP3BzNIiYSAgsScSTYgYU6g8JM7e1hA
	bCEBd4m3p76wTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjONqfSe9gXNVgcYhR
	gINRiYf3h3RMsBBrYllxZe4hRgkOZiURXs7pQCHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3O
	ByaivJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgNK3Zs+y7
	tkt99dHsUOWFPXuFUiZ9W7p+y4fCe0ZKAexByxfNvfshMJ6TO5szqOeJ37Hp4dkmuya0iM6I
	vX3xf8o86bnWe7WOdEbcZFVyXdjAUNHE+fOKd/GqrROLKx8qWnw0aV1gr1V388XuNoagw61O
	cg47QlUVrvz+5bEl/sGZi68StwXlKbEUZyQaajEXFScCAJmqDS46AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Since acquiring read_lock is not more frequent than write_lock, it is
not beneficial to use rwlock, this commit changes rwlock to spinlock.

Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c2e6365..c9076e1 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -200,7 +200,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	struct clk *clk_master;
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	bool powered_on;
 	bool suspended;
@@ -323,12 +323,13 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	unsigned long addr = -1;
 	int ret = -ENOSYS;
 
-	read_lock(&data->lock);
-
 	WARN_ON(!is_sysmmu_active(data));
 
+	spin_lock(&data->lock);
+
 	if (!IS_ERR(data->clk_master))
 		clk_enable(data->clk_master);
+
 	itype = (enum exynos_sysmmu_inttype)
 		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
 	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -362,7 +363,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (!IS_ERR(data->clk_master))
 		clk_disable(data->clk_master);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 
 	return IRQ_HANDLED;
 }
@@ -385,7 +386,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	disabled = set_sysmmu_inactive(data);
 
@@ -402,7 +403,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 					data->activations);
 	}
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return disabled;
 }
@@ -452,7 +453,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	int ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (set_sysmmu_active(data)) {
 		data->pgtable = pgtable;
 		data->domain = domain;
@@ -470,7 +471,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	if (WARN_ON(ret < 0))
 		set_sysmmu_inactive(data); /* decrement count */
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -557,7 +558,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
-		read_lock(&data->lock);
+		spin_lock(&data->lock);
 		if (is_sysmmu_active(data) && data->powered_on) {
 			unsigned int num_inv = 1;
 
@@ -592,7 +593,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 				iova);
 		}
 
-		read_unlock(&data->lock);
+		spin_unlock(&data->lock);
 	}
 
 	spin_unlock_irqrestore(&owner->lock, flags);
@@ -608,7 +609,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
-		read_lock(&data->lock);
+		spin_lock(&data->lock);
 		if (is_sysmmu_active(data) && data->powered_on) {
 			if (!IS_ERR(data->clk_master))
 				clk_enable(data->clk_master);
@@ -621,7 +622,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		} else {
 			dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 		}
-		read_unlock(&data->lock);
+		spin_unlock(&data->lock);
 	}
 
 	spin_unlock_irqrestore(&owner->lock, flags);
@@ -813,7 +814,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	if (!ret) {
 		data->powered_on = !pm_runtime_enabled(dev);
 		data->sysmmu = dev;
-		rwlock_init(&data->lock);
+		spin_lock_init(&data->lock);
 
 		platform_set_drvdata(pdev, data);
 	}
@@ -1264,12 +1265,12 @@ static int sysmmu_pm_genpd_suspend(struct device *dev)
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
 		unsigned long flags;
-		write_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (!data->suspended && is_sysmmu_active(data) &&
 			(!pm_runtime_enabled(dev) || data->powered_on))
 			__sysmmu_disable_nocount(data);
 		data->suspended = true;
-		write_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 
 	return 0;
@@ -1282,12 +1283,12 @@ static int sysmmu_pm_genpd_resume(struct device *dev)
 	for_each_sysmmu_list(dev, list) {
 		struct sysmmu_drvdata *data = dev_get_drvdata(list->sysmmu);
 		unsigned long flags;
-		write_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (data->suspended && is_sysmmu_active(data) &&
 			(!pm_runtime_enabled(dev) || data->powered_on))
 			__sysmmu_enable_nocount(data);
 		data->suspended = false;
-		write_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 
 	return pm_generic_resume(dev);
@@ -1439,12 +1440,12 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
 					dev_get_drvdata(list->sysmmu);
 			unsigned long flags;
 
-			write_lock_irqsave(&data->lock, flags);
+			spin_lock_irqsave(&data->lock, flags);
 			if (is_sysmmu_active(data) && !data->powered_on)
 				__sysmmu_enable_nocount(data);
 			data->powered_on = true;
 			pm_runtime_disable(data->sysmmu);
-			write_unlock_irqrestore(&data->lock, flags);
+			spin_unlock_irqrestore(&data->lock, flags);
 		}
 		break;
 	}
-- 
1.7.9.5

