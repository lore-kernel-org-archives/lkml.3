Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaELGQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:16:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25751 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaELGQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:50 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-09-53706750ea8e
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
Subject: [PATCH v13 10/19] iommu/exynos: gating clocks of master H/W
Date: Mon, 12 May 2014 11:44:55 +0530
Message-id: <1399875304-19948-11-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkVjcgvSDY4P8NS4s7d8+xWvyddIzd
	Yv4RIOvVkR9MFgv2W1t0zt7AbvF91xd2i94FV9ksNj2+xmpxedccNosZ5/cxWVxYsZHd4l/v
	QUaLKYsOs1ocftPOanHyTy+jxZGHu9ktWq73Mlmsn/GaxWLVrj+MFjNvrWFxEPV4cnAek8fv
	X5MYPWY3XGTx+He4n8lj56y77B53ru1h89i8pN5j8o3ljB59W1YxenzeJOdx5egZpgDuKC6b
	lNSczLLUIn27BK6M54vnMxX0K1Xcb1/K2MDYJ9PFyMkhIWAi8bhvEQuELSZx4d56ti5GLg4h
	gaWMEoveL2aDKXpx+jEzRGIRo8TeBVcZIZwJTBI757xiB6liEzCU2H7vCitIQkRgNaNE38Uz
	7CAOs8BsZokjjxYzglQJC7hIXPl/A2wui4CqxJw3e8FsXgEPic07HgM1cADtU5CYM8kGJMwJ
	FP68egpYiZCAu8SxV1fBFkgIbOGQ+DW9D2qOgMS3yYdYIHplJTYdYIY4W1Li4IobLBMYhRcw
	MqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECIzX0/+eTdjBeO+A9SHGZKBxE5mlRJPzgfGe
	VxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mst/F
	vrkV/Je3DjsT9kZf+x1L95Ys97ZXJQzmXVLvH13f1+kv+O7lye8nLrG81Q8Rqk+Mn9eqoHPe
	72+o8Nw/ExsmCj29Yh5zfem/Dx/ncZ6aGb3ufaio6hfx1SrfJ6qJamcpXHx3p/ROT+KBsm2L
	rVtufP33+y+DUmeqkGTkM0ajSHEpw+ViSizFGYmGWsxFxYkAAy8Gu+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd2A9IJgg/XT9Czu3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZjxfPJ+poF+p4n77UsYGxj6ZLkZO
	DgkBE4kXpx8zQ9hiEhfurWfrYuTiEBJYxCixd8FVRghnApPEzjmv2EGq2AQMJbbfu8IKkhAR
	WM0o0XfxDDuIwywwm1niyKPFjCBVwgIuElf+32ADsVkEVCXmvNkLZvMKeEhs3vEYqIEDaJ+C
	xJxJNiBhTqDw59VTwEqEBNwljr26yjqBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxN
	jOBk8ExqB+PKBotDjAIcjEo8vB8YCoKFWBPLiitzDzFKcDArifB+9AcK8aYkVlalFuXHF5Xm
	pBYfYkwGOmois5Rocj4wUeWVxBsam5ibGptamliYmFmSJqwkznug1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUA6PSmX3mtXMvqCxOf9+kse7g78vSWoFLtDc+Oh5/dGvbtIPPu725z5n/+56524X3
	70LtzUc9218fk2cx+7tkfrvCnQnz6y984j3BvXBjvvgTRl6+sOxNcSFJdud6m2P6YwXUDu5h
	ld3I8S5z+66wT8+uuC+adG8Hx/y7nGLdzl7nlEura8/5Ki1VYinOSDTUYi4qTgQAYPxnX0oD	AAA=
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
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c86e374..5af5c5c 100644
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
 				data->sfrbase, iova, num_inv);
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
@@ -536,6 +562,16 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
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

