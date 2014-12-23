Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaLWHlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:41:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15124 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaLWHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:40:28 -0500
X-AuditID: cbfee68d-f79296d000004278-0e-54991c6a7b60
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, inki.dae@samsung.com,
        cw00.choi@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 2/3] clk: samsung: exynos3250: Use samsung_cmu_register_one()
 to simplify code
Date: Tue, 23 Dec 2014 16:40:22 +0900
Message-id: <1419320423-19228-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
References: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkQDdLZmaIwaN5uhbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtc3jWHzWLG+X1MFk8nXGSzOPymndVi1a4/jA6cHjtn3WX3uHNtD5tH35ZV
	jB6fN8kFsERx2aSk5mSWpRbp2yVwZTyY3sBe8MenYuWOHpYGxpuOXYycHBICJhJTL+xlhbDF
	JC7cW8/WxcjFISSwlFHi19ReRpiiG/O/skAkFjFK7Jz7kgUkISTQxCTx/IkqiM0moCWx/8UN
	oG4ODhEBQ4mbh5RA6pkFzjFKrF3WzwZSIyyQIPGuow1sKIuAqsTK2xvZQWxeAVeJnRN/M0Es
	U5BYtnwm2EWcAm4SP2d+hNoFVPN5LjvIUAmBZewSj6a3MEEMEpD4NvkQC8hiCQFZiU0HmCHm
	SEocXHGDZQKj8AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgQF/+t+z3h2Mtw9YH2IU
	4GBU4uFdcGZGiBBrYllxZe4hRlOgDROZpUST84FxlVcSb2hsZmRhamJqbGRuaaYkzqso9TNY
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+NePsmTNsdnHdi4fI77kWxv6W0sO7cz2sQGTGII
	vvNOPNd/mlzPf6Vo80sTPKtT77lnfFxv55tyO5Y/bt35rXdTprtsZ/G/OuXDFE/9nwamd5q6
	eGykpWW3FVfFdHRNafmzcnkJY8Ka+GtJT82PqD7Q/tTRpaChtfRfMAPPgZ8ejP0WEb8iE5RY
	ijMSDbWYi4oTAXrG/JRzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jAd0smZkhBrNOKFtc//Kc1WLS/Qks
	Fr0LrrJZnG16w25xedccNosZ5/cxWTydcJHN4vCbdlaLVbv+MDpweuycdZfd4861PWwefVtW
	MXp83iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjwfQG9oI/PhUr
	d/SwNDDedOxi5OSQEDCRuDH/KwuELSZx4d56ti5GLg4hgUWMEjvnvgRLCAk0MUk8f6IKYrMJ
	aEnsf3EDqIiDQ0TAUOLmISWQemaBc4wSa5f1s4HUCAskSLzraGMEsVkEVCVW3t7IDmLzCrhK
	7Jz4mwlimYLEsuUzWUFsTgE3iZ8zP0LtAqr5PJd9AiPvAkaGVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjB8fRMegfjqgaLQ4wCHIxKPLwLzswIEWJNLCuuzD3EKMHBrCTC+1J8ZogQb0pi
	ZVVqUX58UWlOavEhRlOgqyYyS4km5wNjPa8k3tDYxMzI0sjc0MLI2FxJnFfJvi1ESCA9sSQ1
	OzW1ILUIpo+Jg1OqgXHuxLafK8/93TX3gVnunRkXNfYqKvdvyE9bfmxPeYX6cS6FXs+bkk5v
	wu2zlBn7WXeuvvUh4EXVxhauM1dv/y5giZWZo3Plo1mPjN+ttlv3s2y/5hV1xipuZeudzT/x
	9gkPodZ9+w6EqDjOVvogseNrm2u6/+yNco0LPQ7aPY9xK9xRfjOk8YwSS3FGoqEWc1FxIgD5
	Qy7FvQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the samsung_cmu_register_one() to simplify complicated code.
for Exynos3250.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c | 217 ++++++++---------------------------
 1 file changed, 47 insertions(+), 170 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index 6e6cca3..cc4c348 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -104,27 +104,6 @@
 #define PWR_CTRL1_USE_CORE1_WFI			(1 << 1)
 #define PWR_CTRL1_USE_CORE0_WFI			(1 << 0)
 
