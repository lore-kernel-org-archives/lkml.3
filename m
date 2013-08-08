Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959Ab3HHJlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:41:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41255 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab3HHJlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:41:40 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-68-520367d33530
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
Subject: [PATCH v9 15/16] iommu/exynos: change rwlock to spinlock
Date: Thu, 08 Aug 2013 18:41:39 +0900
Message-id: <003301ce941b$7b4fd3a0$71ef7ae0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF8JBa1cRarXLRx+c9/G/OEm8jg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zvu7ldOYgg9WTNCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUVw2Kak5mWWpRfp2CVwZ797OZS5o16o4fiS5gfG7UhcjJ4eEgInE/1+nWSFsMYkL99az
	dTFycQgJLGOU6Hn8jwmmaNbMY8wQiemMEj/ntkNV/WWUmDL1GTNIFZuAlsTquccZQRIiAr8Z
	JW49m8MK4jAL/GeS2Hq7iR2kSljAUWJG9xMWEJtFQFXi8OXXYDavgKXE9Cnf2SFsQYkfk++B
	xZmBpq7feZwJwpaX2LzmLTPETQoSO86+ZgSxRQT0JJ4cPgZVIyKx78U7sCskBOZySOyc+4cJ
	YpmAxLfJh4CGcgAlZCU2HYCaIylxcMUNlgmMYrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFS
	epGJXnFibnFpXrpecn7uJkZI9E/YwXjvgPUhxmSg9ROZpUST84HJI68k3tDYzMjC1MTU2Mjc
	0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjHqNuusdMzvqGr9/yz82s9db
	2qwya3PMqnshc385qp5+MW/1Hof1D2bcOdqxlHlXycPyqe/v5x8PmVH6IKKIndPBV1L0xPmL
	SzdtZ1okbsBufYLd7pSPUmiqVuysm2YeO4+czb282XndaaW9Avff9M5ZMDnAmuFB27yEhK0H
	9T4LqnEdskis/qHEUpyRaKjFXFScCACmyZF3FAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jQd3L6cxBBisXKlvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZrx7O5e5oF2r4viR5AbG
	70pdjJwcEgImErNmHmOGsMUkLtxbz9bFyMUhJDCdUeLn3HYo5y+jxJSpz8Cq2AS0JFbPPc4I
	khAR+M0ocevZHFYQh1ngP5PE1ttN7CBVwgKOEjO6n7CA2CwCqhKHL78Gs3kFLCWmT/nODmEL
	SvyYfA8szgw0df3O40wQtrzE5jVvoW5SkNhx9jUjiC0ioCfx5PAxqBoRiX0v3jFOYBSYhWTU
	LCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwanlmdQOxpUNFocYBTgY
	lXh4OwKYgoRYE8uKK3MPMUpwMCuJ8F4sBgrxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDt
	5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD48Lmx+vWPwiQ
	Vp/qxynPuczPTHfPl+nsuccNLu7k//XxuanS/yMVL/f9FLeZueb91EOn7nhPZ/+jdqhl219z
	yY3Xlq5K15mp9+sWq3adpO+vW9cW1018YDwtXWzLu83LVh55P6eQ523a9Vv/yk24VI/vuZR/
	PcB/zb+6f9IHiy33ch/3UHFXkN2nxFKckWioxVxUnAgASRlBUnEDAAA=
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
 drivers/iommu/exynos-iommu.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 56aead9..2d16fc0 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -185,7 +185,7 @@ struct sysmmu_drvdata {
 	struct clk *clk;
 	struct clk *clk_master;
 	int activations;
-	rwlock_t lock;
+	spinlock_t lock;
 	struct iommu_domain *domain;
 	bool runtime_active;
 	unsigned long pgtable;
@@ -285,7 +285,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 	BUG_ON((base0 + size0) <= base0);
 	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
 
-	read_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (!is_sysmmu_active(data))
 		goto finish;
 
@@ -319,7 +319,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 
 	clk_disable(data->clk_master);
 finish:
-	read_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void show_fault_information(const char *name,
@@ -372,7 +372,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	clk_enable(data->clk_master);
 	if (client)
 		spin_lock(&client->lock);
-	read_lock(&data->lock);
+	spin_lock(&data->lock);
 
 	if (i == data->nsfrs) {
 		itype = SYSMMU_FAULT_UNKNOWN;
@@ -405,7 +405,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	clk_disable(data->clk_master);
 
-	read_unlock(&data->lock);
+	spin_unlock(&data->lock);
 	if (client)
 		spin_unlock(&client->lock);
 
@@ -432,7 +432,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 	bool disabled;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 
 	disabled = set_sysmmu_inactive(data);
 
@@ -449,7 +449,7 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
 					data->activations);
 	}
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return disabled;
 }
@@ -503,7 +503,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	int ret = 0;
 	unsigned long flags;
 
-	write_lock_irqsave(&data->lock, flags);
+	spin_lock_irqsave(&data->lock, flags);
 	if (set_sysmmu_active(data)) {
 		data->pgtable = pgtable;
 		data->domain = domain;
@@ -521,7 +521,7 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	if (WARN_ON(ret < 0))
 		set_sysmmu_inactive(data); /* decrement count */
 
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&data->lock, flags);
 
 	return ret;
 }
@@ -612,7 +612,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 
 		data = dev_get_drvdata(client->sysmmu[i]);
 
-		read_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (is_sysmmu_active(data) && data->runtime_active) {
 			int i;
 			clk_enable(data->clk_master);
@@ -625,7 +625,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 				"disabled. Skipping TLB invalidation @ %#lx\n",
 				iova);
 		}
-		read_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 }
 
@@ -640,7 +640,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 		data = dev_get_drvdata(client->sysmmu[i]);
 
-		read_lock_irqsave(&data->lock, flags);
+		spin_lock_irqsave(&data->lock, flags);
 		if (is_sysmmu_active(data) &&
 				data->runtime_active) {
 			int i;
@@ -656,7 +656,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		} else {
 			dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
 		}
-		read_unlock_irqrestore(&data->lock, flags);
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
 }
 
@@ -745,7 +745,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	data->runtime_active = !pm_runtime_enabled(dev);
 
-	rwlock_init(&data->lock);
+	spin_lock_init(&data->lock);
 
 	platform_set_drvdata(pdev, data);
 	dev_dbg(dev, "Probed and initialized\n");
@@ -758,11 +758,11 @@ static int sysmmu_suspend(struct device *dev)
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
 
@@ -770,11 +770,11 @@ static int sysmmu_resume(struct device *dev)
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


