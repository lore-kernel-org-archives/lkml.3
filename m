Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaJTMI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:08:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61630 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaJTMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:08:49 -0400
X-AuditID: cbfee68d-f79296d000004278-f4-5444fb4e3055
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, thomas.ab@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv4 1/4] clk: samsung: exynos3250: Add cpu clock configuration
 data and instaniate cpu clock
Date: Mon, 20 Oct 2014 21:08:39 +0900
Message-id: <1413806922-22722-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
References: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkUNfvt0uIwaIt5hbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8ni8Jt2VouOZYwWq3b9YbTY+NXDgcdj
	56y77B53ru1h89i8pN6jb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4Mva0fWEueC5WMfv1R6YG
	xi7hLkZODgkBE4mWJ02sELaYxIV769lAbCGBpYwSZ9s0YGoeH53D2MXIBRSfziixZcshFgin
	iUnic+s7JpAqNgEtif0vboB1iwgYSazauRRsKrPAXiaJC3/tQGxhgRyJGbtnMIPYLAKqEot2
	/AXr5RVwlTiz8wUbxDY5iQ97HrGD2JwCbhJr7s9ih7jIVeJWD8ilXEA1u9glrl95ADVIQOLb
	ZJCLOIASshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQJj
	4vS/Z707GG8fsD7EKMDBqMTDu8PMJUSINbGsuDL3EKMp0IaJzFKiyfnAyMsriTc0NjOyMDUx
	NTYytzRTEudVlPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR/Hb3VZEX7U0y04M4jN6t
	6BUyvHb6SPD+DJYmbqEir5+MVb8Cv3nxPXLj7rbjcN+pnCTKMEei9b/KjczyX1+W/YzvfZ3c
	c81/49EtF5Kt7/pkqu7buPrL/Z8ufx2n/LzFz7L9fMkd98NLM0JmHw++wcxhOZ9fImnL8zf/
	gpT/bkxa1W6bMEdRiaU4I9FQi7moOBEAKBCXjYQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV2/3y4hBqtea1pc//Kc1WLS/Qks
	Fr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLw2/aWS06ljFarNr1h9Fi41cPBx6P
	nbPusnvcubaHzWPzknqPvi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5ixp+0Lc8FzsYrZrz8yNTB2CXcxcnJICJhIPD46hxHCFpO4cG89WxcjF4eQwHRG
	iS1bDrFAOE1MEp9b3zGBVLEJaEnsf3GDDcQWETCSWLVzKSuIzSywl0niwl87EFtYIEdixu4Z
	zCA2i4CqxKIdf8F6eQVcJc7sfMEGsU1O4sOeR+wgNqeAm8Sa+7PAbCGgmls9TawTGHkXMDKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOuWdSOxhXNlgcYhTgYFTi4d1h5hIixJpYVlyZ
	e4hRgoNZSYQ36htQiDclsbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OB6SCvJN7Q2MTMyNLI3NDC
	yNhcSZz3QKt1oJBAemJJanZqakFqEUwfEwenVANjzR4BLq7ipQcbvx8523b0z753ulZbX6hv
	9FMxl7/UIGNQt2rB9JMsZVf7t6SXe7FeT5touSbY6/fGtmS5+hi5V6sTrBZM+Nix7nL6K+b+
	/3Ub/y2+d+bShB1v7gae0eAvFnPSOZVVZDXtnHWgsETbs0O+/19HNFnreB04NnOjy/mWpVvf
	2wp3KbEUZyQaajEXFScCAEyY0czPAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add CPU clock configuration data and instantiate the CPU clock type
for Exynos3250 to support Samsung specific cpu-clock type.

Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-cpu.h        |  4 ++++
 drivers/clk/samsung/clk-exynos3250.c | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/clk/samsung/clk-cpu.h b/drivers/clk/samsung/clk-cpu.h
index 42e1905..1ba31eb 100644
--- a/drivers/clk/samsung/clk-cpu.h
+++ b/drivers/clk/samsung/clk-cpu.h
@@ -13,6 +13,10 @@
 
 #include "clk.h"
 
+#define E3250_CPU_DIV0(apll, pclk_dbg, atb, corem)			\
+		(((apll) << 24) | ((pclk_dbg) << 20) | ((atb) << 16) |	\
+		((corem) << 4))
+
 #define E4210_CPU_DIV0(apll, pclk_dbg, atb, periph, corem1, corem0)	\
 		(((apll) << 24) | ((pclk_dbg) << 20) | ((atb) << 16) |	\
 		((periph) << 12) | ((corem1) << 8) | ((corem0) <<  4))
diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index 6e6cca3..aa55218 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -19,6 +19,7 @@
 #include <dt-bindings/clock/exynos3250.h>
 
 #include "clk.h"
+#include "clk-cpu.h"
 #include "clk-pll.h"
 
 #define SRC_LEFTBUS		0x4200
@@ -793,6 +794,20 @@ static struct samsung_pll_clock exynos3250_plls[nr_plls] __initdata = {
 			UPLL_LOCK, UPLL_CON0, NULL),
 };
 
+static const struct exynos_cpuclk_cfg_data e3250_armclk_d[] __initconst = {
+	{ 1000000, E3250_CPU_DIV0(1, 7, 4, 1), E4210_CPU_DIV1(7, 7), },
+	{  900000, E3250_CPU_DIV0(1, 7, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  800000, E3250_CPU_DIV0(1, 7, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  700000, E3250_CPU_DIV0(1, 7, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  600000, E3250_CPU_DIV0(1, 7, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  500000, E3250_CPU_DIV0(1, 7, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  400000, E3250_CPU_DIV0(1, 7, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  300000, E3250_CPU_DIV0(1, 5, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  200000, E3250_CPU_DIV0(1, 3, 3, 1), E4210_CPU_DIV1(7, 7), },
+	{  100000, E3250_CPU_DIV0(1, 1, 1, 1), E4210_CPU_DIV1(7, 7), },
+	{  0 },
+};
+
 static void __init exynos3_core_down_clock(void)
 {
 	unsigned int tmp;
@@ -840,6 +855,10 @@ static void __init exynos3250_cmu_init(struct device_node *np)
 	samsung_clk_register_mux(ctx, mux_clks, ARRAY_SIZE(mux_clks));
 	samsung_clk_register_div(ctx, div_clks, ARRAY_SIZE(div_clks));
 	samsung_clk_register_gate(ctx, gate_clks, ARRAY_SIZE(gate_clks));
+	exynos_register_cpu_clock(ctx, CLK_DIV_CORE2, "armclk",
+			mout_core_p[0], mout_core_p[1], 0x14200,
+			e3250_armclk_d, ARRAY_SIZE(e3250_armclk_d),
+			CLK_CPU_HAS_DIV1);
 
 	exynos3_core_down_clock();
 
-- 
1.8.0