-/* list of PLLs to be registered */
-enum exynos3250_plls {
-	apll, mpll, vpll, upll,
-	nr_plls
-};
-
-/* list of PLLs in DMC block to be registered */
-enum exynos3250_dmc_plls {
-	bpll, epll,
-	nr_dmc_plls
-};
-
-static void __iomem *reg_base;
-static void __iomem *dmc_reg_base;
-
-/*
- * Support for CMU save/restore across system suspends
- */
-#ifdef CONFIG_PM_SLEEP
-static struct samsung_clk_reg_dump *exynos3250_clk_regs;
-
 static unsigned long exynos3250_cmu_clk_regs[] __initdata = {
 	SRC_LEFTBUS,
 	DIV_LEFTBUS,
@@ -195,43 +174,6 @@ static unsigned long exynos3250_cmu_clk_regs[] __initdata = {
 	PWR_CTRL2,
 };
 
-static int exynos3250_clk_suspend(void)
-{
-	samsung_clk_save(reg_base, exynos3250_clk_regs,
-				ARRAY_SIZE(exynos3250_cmu_clk_regs));
-	return 0;
-}
-
-static void exynos3250_clk_resume(void)
-{
-	samsung_clk_restore(reg_base, exynos3250_clk_regs,
-				ARRAY_SIZE(exynos3250_cmu_clk_regs));
-}
-
-static struct syscore_ops exynos3250_clk_syscore_ops = {
-	.suspend = exynos3250_clk_suspend,
-	.resume = exynos3250_clk_resume,
-};
-
-static void exynos3250_clk_sleep_init(void)
-{
-	exynos3250_clk_regs =
-		samsung_clk_alloc_reg_dump(exynos3250_cmu_clk_regs,
-					   ARRAY_SIZE(exynos3250_cmu_clk_regs));
-	if (!exynos3250_clk_regs) {
-		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
-		goto err;
-	}
-
-	register_syscore_ops(&exynos3250_clk_syscore_ops);
-	return;
-err:
-	kfree(exynos3250_clk_regs);
-}
-#else
-static inline void exynos3250_clk_sleep_init(void) { }
-#endif
-
 /* list of all parent clock list */
 PNAME(mout_vpllsrc_p)		= { "fin_pll", };
 
@@ -782,18 +724,18 @@ static struct samsung_pll_rate_table exynos3250_vpll_rates[] = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_clock exynos3250_plls[nr_plls] __initdata = {
-	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
-			APLL_LOCK, APLL_CON0, NULL),
-	[mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
-			MPLL_LOCK, MPLL_CON0, NULL),
-	[vpll] = PLL(pll_36xx, CLK_FOUT_VPLL, "fout_vpll", "fin_pll",
-			VPLL_LOCK, VPLL_CON0, NULL),
-	[upll] = PLL(pll_35xx, CLK_FOUT_UPLL, "fout_upll", "fin_pll",
-			UPLL_LOCK, UPLL_CON0, NULL),
+static struct samsung_pll_clock exynos3250_plls[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
+		APLL_LOCK, APLL_CON0, exynos3250_pll_rates),
+	PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
+			MPLL_LOCK, MPLL_CON0, exynos3250_pll_rates),
+	PLL(pll_36xx, CLK_FOUT_VPLL, "fout_vpll", "fin_pll",
+			VPLL_LOCK, VPLL_CON0, exynos3250_vpll_rates),
+	PLL(pll_35xx, CLK_FOUT_UPLL, "fout_upll", "fin_pll",
+			UPLL_LOCK, UPLL_CON0, exynos3250_pll_rates),
 };
 
-static void __init exynos3_core_down_clock(void)
+static void __init exynos3_core_down_clock(void __iomem *reg_base)
 {
 	unsigned int tmp;
 
@@ -814,38 +756,31 @@ static void __init exynos3_core_down_clock(void)
 	__raw_writel(0x0, reg_base + PWR_CTRL2);
 }
 
