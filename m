Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaLaFWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:22:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38595 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaLaFT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:19:59 -0500
X-AuditID: cbfee68f-f791c6d000004834-2c-54a3877aaacd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCHv2 4/8] clk: samsung: exynos4: Add divider clock id for
 memory bus frequency
Date: Wed, 31 Dec 2014 14:19:48 +0900
Message-id: <1420003192-5576-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
References: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSrFvVvjjE4O4JS4vHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtucfhNO6vFql1/GB0EPNbMW8PosXPWXXaPxXteMnlsXlLv0bdlFaPH501yAWxR
	XDYpqTmZZalF+nYJXBktlz4yFZyVrLh17xZTA+Nl0S5GTg4JAROJ00tWsEPYYhIX7q1n62Lk
	4hASWMoo0fGzjwWmaMb3y8wQiUWMEi/bf7FAOE1MElNuTQWrYhPQktj/4gYbiC0iICNxdeN2
	sCJmgTXMEh86NoHtEBZIlDhx5gEjiM0ioCrxqO0CE4jNK+AicebjVzaIdQoSy5bPZO1i5ODg
	FHCVmPDFGSQsBFQyY0szE0TJS3aJz7s5IcYISHybfIgFpFxCQFZi0wFmiBJJiYMrbrBMYBRe
	wMiwilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwjk7/e9a/g/HuAetDjAIcjEo8vDftFocI
	sSaWFVfmHmI0BdowkVlKNDkfGK15JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGanphak
	FsUXleakFh9iZOLglGpgZOHR3l1v3Vgb+prFWHjldmNhmZOiQkUbKyM9XJkrPmWys87Zayme
	tsh3P3v7hC7BfqUA+5wZhsm/Mo//3XeQ7Xybw/n9LSW95R/S0uMDM447GR+UkP+oMWlKw5nD
	QVJGL+e+0lJSM/gubBG8fqf2pxy2U2If5f6+4J5bekymxXnJedXN+SlKLMUZiYZazEXFiQDp
	NUHIngIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAd2q9sUhBh0P9Cwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xeE37awWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxeUm9R9+WVYwenzfJBbBF
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdraRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMaLn0kangrGTFrXu3mBoYL4t2
	MXJySAiYSMz4fpkZwhaTuHBvPVsXIxeHkMAiRomX7b9YIJwmJokpt6aygFSxCWhJ7H9xgw3E
	FhGQkbi6cTtYEbPAGmaJDx2b2EESwgKJEifOPGAEsVkEVCUetV1gArF5BVwkznz8ygaxTkFi
	2fKZrF2MHBycAq4SE744g4SFgEpmbGlmmsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcJw+k9rBuLLB4hCjAAejEg/vDbvFIUKsiWXFlbmHGCU4mJVEeC9rAoV4UxIrq1KL8uOL
	SnNSiw8xmgIdNZFZSjQ5H5hC8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg
	+pg4OKUaGPvzJ8qw7D6yqUDwQ+HSNNWfzgrvw45cWWepk3VrnmijyjXrvDMOhk8TTPfevnsx
	W5Zl6se3pfkSV27o5L4zPb3iwZvYvyHssn/djgow7f957fWGT8d1O8xvzPybHVz45vvrBzP1
	mV8/6vq8JC+YLaLH1NnxQ9NUK9l430WlHbI+G/cFv/kY/lSJpTgj0VCLuag4EQDGk6h36QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the divider clock id for Exynos4 memory bus frequency.
