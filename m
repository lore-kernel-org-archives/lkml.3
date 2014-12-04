Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbaLDVdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:33:20 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42335 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaLDVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:33:17 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        kever.yang@rock-chips.com
Cc: jay.xu@rock-chips.com, caesar.wang@rock-chips.com,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: Add CLK_SET_RATE_PARENT to sclk_uart clocks
Date: Thu,  4 Dec 2014 13:33:05 -0800
Message-Id: <1417728785-18054-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd like to be able to set the clock rate of the sclk_uart clocks and
actually be able to achieve clock rates greater than 24MHz.  To do
this we need to be able to pass rate changes upward.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index ac6be7c..1b48f35 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -535,44 +535,44 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(0, "uart0_src", mux_pll_src_cpll_gll_usb_npll_p, 0,
 			RK3288_CLKSEL_CON(13), 13, 2, MFLAGS, 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(1), 8, GFLAGS),
-	COMPOSITE_FRAC(0, "uart0_frac", "uart0_src", 0,
+	COMPOSITE_FRAC(0, "uart0_frac", "uart0_src", CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(17), 0,
 			RK3288_CLKGATE_CON(1), 9, GFLAGS),
-	MUX(SCLK_UART0, "sclk_uart0", mux_uart0_p, 0,
+	MUX(SCLK_UART0, "sclk_uart0", mux_uart0_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(13), 8, 2, MFLAGS),
 	MUX(0, "uart_src", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(13), 15, 1, MFLAGS),
 	COMPOSITE_NOMUX(0, "uart1_src", "uart_src", 0,
 			RK3288_CLKSEL_CON(14), 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(1), 10, GFLAGS),
-	COMPOSITE_FRAC(0, "uart1_frac", "uart1_src", 0,
+	COMPOSITE_FRAC(0, "uart1_frac", "uart1_src", CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(18), 0,
 			RK3288_CLKGATE_CON(1), 11, GFLAGS),
-	MUX(SCLK_UART1, "sclk_uart1", mux_uart1_p, 0,
+	MUX(SCLK_UART1, "sclk_uart1", mux_uart1_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(14), 8, 2, MFLAGS),
 	COMPOSITE_NOMUX(0, "uart2_src", "uart_src", 0,
 			RK3288_CLKSEL_CON(15), 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(1), 12, GFLAGS),
-	COMPOSITE_FRAC(0, "uart2_frac", "uart2_src", 0,
+	COMPOSITE_FRAC(0, "uart2_frac", "uart2_src", CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(19), 0,
 			RK3288_CLKGATE_CON(1), 13, GFLAGS),
-	MUX(SCLK_UART2, "sclk_uart2", mux_uart2_p, 0,
+	MUX(SCLK_UART2, "sclk_uart2", mux_uart2_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(15), 8, 2, MFLAGS),
 	COMPOSITE_NOMUX(0, "uart3_src", "uart_src", 0,
 			RK3288_CLKSEL_CON(16), 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(1), 14, GFLAGS),
-	COMPOSITE_FRAC(0, "uart3_frac", "uart3_src", 0,
+	COMPOSITE_FRAC(0, "uart3_frac", "uart3_src", CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(20), 0,
 			RK3288_CLKGATE_CON(1), 15, GFLAGS),
-	MUX(SCLK_UART3, "sclk_uart3", mux_uart3_p, 0,
+	MUX(SCLK_UART3, "sclk_uart3", mux_uart3_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(16), 8, 2, MFLAGS),
 	COMPOSITE_NOMUX(0, "uart4_src", "uart_src", 0,
 			RK3288_CLKSEL_CON(3), 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(2), 12, GFLAGS),
-	COMPOSITE_FRAC(0, "uart4_frac", "uart4_src", 0,
+	COMPOSITE_FRAC(0, "uart4_frac", "uart4_src", CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(7), 0,
 			RK3288_CLKGATE_CON(2), 13, GFLAGS),
-	MUX(SCLK_UART4, "sclk_uart4", mux_uart4_p, 0,
+	MUX(SCLK_UART4, "sclk_uart4", mux_uart4_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(3), 8, 2, MFLAGS),
 
 	COMPOSITE(0, "mac_src", mux_pll_src_npll_cpll_gpll_p, 0,
-- 
2.2.0.rc0.207.ga3a616c

