Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaLWHlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:41:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28384 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaLWHk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:40:29 -0500
X-AuditID: cbfee68f-f791c6d000004834-d4-54991c6a6306
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, inki.dae@samsung.com,
        cw00.choi@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3/3] clk: samsung: exynos4415: Use samsung_cmu_register_one()
 to simplify code
Date: Tue, 23 Dec 2014 16:40:23 +0900
Message-id: <1419320423-19228-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
References: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkSDdLZmaIwdTFJhbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtc3jWHzWLG+X1MFk8nXGSzOPymndVi1a4/jA6cHjtn3WX3uHNtD5tH35ZV
	jB6fN8kFsERx2aSk5mSWpRbp2yVwZTS29jIXrPKvmDtrFVMD4zmXLkZODgkBE4n+l3OZIWwx
	iQv31rN1MXJxCAksZZQ4MG09excjB1jR8TMcEPFFjBLTzk9mB2kQEmhiknj+RBXEZhPQktj/
	4gYbSL2IgKHEzUNKIPXMAucYJdYu62cDqREWSJCY9nw7WC+LgKrEix1zmEBsXgFXieNLf7JB
	HKEgsWz5TFYQm1PATeLnzI8sELtcJXZ+nssOUbOKXWLvFhmIOQIS3yYfYoG4U1Zi0wGoXyQl
	Dq64wTKBUXgBI8MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMBgP/3vWf8OxrsHrA8xCnAw
	KvHwLjgzI0SINbGsuDL3EKMp0IaJzFKiyfnAmMoriTc0NjOyMDUxNTYytzRTEuddKPUzWEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjLK78DU5qcRvehJ77l/uW9R6PSf0UGbls6VyFF5Wz
	pEO+PU3l9/nktSHt0y01C7O2701XZTNyD4hOnzvjX33VzNs1BrE1Z0M63Za/0yrdvDm/yOdl
	GOuqfzkKh99/d83QvMW7jkXcPj0i5sISvybFacavZzqEtTG8zXtosVhThPVc+XvRnlNKLMUZ
	iYZazEXFiQCH9lqgcQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jAd0smZkhBt23tSyuf3nOajHp/gQW
	i94FV9kszja9Ybe4vGsOm8WM8/uYLJ5OuMhmcfhNO6vFql1/GB04PXbOusvucefaHjaPvi2r
	GD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR2NrLXLDKv2Lu
	rFVMDYznXLoYOTgkBEwkjp/h6GLkBDLFJC7cW8/WxcjFISSwiFFi2vnJ7CAJIYEmJonnT1RB
	bDYBLYn9L26wgfSKCBhK3DykBFLPLHCOUWLtsn42kBphgQSJac+3g/WyCKhKvNgxhwnE5hVw
	lTi+9CcbxDIFiWXLZ7KC2JwCbhI/Z35kgdjlKrHz81z2CYy8CxgZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIER9MzqR2MKxssDjEKcDAq8fAuODMjRIg1say4MvcQowQHs5II70vxmSFC
	vCmJlVWpRfnxRaU5qcWHGE2BrprILCWanA+M9LySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0
	xJLU7NTUgtQimD4mDk6pBkZhMUahR7d3vJl15//7H1UvNKvjMzZt6rV8fWS6yHsPP4OUe36L
	uH9U75y/ZXr9T6+VPolGX9L3Mu5csTT8/ArRLfv/zJ/Vu/Bev++fEx9bxStCao20dRx+/pvw
	srrx/dQXEy+Kbd1112DdBYUfP0sfOIiofvo8a+vfO72rTpcwKDbxleeFLHtersRSnJFoqMVc
	VJwIAF7+THC8AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the samsung_cmu_register_one() to simplify complicated code
for Exynos4415.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-exynos4415.c | 216 ++++++++---------------------------
 1 file changed, 48 insertions(+), 168 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4415.c b/drivers/clk/samsung/clk-exynos4415.c
index 2123fc2..6c78b09 100644
--- a/drivers/clk/samsung/clk-exynos4415.c
+++ b/drivers/clk/samsung/clk-exynos4415.c
@@ -113,19 +113,6 @@
 #define DIV_CPU0		0x14500
 #define DIV_CPU1		0x14504
 
