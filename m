Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaEWJEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:04:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35535 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaEWJEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:04:32 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-4e-537f0f1437fa
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] clk: samsung: Make of_device_id array const
Date: Fri, 23 May 2014 11:04:08 +0200
Message-id: <1400835848-26993-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xK7oi/PXBBt96hC1evzC06F1wlc1i
	0+NrrBaXd81hs5hxfh+TxdMJF9ks1s94zeLA7nHn2h42j81L6j36tqxi9Pi8SS6AJYrLJiU1
	J7MstUjfLoErY++C3UwF9+QqZn5bxt7AuFiqi5GTQ0LAROLYvMmMELaYxIV769m6GLk4hASW
	MkpsbN4GlhAS6GOS6JuRBWKzCRhLbF6+BKxIROA2o8TlIzfYQRLMAoYSP9/9AbOFBWwk9l48
	wARiswioSrQ++QwW5xVwl3h06iYrxDY5iZPHJrNOYORewMiwilE0tTS5oDgpPddIrzgxt7g0
	L10vOT93EyMkML7uYFx6zOoQowAHoxIPL4daXbAQa2JZcWXuIUYJDmYlEV5b5vpgId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYzRsbf6k7YFt+lNVinRvMjEJ+DmsObuxu2dpXq+D7Q1ZzicWXIh
	TEz3Tnpi3stPrYYqh76a5X6Q2e/43fq4amnc9KRZHyMvu2WrfLe/HFz9zJV5PVv2BJ2cQ6uz
	DJ5YRR9Sm67+5eOvVT+7fiQaWb1czmYrIsfI8vntE42s+W0iNdct3J3faCuxFGckGmoxFxUn
	AgB1XlZL6gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by
of_match_table field and of_find_matching_node_and_match() function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c    | 2 +-
 drivers/clk/samsung/clk-exynos5250.c | 2 +-
 drivers/clk/samsung/clk-exynos5420.c | 2 +-
 drivers/clk/samsung/clk-exynos5440.c | 2 +-
 drivers/clk/samsung/clk.c            | 2 +-
 drivers/clk/samsung/clk.h            | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index b4f967210175..3463535dcc25 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1070,7 +1070,7 @@ static void __init exynos4_clk_register_finpll(void)
 
 }
 
-static struct of_device_id ext_clk_match[] __initdata = {
+static const struct of_device_id ext_clk_match[] __initconst = {
 	{ .compatible = "samsung,clock-xxti", .data = (void *)0, },
 	{ .compatible = "samsung,clock-xusbxti", .data = (void *)1, },
 	{},
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index e7ee4420da81..0d97c69fde29 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -678,7 +678,7 @@ static struct samsung_pll_clock exynos5250_plls[nr_plls] __initdata = {
 		VPLL_LOCK, VPLL_CON0, NULL),
 };
 
-static struct of_device_id ext_clk_match[] __initdata = {
+static const struct of_device_id ext_clk_match[] __initconst = {
 	{ .compatible = "samsung,clock-xxti", .data = (void *)0, },
 	{ },
 };
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 60b26819bed5..904881493b32 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -770,7 +770,7 @@ static struct samsung_pll_clock exynos5420_plls[nr_plls] __initdata = {
 		KPLL_CON0, NULL),
 };
 
-static struct of_device_id ext_clk_match[] __initdata = {
+static const struct of_device_id ext_clk_match[] __initconst = {
 	{ .compatible = "samsung,exynos5420-oscclk", .data = (void *)0, },
 	{ },
 };
diff --git a/drivers/clk/samsung/clk-exynos5440.c b/drivers/clk/samsung/clk-exynos5440.c
index 2bfad5a993d0..ff70bfed5ef8 100644
--- a/drivers/clk/samsung/clk-exynos5440.c
+++ b/drivers/clk/samsung/clk-exynos5440.c
@@ -84,7 +84,7 @@ static struct samsung_gate_clock exynos5440_gate_clks[] __initdata = {
 	GATE(CLK_CS250_O, "cs250_o", "cs250", CLKEN_OV_VAL, 19, 0, 0),
 };
 
-static struct of_device_id ext_clk_match[] __initdata = {
+static const struct of_device_id ext_clk_match[] __initconst = {
 	{ .compatible = "samsung,clock-xtal", .data = (void *)0, },
 	{},
 };
diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 91bec3ebdc8f..f9914a8b02ae 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -269,7 +269,7 @@ void __init samsung_clk_register_gate(struct samsung_gate_clock *list,
 void __init samsung_clk_of_register_fixed_ext(
 			struct samsung_fixed_rate_clock *fixed_rate_clk,
 			unsigned int nr_fixed_rate_clk,
-			struct of_device_id *clk_matches)
+			const struct of_device_id *clk_matches)
 {
 	const struct of_device_id *match;
 	struct device_node *np;
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index c7141ba826e0..dc8f2cc6f486 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -317,7 +317,7 @@ extern void __init samsung_clk_init(struct device_node *np, void __iomem *base,
 extern void __init samsung_clk_of_register_fixed_ext(
 		struct samsung_fixed_rate_clock *fixed_rate_clk,
 		unsigned int nr_fixed_rate_clk,
-		struct of_device_id *clk_matches);
+		const struct of_device_id *clk_matches);
 
 extern void samsung_clk_add_lookup(struct clk *clk, unsigned int id);
 
-- 
1.9.1