The clock id is used fo DVFS (Dynamic Voltage/Frequency Scaling)
feature of exynos memory bus frequency.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c   | 10 +++++-----
 include/dt-bindings/clock/exynos4.h |  7 ++++++-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 88e8c6b..51462e8 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -703,12 +703,12 @@ static struct samsung_mux_clock exynos4x12_mux_clks[] __initdata = {
 
 /* list of divider clocks supported in all exynos4 soc's */
 static struct samsung_div_clock exynos4_div_clks[] __initdata = {
-	DIV(0, "div_gdl", "mout_gdl", DIV_LEFTBUS, 0, 3),
+	DIV(CLK_DIV_GDL, "div_gdl", "mout_gdl", DIV_LEFTBUS, 0, 3),
 	DIV(0, "div_gpl", "div_gdl", DIV_LEFTBUS, 4, 3),
 	DIV(0, "div_clkout_leftbus", "mout_clkout_leftbus",
 			CLKOUT_CMU_LEFTBUS, 8, 6),
 
-	DIV(0, "div_gdr", "mout_gdr", DIV_RIGHTBUS, 0, 3),
+	DIV(CLK_DIV_GDR, "div_gdr", "mout_gdr", DIV_RIGHTBUS, 0, 3),
 	DIV(0, "div_gpr", "div_gdr", DIV_RIGHTBUS, 4, 3),
 	DIV(0, "div_clkout_rightbus", "mout_clkout_rightbus",
 			CLKOUT_CMU_RIGHTBUS, 8, 6),
@@ -781,10 +781,10 @@ static struct samsung_div_clock exynos4_div_clks[] __initdata = {
 			CLK_SET_RATE_PARENT, 0),
 	DIV(0, "div_clkout_top", "mout_clkout_top", CLKOUT_CMU_TOP, 8, 6),
 
-	DIV(0, "div_acp", "mout_dmc_bus", DIV_DMC0, 0, 3),
+	DIV(CLK_DIV_ACP, "div_acp", "mout_dmc_bus", DIV_DMC0, 0, 3),
 	DIV(0, "div_acp_pclk", "div_acp", DIV_DMC0, 4, 3),
 	DIV(0, "div_dphy", "mout_dphy", DIV_DMC0, 8, 3),
-	DIV(0, "div_dmc", "mout_dmc_bus", DIV_DMC0, 12, 3),
+	DIV(CLK_DIV_DMC, "div_dmc", "mout_dmc_bus", DIV_DMC0, 12, 3),
 	DIV(0, "div_dmcd", "div_dmc", DIV_DMC0, 16, 3),
 	DIV(0, "div_dmcp", "div_dmcd", DIV_DMC0, 20, 3),
 	DIV(0, "div_pwi", "mout_pwi", DIV_DMC1, 8, 4),
@@ -829,7 +829,7 @@ static struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
 	DIV_F(CLK_DIV_MCUISP1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1,
 						8, 3, CLK_GET_RATE_NOCACHE, 0),
 	DIV(CLK_SCLK_FIMG2D, "sclk_fimg2d", "mout_g2d", DIV_DMC1, 0, 4),
-	DIV(0, "div_c2c", "mout_c2c", DIV_DMC1, 4, 3),
+	DIV(CLK_DIV_C2C, "div_c2c", "mout_c2c", DIV_DMC1, 4, 3),
 	DIV(0, "div_c2c_aclk", "div_c2c", DIV_DMC1, 12, 3),
 };
 
diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
index 34fe28c..c4b1676 100644
--- a/include/dt-bindings/clock/exynos4.h
+++ b/include/dt-bindings/clock/exynos4.h
@@ -262,8 +262,13 @@
 #define CLK_DIV_MCUISP1		453 /* Exynos4x12 only */
 #define CLK_DIV_ACLK200		454 /* Exynos4x12 only */
 #define CLK_DIV_ACLK400_MCUISP	455 /* Exynos4x12 only */
+#define CLK_DIV_ACP		456
+#define CLK_DIV_DMC		457
+#define CLK_DIV_C2C		458 /* Exynos4x12 only */
+#define CLK_DIV_GDL		459
+#define CLK_DIV_GDR		460
 
 /* must be greater than maximal clock id */
-#define CLK_NR_CLKS		456
+#define CLK_NR_CLKS		461
 
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS_4_H */
-- 
1.8.5.5