-enum exynos4415_plls {
-	apll, epll, g3d_pll, isp_pll, disp_pll,
-	nr_plls,
-};
-
-static struct samsung_clk_provider *exynos4415_ctx;
-
-/*
- * Support for CMU save/restore across system suspends
- */
-#ifdef CONFIG_PM_SLEEP
-static struct samsung_clk_reg_dump *exynos4415_clk_regs;
-
 static unsigned long exynos4415_cmu_clk_regs[] __initdata = {
 	SRC_LEFTBUS,
 	DIV_LEFTBUS,
@@ -219,41 +206,6 @@ static unsigned long exynos4415_cmu_clk_regs[] __initdata = {
 	DIV_CPU1,
 };
 
-static int exynos4415_clk_suspend(void)
-{
-	samsung_clk_save(exynos4415_ctx->reg_base, exynos4415_clk_regs,
-				ARRAY_SIZE(exynos4415_cmu_clk_regs));
-
-	return 0;
-}
-
-static void exynos4415_clk_resume(void)
-{
-	samsung_clk_restore(exynos4415_ctx->reg_base, exynos4415_clk_regs,
-				ARRAY_SIZE(exynos4415_cmu_clk_regs));
-}
-
-static struct syscore_ops exynos4415_clk_syscore_ops = {
-	.suspend = exynos4415_clk_suspend,
-	.resume = exynos4415_clk_resume,
-};
-
-static void exynos4415_clk_sleep_init(void)
-{
-	exynos4415_clk_regs =
-		samsung_clk_alloc_reg_dump(exynos4415_cmu_clk_regs,
-					ARRAY_SIZE(exynos4415_cmu_clk_regs));
-	if (!exynos4415_clk_regs) {
-		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
-		return;
-	}
-
-	register_syscore_ops(&exynos4415_clk_syscore_ops);
-}
-#else
-static inline void exynos4415_clk_sleep_init(void) { }
-#endif
-
 /* list of all parent clock list */
 PNAME(mout_g3d_pllsrc_p)	= { "fin_pll", };
 
@@ -959,56 +911,40 @@ static struct samsung_pll_rate_table exynos4415_epll_rates[] = {
 	{ /* sentinel */ }
 };
 
-static struct samsung_pll_clock exynos4415_plls[nr_plls] __initdata = {
-	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
-			APLL_LOCK, APLL_CON0, NULL),
-	[epll] = PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
-			EPLL_LOCK, EPLL_CON0, NULL),
-	[g3d_pll] = PLL(pll_35xx, CLK_FOUT_G3D_PLL, "fout_g3d_pll",
-			"mout_g3d_pllsrc", G3D_PLL_LOCK, G3D_PLL_CON0, NULL),
-	[isp_pll] = PLL(pll_35xx, CLK_FOUT_ISP_PLL, "fout_isp_pll", "fin_pll",
-			ISP_PLL_LOCK, ISP_PLL_CON0, NULL),
-	[disp_pll] = PLL(pll_35xx, CLK_FOUT_DISP_PLL, "fout_disp_pll",
-			"fin_pll", DISP_PLL_LOCK, DISP_PLL_CON0, NULL),
+static struct samsung_pll_clock exynos4415_plls[] __initdata = {
+	PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
+		APLL_LOCK, APLL_CON0, exynos4415_pll_rates),
+	PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
+		EPLL_LOCK, EPLL_CON0, exynos4415_epll_rates),
+	PLL(pll_35xx, CLK_FOUT_G3D_PLL, "fout_g3d_pll", "mout_g3d_pllsrc",
+		G3D_PLL_LOCK, G3D_PLL_CON0, exynos4415_pll_rates),
+	PLL(pll_35xx, CLK_FOUT_ISP_PLL, "fout_isp_pll", "fin_pll",
+		ISP_PLL_LOCK, ISP_PLL_CON0, exynos4415_pll_rates),
+	PLL(pll_35xx, CLK_FOUT_DISP_PLL, "fout_disp_pll",
+		"fin_pll", DISP_PLL_LOCK, DISP_PLL_CON0, exynos4415_pll_rates),
+};
+
+static struct samsung_cmu_info cmu_info __initdata = {
+	.pll_clks		= exynos4415_plls,
+	.nr_pll_clks		= ARRAY_SIZE(exynos4415_plls),
+	.mux_clks		= exynos4415_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(exynos4415_mux_clks),
+	.div_clks		= exynos4415_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(exynos4415_div_clks),
+	.gate_clks		= exynos4415_gate_clks,
+	.nr_gate_clks		= ARRAY_SIZE(exynos4415_gate_clks),
+	.fixed_clks		= exynos4415_fixed_rate_clks,
+	.nr_fixed_clks		= ARRAY_SIZE(exynos4415_fixed_rate_clks),
+	.fixed_factor_clks	= exynos4415_fixed_factor_clks,
+	.nr_fixed_factor_clks	= ARRAY_SIZE(exynos4415_fixed_factor_clks),
+	.nr_clk_ids		= CLK_NR_CLKS,
+	.clk_regs		= exynos4415_cmu_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(exynos4415_cmu_clk_regs),
 };
 
 static void __init exynos4415_cmu_init(struct device_node *np)
 {
-	void __iomem *reg_base;
-
-	reg_base = of_iomap(np, 0);
-	if (!reg_base)
-		panic("%s: failed to map registers\n", __func__);
-
-	exynos4415_ctx = samsung_clk_init(np, reg_base, CLK_NR_CLKS);
-	if (!exynos4415_ctx)
-		panic("%s: unable to allocate context.\n", __func__);
-
-	exynos4415_plls[apll].rate_table = exynos4415_pll_rates;
-	exynos4415_plls[epll].rate_table = exynos4415_epll_rates;
-	exynos4415_plls[g3d_pll].rate_table = exynos4415_pll_rates;
-	exynos4415_plls[isp_pll].rate_table = exynos4415_pll_rates;
-	exynos4415_plls[disp_pll].rate_table = exynos4415_pll_rates;
-
-	samsung_clk_register_fixed_factor(exynos4415_ctx,
-				exynos4415_fixed_factor_clks,
-				ARRAY_SIZE(exynos4415_fixed_factor_clks));
-	samsung_clk_register_fixed_rate(exynos4415_ctx,
-				exynos4415_fixed_rate_clks,
-				ARRAY_SIZE(exynos4415_fixed_rate_clks));
-
-	samsung_clk_register_pll(exynos4415_ctx, exynos4415_plls,
-				ARRAY_SIZE(exynos4415_plls), reg_base);
-	samsung_clk_register_mux(exynos4415_ctx, exynos4415_mux_clks,
-				ARRAY_SIZE(exynos4415_mux_clks));
-	samsung_clk_register_div(exynos4415_ctx, exynos4415_div_clks,
-				ARRAY_SIZE(exynos4415_div_clks));
-	samsung_clk_register_gate(exynos4415_ctx, exynos4415_gate_clks,
-				ARRAY_SIZE(exynos4415_gate_clks));
-
-	exynos4415_clk_sleep_init();
-
-	samsung_clk_of_add_provider(np, exynos4415_ctx);
+	samsung_cmu_register_one(np, &cmu_info);
 }
 CLK_OF_DECLARE(exynos4415_cmu, "samsung,exynos4415-cmu", exynos4415_cmu_init);
 
