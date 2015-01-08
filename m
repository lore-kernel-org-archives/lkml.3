Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbbAHBnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:43:01 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbbAHBlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:03 -0500
X-AuditID: cbfee68f-f791c6d000004834-d6-54ade02bf2a6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv3 4/8] clk: samsung: exynos4: Add divider clock id for memory
 bus frequency
Date: Thu, 08 Jan 2015 10:40:53 +0900
Message-id: <1420681257-3078-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWyRsSkRFf7wdoQg83nhSwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWh9+0s1qs2vWH0UHQY828NYweO2fdZfdYvOclk8emVZ1sHpuX1Hv0
	bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXRsulj0wFZyUrbt27xdTAeFm0i5GTQ0LAROLgq2lM
	ELaYxIV769m6GLk4hASWMkqc/fGeEaZo5ad97BCJRYwSfU9nMUI4TUwSr1bMB6tiE9CS2P/i
	BhuILSKgJ9F5bA9YB7PASmaJQ41PwXYIC8RKHFvXAtbAIqAqMe3GXlYQm1fARaLpzSU2iHUK
	EsuWzwSLcwq4SvQ/vQZmCwHVXH68CmyzhMBHdomz5zrZIAYJSHybfIili5EDKCErsekAM8Qc
	SYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjML5O/3vWv4Px7gHrQ4wC
	HIxKPLwFfWtChFgTy4orcw8xmgJtmMgsJZqcD4zivJJ4Q2MzIwtTE1NjI3NLMyVx3oVSP4OF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MNYkqv1aqtUedcGn0WFL6mWWM/OXxb++0lDCsujY
	lntqMi3fLX4UPk9fe+Whr5Xto482HS9a9vBZr1zj/ajE59jfTqOtasdD72wv2D9tqlu4USxn
	UraaQ0zR9JiSxYKz7WfPUX9aUzCp/6Z6x9k5j6UTMxuVXpoGdyuZ3T2k/W/OcgHvgMrFy5VY
	ijMSDbWYi4oTAWvOZg+qAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAV3tB2tDDPYe5LR4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbHH7TzmqxatcfRgdBjzXz1jB67Jx1l91j8Z6XTB6bVnWyeWxeUu/R
	t2UVo8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDNaLn1kKjgr
	WXHr3i2mBsbLol2MnBwSAiYSKz/tY4ewxSQu3FvP1sXIxSEksIhRou/pLEYIp4lJ4tWK+Ywg
	VWwCWhL7X9xgA7FFBPQkOo/tYQcpYhZYySxxqPEpE0hCWCBW4ti6FrAGFgFViWk39rKC2LwC
	LhJNby6xQaxTkFi2fCZYnFPAVaL/6TUwWwio5vLjVYwTGHkXMDKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAiO3mfSOxhXNVgcYhTgYFTi4S3oWxMixJpYVlyZe4hRgoNZSYS36+zaECHe
	lMTKqtSi/Pii0pzU4kOMpkBXTWSWEk3OByaWvJJ4Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTE
	ktTs1NSC1CKYPiYOTqkGRrdpnv5pHRdW8zWoG4uu/30sq8e2rN3rFs/jr2eE/wmfnGl4sDzM
	oMV8ftq9ppvPU/u/7jN+JeU/S49fd7mmi/M9vgBddZV1uxZKZP7etDlvZ17sm90vbjDxfo2Y
	usrh1YaSdUwPfV1Dv6tuEfPa4Nt8I7T/xpxlhrVzln6zrr5S5Jd+NPn+biWW4oxEQy3mouJE
	APSaADH0AgAA
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

