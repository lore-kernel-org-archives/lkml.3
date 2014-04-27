Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaD0Hk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31149 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaD0HjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:25 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-50-535cb42b844f
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
Subject: [PATCH v12 13/31] iommu/exynos: gating clocks of master H/W
Date: Sun, 27 Apr 2014 13:07:45 +0530
Message-id: <1398584283-22846-14-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkVldnS0ywweE5TBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV0bP7gts
	BScUK2avbGZvYDwt3cXIySEhYCJxas8qNghbTOLCvfVgtpDAUkaJnqO2MDXTt4LUcAHFFzFK
	rDp2nwnCmcAksX79GUaQKjYBQ4nt966wgiREBFYzSvRdPMMO4jAL3GWSmLPqHViVsICLxJTp
	M5lAbBYBVYkJ528D2RwcvAIeEvdOc4CYEgIKEnMm2YBUcAJFn9zZwwJxkbvE21NfwOZLCMzk
	kDi4/RMbxBgBiW+TD7FA9MpKbDrADHG1pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtc
	mpeul5yfu4kRGI2n/z2buIPx/gHrQ4zJQOMmMkuJJucDozmvJN7Q2MzIwtTE1NjI3NKMNGEl
	cd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjtK2cmqGWtOy7ivPj8nqMlHnsf+R92
	KtZ8/DiESbnQa0Pa00z91LsGomKfnjE9+l1qpJ8Sa6Ex2fCBAtvHy/GbrWXqP+sU/1mxNC1s
	292aiH1CrskanoG7pbwKdEqtW72lHj+VNdlgMTeL91Sw/N4jjzvS8pzdbu34Pm2Fv0915v/1
	M6XkVZRYijMSDbWYi4oTATfoptbcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3tLTHBBjs7TSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWh9+0s1qc/NPLaNFyvZfJYv2M1ywWq3b9YbSYeWsNi4Owx5OD85g8ZjdcZPH4d7ifyWPn
	rLvsHneu7WHz2Lyk3mPyjeWMHn1bVjF6fN4k53Hl6BmmAK6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDXlBTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZPbsvsBWcUKyYvbKZvYHxtHQXIyeHhICJxPStq9ggbDGJC/fW
	A9lcHEICixglVh27zwThTGCSWL/+DCNIFZuAocT2e1dYQRIiAqsZJfounmEHcZgF7jJJzFn1
	DqxKWMBFYsr0mUwgNouAqsSE87eBbA4OXgEPiXunOUBMCQEFiTmTbEAqOIGiT+7sYQGxhQTc
	Jd6e+sI6gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgaH8mvYNxVYPFIUYBDkYl
	Ht4f0jHBQqyJZcWVuYcYJTiYlUR4OacDhXhTEiurUovy44tKc1KLDzEmA900kVlKNDkfmIjy
	SuINjU3MTY1NLU0sTMwsSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGRs8FnQZvXM7sa
	oTfzKkVWzmyPtve1vHg4X2HSpTnNPy+stKveMDlUVPQRp8O8W6EZfeeXLPga93OudmTn1ar9
	Ss3Zd5N5d33/I7ZixbTdTEwvljiI8dzf4nFo9UbJKzMXLmi7I1E7L3f6WsWiorfzbUUT9Pue
	b8hmmKQw+ep6/zuLTjl/f/bguxJLcUaioRZzUXEiAPdbj2g6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch gates clocks of master H/W as well as clocks of System MMU
if master clocks are specified.

Some Exynos SoCs (i.e. GScalers in Exynos5250) have dependencies in
the gating clocks of master H/W and its System MMU. If a H/W is the
case, accessing control registers of System MMU is prohibited unless
both of the gating clocks of System MMU and its master H/W.

CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index cbb9b67..ba477c4 100755
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -172,6 +172,7 @@ struct sysmmu_drvdata {
 	struct device *dev;	/* Owner of system MMU */
 	void __iomem *sfrbase;
 	struct clk *clk;
+	struct clk *clk_master;
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
@@ -300,6 +301,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	WARN_ON(!is_sysmmu_active(data));
 
+	if (!IS_ERR(data->clk_master))
+		clk_enable(data->clk_master);
 	itype = (enum exynos_sysmmu_inttype)
 		__ffs(__raw_readl(data->sfrbase + REG_INT_STATUS));
 	if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -326,6 +329,9 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbase);
 
+	if (!IS_ERR(data->clk_master))
+		clk_disable(data->clk_master);
+
 	read_unlock(&data->lock);
 
 	return IRQ_HANDLED;
@@ -341,9 +347,14 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	if (!set_sysmmu_inactive(data))
 		goto finish;
 
+	if (!IS_ERR(data->clk_master))
+		clk_enable(data->clk_master);
+
 	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
 
 	clk_disable(data->clk);
+	if (!IS_ERR(data->clk_master))
+		clk_disable(data->clk_master);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -386,14 +397,19 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 		goto finish;
 	}
 
-	clk_enable(data->clk);
-
 	data->pgtable = pgtable;
 
+	if (!IS_ERR(data->clk_master))
+		clk_enable(data->clk_master);
+	clk_enable(data->clk);
+
 	__sysmmu_set_ptbase(data->sfrbase, pgtable);
 
 	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
 
+	if (!IS_ERR(data->clk_master))
+		clk_disable(data->clk_master);
+
 	data->domain = domain;
 
 	dev_dbg(data->sysmmu, "Enabled\n");
@@ -450,6 +466,10 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 	if (is_sysmmu_active(data)) {
 		unsigned int maj;
 		unsigned int num_inv = 1;
+
+		if (!IS_ERR(data->clk_master))
+			clk_enable(data->clk_master);
+
 		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
 		/*
 		 * L2TLB invalidation required
@@ -469,6 +489,8 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
 							num_inv);
 			sysmmu_unblock(data->sfrbase);
 		}
+		if (!IS_ERR(data->clk_master))
+			clk_disable(data->clk_master);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
@@ -484,10 +506,14 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_lock_irqsave(&data->lock, flags);
 
 	if (is_sysmmu_active(data)) {
+		if (!IS_ERR(data->clk_master))
+			clk_enable(data->clk_master);
 		if (sysmmu_block(data->sfrbase)) {
 			__sysmmu_tlb_invalidate(data->sfrbase);
 			sysmmu_unblock(data->sfrbase);
 		}
+		if (!IS_ERR(data->clk_master))
+			clk_disable(data->clk_master);
 	} else {
 		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
 	}
@@ -536,6 +562,16 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		}
 	}
 
+	data->clk_master = devm_clk_get(dev, "master");
+	if (!IS_ERR(data->clk_master)) {
+		ret = clk_prepare(data->clk_master);
+		if (ret) {
+			clk_unprepare(data->clk);
+			dev_err(dev, "Failed to prepare master's clk\n");
+			return ret;
+		}
+	}
+
 	data->sysmmu = dev;
 	rwlock_init(&data->lock);
 	INIT_LIST_HEAD(&data->node);
-- 
1.7.9.5

