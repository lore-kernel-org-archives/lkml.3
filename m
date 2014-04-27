Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaD0HkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57763 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaD0HjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:03 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-04-535cb415b5b5
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
Subject: [PATCH v12 05/31] iommu/exynos: remove prefetch buffer setting
Date: Sun, 27 Apr 2014 13:07:37 +0530
Message-id: <1398584283-22846-6-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkRld0S0ywweHF2hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8buL5fZ
	Cp7wVdw78oOlgbGPp4uRk0NCwERi+sZdLBC2mMSFe+vZuhi5OIQEljJKrNzWxQpTNOPUIXaI
	xCJGiSmvpjJBOBOYJP42LmACqWITMJTYfu8KK0hCRGA1o0TfxTNgLcwCd5kk5qx6xwhSJSzg
	LtE14R9QBwcHi4CqxJKHYM28QOGXjdfZQMISAgoScybZgIQ5BTwkntzZA3aeEFDJ21NfoC6a
	ySGx93QUiM0iICDxbfIhFohWWYlNB5ghSiQlDq64wTKBUXgBI8MqRtHUguSC4qT0ImO94sTc
	4tK8dL3k/NxNjMBoPP3vWf8OxrsHrA8xJgONm8gsJZqcD4zmvJJ4Q2MzIwtTE1NjI3NLM9KE
	lcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyKKxYMGnIy8m7Cn75bo6Qm/1xtfT
	nswI7bp9Lrx/nzgv859rP75phiwrvdq/alFxpt2k0y1XukoCop/p/fmTfMC13uDEMRuBLH/X
	/1YRzVpuMlHfWz+3bt0SN2H6jPfp6kVzX8sGrAvylVm1QOj8lktd79NOV32xEwnV/Hj+3Gef
	9MXbr99ff0yJpTgj0VCLuag4EQAdC4yv3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3RLTHBBr9OKFjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzdn+5zFbwhK/i3pEfLA2MfTxdjJwcEgImEjNOHWKHsMUkLtxb
	z9bFyMUhJLCIUWLKq6lMEM4EJom/jQuYQKrYBAwltt+7wgqSEBFYzSjRd/EMO4jDLHCXSWLO
	qneMIFXCAu4SXRP+AXVwcLAIqEoseQjWzAsUftl4nQ0kLCGgIDFnkg1ImFPAQ+LJnT0sILYQ
	UMnbU19YJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHO3PpHcwrmqwOMQowMGo
	xMP7QzomWIg1say4MvcQowQHs5IIL+d0oBBvSmJlVWpRfnxRaU5q8SHGZKCbJjJLiSbnAxNR
	Xkm8obGJuamxqaWJhYmZJWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwrpq6betKy/3n
	nwqL60v2ah/taunW8GV9dFR3v7hHqdzqA0zLZb5lLvk0exHnZb4vrJlPigVkuV8XagQqrwz2
	KnZUmdEZousXaRi85K7YK4s16Q6Onh/bLt6IY+J4rTWrSUnsNm9BQ4fbxibr/zOETLUX6WtL
	2Bbu7P5+L+yu/gcOsSwPjv1KLMUZiYZazEXFiQBDsSq1OgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Prefetch buffer is a cache of System MMU 3.x and caches a block of
page table entries to make effect of larger page with small pages.
However, how to control prefetch buffers and the specifications of
prefetch buffers different from minor versions of System MMU v3.
Prefetch buffers must be controled with care because there are some
restrictions in H/W design.

The interface and implementation to initiate prefetch buffers will
be prepared later.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7ce44a8..7556177 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -243,13 +243,6 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 	__sysmmu_tlb_invalidate(sfrbase);
 }
 
-static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
-						unsigned long size, int idx)
-{
-	__raw_writel(base, sfrbase + REG_PB0_SADDR + idx * 8);
-	__raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
-}
-
 static void __set_fault_handler(struct sysmmu_drvdata *data,
 					sysmmu_fault_handler_t handler)
 {
@@ -423,15 +416,6 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	for (i = 0; i < data->nsfrs; i++) {
 		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
-
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
-					data->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
-		}
-
 		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
 	}
 
-- 
1.7.9.5

