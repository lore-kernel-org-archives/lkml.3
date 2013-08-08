Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab3HHJjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:39:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28876 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833Ab3HHJjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:39:19 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-78-5203673a2f1b
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
Subject: [PATCH v9 08/16] iommu/exynos: gating clocks of master H/W
Date: Thu, 08 Aug 2013 18:39:05 +0900
Message-id: <002c01ce941b$1fd0ab80$5f720280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF463hy6MY5CQQ4e4jS9YdPDSWw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zga5VOnOQwYrzXBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TA58Hk8OzmPymN1wkcXjzrU9bB7nN61h9ti8pN5j8o3ljB59W1YxenzeJOdx5egZ
	pgDOKC6blNSczLLUIn27BK6MU113WQp2KVf0bZrG3MB4Q6aLkZNDQsBEovnhHUYIW0ziwr31
	bF2MXBxCAssYJTYvf8gIU3Tl0zc2EFtIYBGjRNfsPIiiv4wSv7cuAytiE9CSWD33OCNIQkTg
	N6PErWdzWEEcZoH/TBJbbzexdzFycAgLOEvs7IsBaWARUJVonD+RFcTmFbCUmNC3ig3CFpT4
	MfkeC4jNDDR0/c7jTBC2vMTmNW+ZIS5SkNhx9jXYYhEBPYlX/acYIWpEJPa9eAd2hITAQg6J
	WzvOsUAsE5D4NvkQC8gNEgKyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1
	ILmgOCm9yFCvODG3uDQvXS85P3cTIyT2e3cw3j5gfYgxGWj9RGYp0eR8YOrIK4k3NDYzsjA1
	MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjyvNWr15lTK7kUdzx
	U+X9+uDCJ/9qxNeJtt/qvsVd66GzbXuM0t5zkRlb1njNX5IZYR7ml6GT9ThP3JKHSVfesqV0
	0tJdIn+Zj3/YnDctdJ6uv/bBnto0DS/urHlWYScYpsq3uGYwGvz7IFrRGxjIvuFRtYqz9rqM
	1ZK+dsbTz0VNlT5RekeJpTgj0VCLuag4EQBdW3xEEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAV2rdOYgg0NvWCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mRz4PJ4cnMfkMbvhIovHnWt72DzOb1rD7LF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEz
	TAGcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	xysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM0513WUp2KVc0bdpGnMD
	4w2ZLkZODgkBE4krn76xQdhiEhfurQezhQQWMUp0zc7rYuQCsv8ySvzeuowRJMEmoCWxeu5x
	RpCEiMBvRolbz+awgjjMAv+ZJLbebmLvYuTgEBZwltjZFwPSwCKgKtE4fyIriM0rYCkxoW8V
	G4QtKPFj8j0WEJsZaOj6nceZIGx5ic1r3jJDXKQgsePsa7DFIgJ6Eq/6TzFC1IhI7HvxjnEC
	o8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITizPpHYwrmyw
	OMQowMGoxMPbEcAUJMSaWFZcmXuIUYKDWUmE92IxUIg3JbGyKrUoP76oNCe1+BBjMtCnE5ml
	RJPzgUkvryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYF9VP
	XfbyUd9TgeWLAuIP9V06Fefa4t36zeqM9gE2x3557phjPya/qJu9xlK7bfmX26L6/BN+nP2n
	foT1Iu8l6a8WRdxZShx/56bue/L8zy2+qfliHuJTa5zSby9nYjDNFjDeG3/k4h/9c3d3Kv57
	uW0Tq4bVAb70+3bHdMV/lbCKXrjeGSo7QYmlOCPRUIu5qDgRAJppZCZwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gates clocks of master H/W as well as clocks of System MMU
if master clocks are specified.

Some Exynos SoCs (i.e. GScalers in Exynos5250) have dependencies in
the gating clocks of master H/W and its System MMU. If a H/W is the
case, accessing control registers of System MMU is prohibited unless
both of the gating clocks of System MMU and its master H/W.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0ee73e8..005a7ed 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -173,6 +173,7 @@ struct sysmmu_drvdata {
 	struct device *dev;	/* Owner of system MMU */
 	int nsfrs;
 	struct clk *clk;
+	struct clk *clk_master;
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
@@ -263,6 +264,8 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 	if (!is_sysmmu_active(data))
 		goto finish;
 
+	clk_enable(data->clk_master);
+
 	for (i = 0; i < data->nsfrs; i++) {
 		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
 			if (!sysmmu_block(data->sfrbases[i]))
@@ -288,6 +291,8 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 			sysmmu_unblock(data->sfrbases[i]);
 		}
 	}
+
+	clk_disable(data->clk_master);
 finish:
 	read_unlock_irqrestore(&data->lock, flags);
 }
@@ -358,6 +363,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 			break;
 	}
 
+	clk_enable(data->clk_master);
+
 	if (i == pdev->num_resources) {
 		itype = SYSMMU_FAULT_UNKNOWN;
 	} else {
@@ -391,6 +398,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbases[i]);
 
+	clk_disable(data->clk_master);
+
 	read_unlock(&data->lock);
 
 	return IRQ_HANDLED;
@@ -407,11 +416,14 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	if (!set_sysmmu_inactive(data))
 		goto finish;
 
+	clk_enable(data->clk_master);
+
 	for (i = 0; i < data->nsfrs; i++)
 		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
 
-	if (data->clk)
-		clk_disable(data->clk);
+	clk_disable(data->clk_master);
+
+	clk_disable(data->clk);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -454,11 +466,12 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		goto finish;
 	}
 
-	if (data->clk)
-		clk_enable(data->clk);
+	clk_enable(data->clk);
 
 	data->pgtable = pgtable;
 
+	clk_enable(data->clk_master);
+
 	for (i = 0; i < data->nsfrs; i++) {
 		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
 
@@ -473,6 +486,8 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
 	}
 
+	clk_disable(data->clk_master);
+
 	data->domain = domain;
 
 	dev_dbg(data->sysmmu, "Enabled\n");
@@ -528,6 +543,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 
 	if (is_sysmmu_active(data)) {
 		int i;
+		clk_enable(data->clk_master);
 		for (i = 0; i < data->nsfrs; i++) {
 			if (sysmmu_block(data->sfrbases[i])) {
 				__sysmmu_tlb_invalidate_entry(
@@ -535,6 +551,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 				sysmmu_unblock(data->sfrbases[i]);
 			}
 		}
+		clk_disable(data->clk_master);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
@@ -551,12 +568,14 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 
 	if (is_sysmmu_active(data)) {
 		int i;
+		clk_enable(data->clk_master);
 		for (i = 0; i < data->nsfrs; i++) {
 			if (sysmmu_block(data->sfrbases[i])) {
 				__sysmmu_tlb_invalidate(data->sfrbases[i]);
 				sysmmu_unblock(data->sfrbases[i]);
 			}
 		}
+		clk_disable(data->clk_master);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
@@ -637,6 +656,17 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	data->clk_master = devm_clk_get(dev, "master");
+	if (IS_ERR(data->clk_master))
+		data->clk_master = NULL;
+
+	ret = clk_prepare(data->clk_master);
+	if (ret) {
+		clk_unprepare(data->clk);
+		dev_err(dev, "Failed to prepare master's clk\n");
+		return ret;
+	}
+
 	rwlock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
 
-- 
1.7.2.5