@@ -1027,16 +963,6 @@ CLK_OF_DECLARE(exynos4415_cmu, "samsung,exynos4415-cmu", exynos4415_cmu_init);
 #define SRC_DMC			0x300
 #define DIV_DMC1		0x504
 
-enum exynos4415_dmc_plls {
-	mpll, bpll,
-	nr_dmc_plls,
-};
-
-static struct samsung_clk_provider *exynos4415_dmc_ctx;
-
-#ifdef CONFIG_PM_SLEEP
-static struct samsung_clk_reg_dump *exynos4415_dmc_clk_regs;
-
 static unsigned long exynos4415_cmu_dmc_clk_regs[] __initdata = {
 	MPLL_LOCK,
 	MPLL_CON0,
@@ -1050,42 +976,6 @@ static unsigned long exynos4415_cmu_dmc_clk_regs[] __initdata = {
 	DIV_DMC1,
 };
 
-static int exynos4415_dmc_clk_suspend(void)
-{
-	samsung_clk_save(exynos4415_dmc_ctx->reg_base,
-				exynos4415_dmc_clk_regs,
-				ARRAY_SIZE(exynos4415_cmu_dmc_clk_regs));
-	return 0;
-}
-
-static void exynos4415_dmc_clk_resume(void)
-{
-	samsung_clk_restore(exynos4415_dmc_ctx->reg_base,
-				exynos4415_dmc_clk_regs,
-				ARRAY_SIZE(exynos4415_cmu_dmc_clk_regs));
-}
-
-static struct syscore_ops exynos4415_dmc_clk_syscore_ops = {
-	.suspend = exynos4415_dmc_clk_suspend,
-	.resume = exynos4415_dmc_clk_resume,
-};
-
-static void exynos4415_dmc_clk_sleep_init(void)
-{
-	exynos4415_dmc_clk_regs =
-		samsung_clk_alloc_reg_dump(exynos4415_cmu_dmc_clk_regs,
-				ARRAY_SIZE(exynos4415_cmu_dmc_clk_regs));
-	if (!exynos4415_dmc_clk_regs) {
-		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
-		return;
-	}
-
-	register_syscore_ops(&exynos4415_dmc_clk_syscore_ops);
-}
-#else
-static inline void exynos4415_dmc_clk_sleep_init(void) { }
-#endif /* CONFIG_PM_SLEEP */
-
 PNAME(mout_mpll_p)		= { "fin_pll", "fout_mpll", };
 PNAME(mout_bpll_p)		= { "fin_pll", "fout_bpll", };
 PNAME(mbpll_p)			= { "mout_mpll", "mout_bpll", };
@@ -1107,38 +997,28 @@ static struct samsung_div_clock exynos4415_dmc_div_clks[] __initdata = {
 	DIV(CLK_DMC_DIV_MPLL_PRE, "div_mpll_pre", "mout_mpll", DIV_DMC1, 8, 2),
 };
 
-static struct samsung_pll_clock exynos4415_dmc_plls[nr_dmc_plls] __initdata = {
-	[mpll] = PLL(pll_35xx, CLK_DMC_FOUT_MPLL, "fout_mpll", "fin_pll",
-		MPLL_LOCK, MPLL_CON0, NULL),
-	[bpll] = PLL(pll_35xx, CLK_DMC_FOUT_BPLL, "fout_bpll", "fin_pll",
-		BPLL_LOCK, BPLL_CON0, NULL),
+static struct samsung_pll_clock exynos4415_dmc_plls[] __initdata = {
+	PLL(pll_35xx, CLK_DMC_FOUT_MPLL, "fout_mpll", "fin_pll",
+		MPLL_LOCK, MPLL_CON0, exynos4415_pll_rates),
+	PLL(pll_35xx, CLK_DMC_FOUT_BPLL, "fout_bpll", "fin_pll",
+		BPLL_LOCK, BPLL_CON0, exynos4415_pll_rates),
+};
+
+static struct samsung_cmu_info cmu_dmc_info __initdata = {
+	.pll_clks		= exynos4415_dmc_plls,
+	.nr_pll_clks		= ARRAY_SIZE(exynos4415_dmc_plls),
+	.mux_clks		= exynos4415_dmc_mux_clks,
+	.nr_mux_clks		= ARRAY_SIZE(exynos4415_dmc_mux_clks),
+	.div_clks		= exynos4415_dmc_div_clks,
+	.nr_div_clks		= ARRAY_SIZE(exynos4415_dmc_div_clks),
+	.nr_clk_ids		= NR_CLKS_DMC,
+	.clk_regs		= exynos4415_cmu_dmc_clk_regs,
+	.nr_clk_regs		= ARRAY_SIZE(exynos4415_cmu_dmc_clk_regs),
 };
 
 static void __init exynos4415_cmu_dmc_init(struct device_node *np)
 {
-	void __iomem *reg_base;
-
-	reg_base = of_iomap(np, 0);
-	if (!reg_base)
-		panic("%s: failed to map registers\n", __func__);
-
-	exynos4415_dmc_ctx = samsung_clk_init(np, reg_base, NR_CLKS_DMC);
-	if (!exynos4415_dmc_ctx)
-		panic("%s: unable to allocate context.\n", __func__);
-
-	exynos4415_dmc_plls[mpll].rate_table = exynos4415_pll_rates;
-	exynos4415_dmc_plls[bpll].rate_table = exynos4415_pll_rates;
-
-	samsung_clk_register_pll(exynos4415_dmc_ctx, exynos4415_dmc_plls,
-				ARRAY_SIZE(exynos4415_dmc_plls), reg_base);
-	samsung_clk_register_mux(exynos4415_dmc_ctx, exynos4415_dmc_mux_clks,
-				ARRAY_SIZE(exynos4415_dmc_mux_clks));
-	samsung_clk_register_div(exynos4415_dmc_ctx, exynos4415_dmc_div_clks,
-				ARRAY_SIZE(exynos4415_dmc_div_clks));
-
-	exynos4415_dmc_clk_sleep_init();
-
-	samsung_clk_of_add_provider(np, exynos4415_dmc_ctx);
+	samsung_cmu_register_one(np, &cmu_dmc_info);
 }
 CLK_OF_DECLARE(exynos4415_cmu_dmc, "samsung,exynos4415-cmu-dmc",
 		exynos4415_cmu_dmc_init);
-- 
1.8.5.5

