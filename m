Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaCNFJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:09:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51923 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbaCNFJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:09:46 -0400
X-AuditID: cbfee690-b7f266d00000287c-23-53228f1867d0
Date: Fri, 14 Mar 2014 14:09:44 +0900
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
Subject: [PATCH v11 14/27] iommu/exynos: gating clocks of master H/W
Message-id: <20140314140944.ebab0ec5997424ab7034d566@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zI12JfqVgg73brCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mo4+2w6Y8EE+YqmJ1kNjEcluxg5OSQETCR+P9nHAmGL
	SVy4t56ti5GLQ0hgGaPE5/9LmGGK/l2/xgyRmM4osfDOWRYIZzKTRPuJ66wgVSwCqhKfzl8A
	s9kEtCRWzz3OCFIkItDGJPG18RBYB7PAXGaJj9/msIFUCQu4SHSvuMkOYvMKOEpc3H2CFWKf
	hcSFpg6ouKDEj8n3wA5kBpq6eVsTK4QtL7F5zVuwmyQEOjkkrjYcZoM4Q0Di22SQbRxACVmJ
	TQegfpCUOLjiBssERpFZSMbOQjJ2FpKxCxiZVzGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKE
	xO+EHYz3DlgfYkwGWjmRWUo0OR8Y/3kl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwFhe/jBWma1ncsGrCD91u9/62XKr1KYtvfZcrv7h3mWHfGTs
	t0+Y2JsQqcCvxXy3Z//3nLxEr2+vquoOsQsGsl5U/BqtFrtw5tEpKpfCk/62NRvV3ZO3XJIc
	csjq1YQCnStH6xXb7f7Mmm3xXf1v71U10Y3h/1ZJplx0kV3fzSdaOKVyHU+ErxJLcUaioRZz
	UXEiAHK9s1X1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQV2JfqVgg9azJhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gB9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOPtsOmPBBPmK
	pidZDYxHJbsYOTkkBEwk/l2/xgxhi0lcuLeerYuRi0NIYDqjxMI7Z1kgnMlMEu0nrrOCVLEI
	qEp8On8BzGYT0JJYPfc4I0iRiEAbk8TXxkNgHcwCc5klPn6bwwZSJSzgItG94iY7iM0r4Chx
	cfcJVoh9FhIXmjqg4oISPybfYwGxmYGmbt7WxAphy0tsXvOWeQIj3ywkZbOQlM1CUraAkXkV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnByeCa9g3FVg8UhRgEORiUe3hlHFYOFWBPLiitz
	DzFKcDArifBWRSgFC/GmJFZWpRblxxeV5qQWH2JMBvp7IrOUaHI+MHHllcQbGpuYGVkamVkY
	mZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjzq/UtpBeKd2wssXbNeY6bvvtOtco
	gnPzwyq7jRVrOXRLmtU8/2uLPFro6OkV89ilx3Tz+wkxypt3dimJmE4xlVmx0uhFsFIOK9+B
	E169DXoqVi+WL08NZHBZuW3FWu5enxj7rBv1O11nrXCNsdqXybvmwIurhlYzvA9PKkqI2rrm
	SfLKKUpKLMUZiYZazEXFiQAGPKZNUgMAAA==
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

CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 34feb04..71e77f1 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -173,6 +173,7 @@ struct sysmmu_drvdata {
 	struct device *dev;	/* Owner of system MMU */
 	void __iomem *sfrbase;
 	struct clk *clk;
+	struct clk *clk_master;
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
@@ -301,6 +302,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	WARN_ON(!is_sysmmu_active(data));
 
+	clk_enable(data->clk_master);
 	itype = (enum exynos_sysmmu_inttype)
 		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
 	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -327,6 +329,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbase);
 
+	clk_disable(data->clk_master);
+
 	read_unlock(&data->lock);
 
 	return IRQ_HANDLED;
@@ -342,10 +346,12 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	if (!set_sysmmu_inactive(data))
 		goto finish;
 
+	clk_enable(data->clk_master);
+
 	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
 
-	if (data->clk)
-		clk_disable(data->clk);
+	clk_disable(data->clk);
+	clk_disable(data->clk_master);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -388,15 +394,17 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		goto finish;
 	}
 
-	if (data->clk)
-		clk_enable(data->clk);
-
 	data->pgtable = pgtable;
 
+	clk_enable(data->clk_master);
+	clk_enable(data->clk);
+
 	__sysmmu_set_ptbase(data->sfrbase, pgtable);
 
 	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
 
+	clk_disable(data->clk_master);
+
 	data->domain = domain;
 
 	dev_dbg(data->sysmmu, "Enabled\n");
@@ -453,6 +461,9 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 	if (is_sysmmu_active(data)) {
 		unsigned int maj;
 		unsigned int num_inv = 1;
+
+		clk_enable(data->clk_master);
+
 		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
 		/*
 		 * L2TLB invalidation required
@@ -472,6 +483,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 							num_inv);
 			sysmmu_unblock(data->sfrbase);
 		}
+		clk_disable(data->clk_master);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
@@ -487,10 +499,12 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
+		clk_enable(data->clk_master);
 		if (sysmmu_block(data->sfrbase)) {
 			__sysmmu_tlb_invalidate(data->sfrbase);
 			sysmmu_unblock(data->sfrbase);
 		}
+		clk_disable(data->clk_master);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
@@ -544,6 +558,17 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
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
 	data->sysmmu = dev;
 	rwlock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
-- 
1.7.9.5

