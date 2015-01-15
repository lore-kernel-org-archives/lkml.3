Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbbAOBxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:53:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:29070 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbAOBvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:09 -0500
X-AuditID: cbfee68d-f79296d000004278-1c-54b71d0816b0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 4/9] clk: samsung: exynos4: Add divider clock id for memory
 bus frequency
Date: Thu, 15 Jan 2015 10:50:52 +0900
Message-id: <1421286657-4720-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkQJdDdnuIwcrllhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLw2/aWS1W7frD6CDosWbeGkaPnbPusnss3vOSyWPTqk42j81L6j36
	tqxi9Pi8SS6APYrLJiU1J7MstUjfLoEro+XSR6aCs5IVt+7dYmpgvCzaxcjBISFgIrHhv2AX
	IyeQKSZx4d56NhBbSGApo8TLjgiIuInE/jv7WLsYuYDi0xkl5m76zgpR1MQk8bQpG8RmE9CS
	2P/iBliziICeROexPewgDcwCK5klDjU+ZQJJCAvESczYu40RxGYRUJW4sWQJWAOvgIvEwV/T
	2CC2KUgsWz4TbAGngKtEz6/97BDLXCRW3Z3MCDJUQuAju8TJlkNsEIMEJL5NPsQC8Y2sxKYD
	zBBzJCUOrrjBMoFReAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwMg6/e9Z7w7G2wes
	DzEKcDAq8fA6HNkaIsSaWFZcmXuI0RRow0RmKdHkfGD85pXEGxqbGVmYmpgaG5lbmimJ8ypK
	/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOjnaet38+BiOZvzvFw62+9HpszcJHBshs7C
	N0sWZaqHb91YMUfp/JoF2WIJHQ/8th5ZUK2ziTNA22XCR8+PP1UfpR+5mbM563fv/r3fXqU1
	9olN9N/AGrykZGNC1EumptaOkITUA39NjBcYierahIqYG01O+r9h6VlOpoe3txnuZ241rNr3
	hkGJpTgj0VCLuag4EQCRUyb3pwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQV0O2e0hBg/XGFk8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtDr9pZ7VYtesPo4Ogx5p5axg9ds66y+6xeM9LJo9NqzrZPDYvqffo
	27KK0ePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBktlz4yFZyV
	rLh17xZTA+Nl0S5GTg4JAROJ/Xf2sULYYhIX7q1n62Lk4hASmM4oMXfTd7CEkEATk8TTpmwQ
	m01AS2L/ixtsILaIgJ5E57E97CANzAIrmSUONT5lAkkIC8RJzNi7jRHEZhFQlbixZAlYA6+A
	i8TBX9PYILYpSCxbPhNsAaeAq0TPr/3sEMtcJFbdncw4gZF3ASPDKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzg2H0mtYNxZYPFIUYBDkYlHl6HI1tDhFgTy4orcw8xSnAwK4nwvv20LUSI
	NyWxsiq1KD++qDQntfgQoynQVROZpUST84FpJa8k3tDYxMzI0sjc0MLI2FxJnFfJvi1ESCA9
	sSQ1OzW1ILUIpo+Jg1OqgTF7jshbt4r440Hf/jp0MmgYbfdfnt0Q4L+qJNtYdsmTm3ET7c48
	Vz9wqWH12egwgyV9RXfbnMyYgnvuGuYlSzt2vJn5MdTEO/hiYHrhzQmup06HfzfT0Yx0k/Ce
	LDbz1zOepqV5jNrrRWsKnXbZzJponO03eeuLJa2bJ7N6hzLb3Npa/lytRImlOCPRUIu5qDgR
	ADAc2A7zAgAA
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