+static struct samsung_cmu_info cmu_info __initdata = {
+	.pll_clks		= exynos3250_plls,
+	.nr_pll_clks		= ARRAY_SIZE(exynos3250_plls),
+	.mux_clks		= mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(mux_clks),
+	.div_clks		= div_clks,
+	.nr_div_clks		= ARRAY_SIZE(div_clks),
+	.gate_clks		= gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(gate_clks),
+	.fixed_factor_clks	= fixed_factor_clks,
+	.nr_fixed_factor_clks	= ARRAY_SIZE(fixed_factor_clks),
+	.nr_clk_ids		= CLK_NR_CLKS,
+	.clk_regs		= exynos3250_cmu_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(exynos3250_cmu_clk_regs),
+};
+
 static void __init exynos3250_cmu_init(struct device_node *np)
 {
 	struct samsung_clk_provider *ctx;
 
-	reg_base = of_iomap(np, 0);
-	if (!reg_base)
-		panic("%s: failed to map registers\n", __func__);
-
-	ctx = samsung_clk_init(np, reg_base, CLK_NR_CLKS);
+	ctx = samsung_cmu_register_one(np, &cmu_info);
 	if (!ctx)
-		panic("%s: unable to allocate context.\n", __func__);
-
-	samsung_clk_register_fixed_factor(ctx, fixed_factor_clks,
-					  ARRAY_SIZE(fixed_factor_clks));
-
-	exynos3250_plls[apll].rate_table = exynos3250_pll_rates;
-	exynos3250_plls[mpll].rate_table = exynos3250_pll_rates;
-	exynos3250_plls[vpll].rate_table = exynos3250_vpll_rates;
-	exynos3250_plls[upll].rate_table = exynos3250_pll_rates;
-
-	samsung_clk_register_pll(ctx, exynos3250_plls,
-					ARRAY_SIZE(exynos3250_plls), reg_base);
-
-	samsung_clk_register_mux(ctx, mux_clks, ARRAY_SIZE(mux_clks));
-	samsung_clk_register_div(ctx, div_clks, ARRAY_SIZE(div_clks));
-	samsung_clk_register_gate(ctx, gate_clks, ARRAY_SIZE(gate_clks));
-
-	exynos3_core_down_clock();
+		return;
 
-	exynos3250_clk_sleep_init();
-
-	samsung_clk_of_add_provider(np, ctx);
+	exynos3_core_down_clock(ctx->reg_base);
 }
 CLK_OF_DECLARE(exynos3250_cmu, "samsung,exynos3250-cmu", exynos3250_cmu_init);
 
@@ -872,12 +807,6 @@ CLK_OF_DECLARE(exynos3250_cmu, "samsung,exynos3250-cmu", exynos3250_cmu_init);
 #define EPLL_CON2		0x111c
 #define SRC_EPLL		0x1120
 
