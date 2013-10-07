Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3JGB60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:58:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13942 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3JGB6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:58:20 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-df-5252153a0707
Date: Mon, 07 Oct 2013 10:58:18 +0900
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
Subject: [PATCH v10 18/20] iommu/exynos: change rwlock to spinlock
Message-id: <20131007105818.916595496f5fa52c5bf372bf@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zA10r0aAggxM/zS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlXFm12PWgrnqFe+7pzM3MD5S6GLk5JAQMJFo
	2n2bDcIWk7hwbz2QzcUhJLCMUeLnz8lMMEXLDzxmh0gsYpRoXbOcFcKZxCRx7MdhdpAqFgFV
	ia4/21hBbDYBLYnVc48zghSJCLQxSXxtPMQC4jALnGaWWLV7BXMXIweHsICTxMSTBiANvAKO
	EjP7fzNDrLOQuNDUwQ4RF5T4MfkeC4jNDDR087YmVghbXmLzmrfMIDMlBKZySEyfuoEZ4goB
	iW+TQZZxACVkJTYdgJopKXFwxQ2WCYwis5CMnYVk7CwkYxcwMq9iFE0tSC4oTkovMtErTswt
	Ls1L10vOz93ECInkCTsY7x2wPsSYDLRyIrOUaHI+MBHklcQbGpsZWZiamBobmVuakSasJM6r
	3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx5KDAB6eFO+XMF67aPO/KnJ+1KT5dxh+m
	KrXcTbTyN62TNpuuFxmxy9N4861Fu7mkXpRoSWg1+r86YLAs5JKJ2Ek9xtb6t21y/cahlRMf
	c2YssROb82yRz7zICzv7Z/JHvxO86XQ96VLbxbd5p3f9rv695aTrHffiBZLO352OMjOEhGRN
	fmejxFKckWioxVxUnAgAyFktnvoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAV0r0aAgg5u3jCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjzK7H
	rAVz1Sved09nbmB8pNDFyMkhIWAisfzAY3YIW0ziwr31bF2MXBxCAosYJVrXLGeFcCYxSRz7
	cRisikVAVaLrzzZWEJtNQEti9dzjjCBFIgJtTBJfGw+xgDjMAqeZJVbtXsHcxcjBISzgJDHx
	pAFIA6+Ao8TM/t/MEOssJC40dbBDxAUlfky+xwJiMwMN3bytiRXClpfYvOYt8wRGvllIymYh
	KZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOA08Ux6B+OqBotDjAIcjEo8vDvu
	BwYJsSaWFVfmHmKU4GBWEuG9VAcU4k1JrKxKLcqPLyrNSS0+xJgM9PZEZinR5HxgCssriTc0
	NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsZlLX8ypL7YtU122aRl
	vWXmIvslS4IYbf0WybE+/qdf/+NUgsKrWdo8rP4fHC2qFZ6u53jQpVn6bMXy5xx+z97/trFu
	Tng5zyQz7F1ODcvcPd2OiwPO7lw1McpNamf80Z7Ll15smBO28fPfwN/XnKcm8+y9ffdRlktj
	/AqZ7PBbLh+CfM7++vhfiaU4I9FQi7moOBEAPA9Cf1cDAAA=
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
 drivers/iommu/exynos-iommu.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index e48c2fb..26ba554 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -183,7 +183,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	struct clk *clk_master;
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	bool runtime_active;
 	unsigned long pgtable;
@@ -298,11 +298,12 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	unsigned long addr = -1;
 	int ret = -ENOSYS;
 
-	read_lock(&data->lock);
-
 	WARN_ON(!is_sysmmu_active(data));
 
 	clk_enable(data->clk_master);
+
+	spin_lock(&data->lock);
+
 	itype = (enum exynos_sysmmu_inttype)
 		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
 	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -335,7 +336,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	clk_disable(data->clk_master);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 
 	return IRQ_HANDLED;
 }
@@ -356,7 +357,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	disabled = set_sysmmu_inactive(data);
 
@@ -373,7 +374,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 					data->activations);
 	}
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return disabled;
 }
@@ -421,7 +422,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	int ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (set_sysmmu_active(data)) {
 		data->pgtable = pgtable;
 		data->domain = domain;
@@ -439,7 +440,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	if (WARN_ON(ret < 0))
 		set_sysmmu_inactive(data); /* decrement count */
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -503,7 +504,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 
 	data = dev_get_drvdata(client->sysmmu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data) && data->runtime_active) {
 		unsigned int num_inv = 1;
 		/*
@@ -526,7 +527,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 		dev_dbg(dev, "disabled. Skipping TLB invalidation @ %#lx\n",
 			iova);
 	}
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
@@ -537,7 +538,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 	data = dev_get_drvdata(client->sysmmu);
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data) && data->runtime_active) {
 		clk_enable(data->clk_master);
 		if (sysmmu_block(data->sfrbase)) {
@@ -548,7 +549,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	} else {
 		dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 	}
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
@@ -609,7 +610,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	}
 
 	data->sysmmu = dev;
-	rwlock_init(&data->lock);
+	spin_lock_init(&data->lock);
 
 	platform_set_drvdata(pdev, data);
 
@@ -625,11 +626,11 @@ static int sysmmu_suspend(struct device *dev)
 {
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
 	unsigned long flags;
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data) &&
 		(!pm_runtime_enabled(dev) || data->runtime_active))
 		__sysmmu_disable_nocount(data);
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
 
@@ -637,11 +638,11 @@ static int sysmmu_resume(struct device *dev)
 {
 	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
 	unsigned long flags;
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (is_sysmmu_active(data) &&
 		(!pm_runtime_enabled(dev) || data->runtime_active))
 		__sysmmu_enable_nocount(data);
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 	return 0;
 }
 #endif
-- 
1.7.2.5

