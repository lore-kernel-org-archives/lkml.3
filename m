Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220AbaFRIkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:40:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62746 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbaFRIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:40:07 -0400
X-AuditID: cbfee68f-b7fef6d000003970-96-53a15064fac2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: t.figa@samsung.com, kgene.kim@samsung.com, thomas.ab@samsung.com,
        viresh.kumar@linaro.org, mturquette@linaro.org, shawn.guo@linaro.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 2/3] clk: samsung: exynos3250: Use cpu-clock provider type to
 support cpufreq
Date: Wed, 18 Jun 2014 17:40:01 +0900
Message-id: <1403080802-2794-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
References: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSrJsSsDDY4PQMJYvrX56zWvQuuMpm
	cbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsnk64yGbxdN0SZov1M16zWHQsY7TY+NXDgcfj
	zrU9bB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8arRw9YCjaLVPTsvsDWwHhQsIuR
	k0NCwETix8QmNghbTOLCvfVANheHkMBSRolbb1rYYYraDr9lhUhMZ5S4fOQjC4TTxCTxYMUT
	sHY2AS2J/S9ugNkiAj2MEks77EGKmAV2MkrMv9rGDJIQFkiU+LR8AxOIzSKgKtHw8RfYCl4B
	F4nDJ5dCrZOT+LDnEZDNwcEp4Cqx8kMISFgIqGRP70WwKyQEdrFLnPy2gR1ijoDEt8mHWEDq
	JQRkJTYdYIYYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBMbC6X/P
	+ncw3j1gfYgxGWjcRGYp0eR8YCzllcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbG2DNBG00PaV+detJIseeAXXSCYey6ljPKGV4Z+z5ud5se+Xfp
	85zOfv8WrjZZ4/e9C87IrdnxYJrnkw2rTLZuzXz33vVK/AK1ZasmnJ5heHgi07GiA+sud5S7
	+5buus/afkb2wNf6RyJ/fzjYtO4zZQk7xzxt7ZFkUa/AB1Kr+D4GbeRR52hNVGIpzkg01GIu
	Kk4EAE4goNKbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd2UgIXBBrOeSFpc//Kc1aJ3wVU2
	i7NNb9gtNj2+xmpxedccNovPvUcYLWac38dk8XTCRTaLp+uWMFusn/GaxaJjGaPFxq8eDjwe
	d67tYfPYvKTeo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jBmvHr0gKVgs0hFz+4LbA2MBwW7GDk5JARMJNoOv2WFsMUkLtxbz9bFyMUhJDCdUeLykY8s
	EE4Tk8SDFU/YQKrYBLQk9r+4AWaLCPQwSiztsAcpYhbYySgx/2obM0hCWCBR4tPyDUwgNouA
	qkTDx1/sIDavgIvE4ZNL2SHWyUl82PMIyObg4BRwlVj5IQQkLARUsqf3IusERt4FjAyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYIj7ZnUDsaVDRaHGAU4GJV4eDlyFwQLsSaWFVfmHmKU
	4GBWEuGd4rkwWIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgUkgryTe0NjEzMjSyNzQwsjY
	nDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYZRo2uAm3CV9RDJ+z3tcpsqBp+rIirzmT
	X1gmNvxfunpqfaXVze86khN37lhxboLzy1d7X/NfOxXc4pVusadO4I3yYY6P/yNmu0qaLOmv
	MzDYKLPa8tsE07k1l693nuHx64xjOb6I51jJ8hb1I4nGrG8rXu5l8L2hvdcsxeictmiNKbOG
	4cnjSizFGYmGWsxFxYkAkVdfVvgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use cpu-clock provider type to support cpufreq for Exynos3250. The
clock-exynos3250.c didn't add separate 'arm_clk' divider for 'div_core2'.
The 'div_core2' can be represented as a cpu-clock type and then use 'div_core2'
directly to change cpu clock.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index 775a4ee..60ce369 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -357,8 +357,10 @@ static struct samsung_mux_clock mux_clks[] __initdata = {
 	MUX(CLK_MOUT_MPLL_USER_C, "mout_mpll_user_c", mout_mpll_user_p,
 	    SRC_CPU, 24, 1),
 	MUX(CLK_MOUT_HPM, "mout_hpm", mout_hpm_p, SRC_CPU, 20, 1),
-	MUX(CLK_MOUT_CORE, "mout_core", mout_core_p, SRC_CPU, 16, 1),
-	MUX(CLK_MOUT_APLL, "mout_apll", mout_apll_p, SRC_CPU, 0, 1),
+	MUX_F(CLK_MOUT_CORE, "mout_core", mout_core_p, SRC_CPU, 16, 1, 0,
+			CLK_MUX_READ_ONLY),
+	MUX_F(CLK_MOUT_APLL, "mout_apll", mout_apll_p, SRC_CPU, 0, 1,
+			CLK_SET_RATE_PARENT, 0),
 };
 
 static struct samsung_div_clock div_clks[] __initdata = {
@@ -447,11 +449,13 @@ static struct samsung_div_clock div_clks[] __initdata = {
 
 	/* DIV_CPU0 */
 	DIV(CLK_DIV_CORE2, "div_core2", "div_core", DIV_CPU0, 28, 3),
-	DIV(CLK_DIV_APLL, "div_apll", "mout_apll", DIV_CPU0, 24, 3),
+	DIV_F(CLK_DIV_APLL, "div_apll", "mout_apll", DIV_CPU0, 24, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
 	DIV(CLK_DIV_PCLK_DBG, "div_pclk_dbg", "div_core2", DIV_CPU0, 20, 3),
 	DIV(CLK_DIV_ATB, "div_atb", "div_core2", DIV_CPU0, 16, 3),
 	DIV(CLK_DIV_COREM, "div_corem", "div_core2", DIV_CPU0, 4, 3),
-	DIV(CLK_DIV_CORE, "div_core", "mout_core", DIV_CPU0, 0, 3),
+	DIV_F(CLK_DIV_CORE, "div_core", "mout_core", DIV_CPU0, 0, 3,
+			CLK_GET_RATE_NOCACHE, CLK_DIVIDER_READ_ONLY),
 
 	/* DIV_CPU1 */
 	DIV(CLK_DIV_HPM, "div_hpm", "div_copy", DIV_CPU1, 4, 3),
@@ -820,6 +824,8 @@ static void __init exynos3_cmu_init(struct device_node *np,
 	samsung_clk_register_mux(ctx, mux_clks, ARRAY_SIZE(mux_clks));
 	samsung_clk_register_div(ctx, div_clks, ARRAY_SIZE(div_clks));
 	samsung_clk_register_gate(ctx, gate_clks, ARRAY_SIZE(gate_clks));
+	exynos_register_cpu_clock(ctx, 0, CLK_DIV_CORE2, "armclk",
+				mout_core_p[0], mout_core_p[1], np);
 
 	if (soc == EXYNOS3472) {
 		samsung_clk_register_mux(ctx, exynos3472_mux_clks,
-- 
1.8.0