-/*
- * Support for CMU save/restore across system suspends
- */
-#ifdef CONFIG_PM_SLEEP
-static struct samsung_clk_reg_dump *exynos3250_dmc_clk_regs;
-
 static unsigned long exynos3250_cmu_dmc_clk_regs[] __initdata = {
 	BPLL_LOCK,
 	BPLL_CON0,
@@ -899,43 +828,6 @@ static unsigned long exynos3250_cmu_dmc_clk_regs[] __initdata = {
 	SRC_EPLL,
 };
 
-static int exynos3250_dmc_clk_suspend(void)
-{
-	samsung_clk_save(dmc_reg_base, exynos3250_dmc_clk_regs,
-				ARRAY_SIZE(exynos3250_cmu_dmc_clk_regs));
-	return 0;
-}
-
-static void exynos3250_dmc_clk_resume(void)
-{
-	samsung_clk_restore(dmc_reg_base, exynos3250_dmc_clk_regs,
-				ARRAY_SIZE(exynos3250_cmu_dmc_clk_regs));
-}
-
-static struct syscore_ops exynos3250_dmc_clk_syscore_ops = {
-	.suspend = exynos3250_dmc_clk_suspend,
-	.resume = exynos3250_dmc_clk_resume,
-};
-
-static void exynos3250_dmc_clk_sleep_init(void)
-{
-	exynos3250_dmc_clk_regs =
-		samsung_clk_alloc_reg_dump(exynos3250_cmu_dmc_clk_regs,
-				   ARRAY_SIZE(exynos3250_cmu_dmc_clk_regs));
-	if (!exynos3250_dmc_clk_regs) {
-		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
-		goto err;
-	}
-
-	register_syscore_ops(&exynos3250_dmc_clk_syscore_ops);
-	return;
-err:
-	kfree(exynos3250_dmc_clk_regs);
-}
-#else
-static inline void exynos3250_dmc_clk_sleep_init(void) { }
-#endif
-
 PNAME(mout_epll_p)	= { "fin_pll", "fout_epll", };
 PNAME(mout_bpll_p)	= { "fin_pll", "fout_bpll", };
 PNAME(mout_mpll_mif_p)	= { "fin_pll", "sclk_mpll_mif", };
@@ -977,43 +869,28 @@ static struct samsung_div_clock dmc_div_clks[] __initdata = {
 	DIV(CLK_DIV_DMCD, "div_dmcd", "div_dmc", DIV_DMC1, 11, 3),
 };
 
-static struct samsung_pll_clock exynos3250_dmc_plls[nr_dmc_plls] __initdata = {
-	[bpll] = PLL(pll_35xx, CLK_FOUT_BPLL, "fout_bpll", "fin_pll",
-			BPLL_LOCK, BPLL_CON0, NULL),
-	[epll] = PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
-			EPLL_LOCK, EPLL_CON0, NULL),
+static struct samsung_pll_clock exynos3250_dmc_plls[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_BPLL, "fout_bpll", "fin_pll",
+		BPLL_LOCK, BPLL_CON0, exynos3250_pll_rates),
+	PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
+		EPLL_LOCK, EPLL_CON0, exynos3250_epll_rates),
+};
+
+static struct samsung_cmu_info dmc_cmu_info __initdata = {
+	.pll_clks		= exynos3250_dmc_plls,
+	.nr_pll_clks		= ARRAY_SIZE(exynos3250_dmc_plls),
+	.mux_clks		= dmc_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(dmc_mux_clks),
+	.div_clks		= dmc_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(dmc_div_clks),
+	.nr_clk_ids		= NR_CLKS_DMC,
+	.clk_regs		= exynos3250_cmu_dmc_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(exynos3250_cmu_dmc_clk_regs),
 };
 
 static void __init exynos3250_cmu_dmc_init(struct device_node *np)
 {
-	struct samsung_clk_provider *ctx;
-
-	dmc_reg_base = of_iomap(np, 0);
-	if (!dmc_reg_base)
-		panic("%s: failed to map registers\n", __func__);
-
-	ctx = samsung_clk_init(np, dmc_reg_base, NR_CLKS_DMC);
-	if (!ctx)
-		panic("%s: unable to allocate context.\n", __func__);
-
-	exynos3250_dmc_plls[bpll].rate_table = exynos3250_pll_rates;
-	exynos3250_dmc_plls[epll].rate_table = exynos3250_epll_rates;
-
-	pr_err("CLK registering epll bpll: %d, %d, %d, %d\n",
-			exynos3250_dmc_plls[bpll].rate_table[0].rate,
-			exynos3250_dmc_plls[bpll].rate_table[0].mdiv,
-			exynos3250_dmc_plls[bpll].rate_table[0].pdiv,
-			exynos3250_dmc_plls[bpll].rate_table[0].sdiv
-	      );
-	samsung_clk_register_pll(ctx, exynos3250_dmc_plls,
-				ARRAY_SIZE(exynos3250_dmc_plls), dmc_reg_base);
-
-	samsung_clk_register_mux(ctx, dmc_mux_clks, ARRAY_SIZE(dmc_mux_clks));
-	samsung_clk_register_div(ctx, dmc_div_clks, ARRAY_SIZE(dmc_div_clks));
-
-	exynos3250_dmc_clk_sleep_init();
-
-	samsung_clk_of_add_provider(np, ctx);
+	samsung_cmu_register_one(np, &dmc_cmu_info);
 }
 CLK_OF_DECLARE(exynos3250_cmu_dmc, "samsung,exynos3250-cmu-dmc",
 		exynos3250_cmu_dmc_init);
-- 
1.8.5.5

