Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaJ2KGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:06:35 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44815 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaJ2KGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:06:31 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: disable unused clocks
Date: Wed, 29 Oct 2014 18:06:07 +0800
Message-Id: <1414577167-25666-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
all the clocks are available like default power on state.
We have implement the clock manage in most of rockchip drivers,
it is time to remove it for power save.
Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
be on during boot or no module driver in kernel will initialize it.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk-rk3188.c |  32 ++++-----
 drivers/clk/rockchip/clk-rk3288.c | 146 +++++++++++++++++++-------------------
 drivers/clk/rockchip/clk.c        |   9 ---
 3 files changed, 90 insertions(+), 97 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index beed49c..0265a33 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -257,9 +257,9 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	GATE(0, "hclk_vdpu", "aclk_vdpu", 0,
 			RK2928_CLKGATE_CON(3), 12, GFLAGS),
 
-	GATE(0, "gpll_ddr", "gpll", 0,
+	GATE(0, "gpll_ddr", "gpll", CLK_IGNORE_UNUSED,
 			RK2928_CLKGATE_CON(1), 7, GFLAGS),
-	COMPOSITE(0, "ddrphy", mux_ddrphy_p, 0,
+	COMPOSITE(0, "ddrphy", mux_ddrphy_p, CLK_IGNORE_UNUSED,
 			RK2928_CLKSEL_CON(26), 8, 1, MFLAGS, 0, 2, DFLAGS | CLK_DIVIDER_POWER_OF_TWO,
 			RK2928_CLKGATE_CON(0), 2, GFLAGS),
 
@@ -270,10 +270,10 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 			RK2928_CLKGATE_CON(0), 6, GFLAGS),
 	GATE(0, "pclk_cpu", "pclk_cpu_pre", 0,
 			RK2928_CLKGATE_CON(0), 5, GFLAGS),
-	GATE(0, "hclk_cpu", "hclk_cpu_pre", 0,
+	GATE(0, "hclk_cpu", "hclk_cpu_pre", CLK_IGNORE_UNUSED,
 			RK2928_CLKGATE_CON(0), 4, GFLAGS),
 
-	COMPOSITE(0, "aclk_lcdc0_pre", mux_pll_src_cpll_gpll_p, 0,
+	COMPOSITE(0, "aclk_lcdc0_pre", mux_pll_src_cpll_gpll_p, CLK_IGNORE_UNUSED,
 			RK2928_CLKSEL_CON(31), 7, 1, MFLAGS, 0, 5, DFLAGS,
 			RK2928_CLKGATE_CON(3), 0, GFLAGS),
 	COMPOSITE(0, "aclk_lcdc1_pre", mux_pll_src_cpll_gpll_p, 0,
@@ -304,9 +304,9 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	 * the 480m are generated inside the usb block from these clocks,
 	 * but they are also a source for the hsicphy clock.
 	 */
-	GATE(SCLK_OTGPHY0, "sclk_otgphy0", "usb480m", 0,
+	GATE(SCLK_OTGPHY0, "sclk_otgphy0", "usb480m", CLK_IGNORE_UNUSED,
 			RK2928_CLKGATE_CON(1), 5, GFLAGS),
-	GATE(SCLK_OTGPHY1, "sclk_otgphy1", "usb480m", 0,
+	GATE(SCLK_OTGPHY1, "sclk_otgphy1", "usb480m", CLK_IGNORE_UNUSED,
 			RK2928_CLKGATE_CON(1), 6, GFLAGS),
 
 	COMPOSITE(0, "mac_src", mux_mac_p, 0,
@@ -399,7 +399,7 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 
 	/* aclk_cpu gates */
 	GATE(ACLK_DMA1, "aclk_dma1", "aclk_cpu", 0, RK2928_CLKGATE_CON(5), 0, GFLAGS),
-	GATE(0, "aclk_intmem", "aclk_cpu", 0, RK2928_CLKGATE_CON(4), 12, GFLAGS),
+	GATE(0, "aclk_intmem", "aclk_cpu", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 12, GFLAGS),
 	GATE(0, "aclk_strc_sys", "aclk_cpu", 0, RK2928_CLKGATE_CON(4), 10, GFLAGS),
 
 	/* hclk_cpu gates */
@@ -457,23 +457,23 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	GATE(0, "pclk_ddrupctl", "pclk_cpu", 0, RK2928_CLKGATE_CON(5), 7, GFLAGS),
 	GATE(0, "pclk_ddrpubl", "pclk_cpu", 0, RK2928_CLKGATE_CON(9), 6, GFLAGS),
 	GATE(0, "pclk_dbg", "pclk_cpu", 0, RK2928_CLKGATE_CON(9), 1, GFLAGS),
-	GATE(PCLK_GRF, "pclk_grf", "pclk_cpu", 0, RK2928_CLKGATE_CON(5), 4, GFLAGS),
-	GATE(PCLK_PMU, "pclk_pmu", "pclk_cpu", 0, RK2928_CLKGATE_CON(5), 5, GFLAGS),
+	GATE(PCLK_GRF, "pclk_grf", "pclk_cpu", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(5), 4, GFLAGS),
+	GATE(PCLK_PMU, "pclk_pmu", "pclk_cpu", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(5), 5, GFLAGS),
 
 	/* aclk_peri */
 	GATE(ACLK_DMA2, "aclk_dma2", "aclk_peri", 0, RK2928_CLKGATE_CON(5), 1, GFLAGS),
 	GATE(ACLK_SMC, "aclk_smc", "aclk_peri", 0, RK2928_CLKGATE_CON(5), 8, GFLAGS),
-	GATE(0, "aclk_peri_niu", "aclk_peri", 0, RK2928_CLKGATE_CON(4), 4, GFLAGS),
-	GATE(0, "aclk_cpu_peri", "aclk_peri", 0, RK2928_CLKGATE_CON(4), 2, GFLAGS),
-	GATE(0, "aclk_peri_axi_matrix", "aclk_peri", 0, RK2928_CLKGATE_CON(4), 3, GFLAGS),
+	GATE(0, "aclk_peri_niu", "aclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 4, GFLAGS),
+	GATE(0, "aclk_cpu_peri", "aclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 2, GFLAGS),
+	GATE(0, "aclk_peri_axi_matrix", "aclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 3, GFLAGS),
 
 	/* pclk_peri gates */
-	GATE(0, "pclk_peri_axi_matrix", "pclk_peri", 0, RK2928_CLKGATE_CON(4), 1, GFLAGS),
+	GATE(0, "pclk_peri_axi_matrix", "pclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 1, GFLAGS),
 	GATE(PCLK_PWM23, "pclk_pwm23", "pclk_peri", 0, RK2928_CLKGATE_CON(7), 11, GFLAGS),
 	GATE(PCLK_WDT, "pclk_wdt", "pclk_peri", 0, RK2928_CLKGATE_CON(7), 15, GFLAGS),
 	GATE(PCLK_SPI0, "pclk_spi0", "pclk_peri", 0, RK2928_CLKGATE_CON(7), 12, GFLAGS),
 	GATE(PCLK_SPI1, "pclk_spi1", "pclk_peri", 0, RK2928_CLKGATE_CON(7), 13, GFLAGS),
-	GATE(PCLK_UART2, "pclk_uart2", "pclk_peri", 0, RK2928_CLKGATE_CON(8), 2, GFLAGS),
+	GATE(PCLK_UART2, "pclk_uart2", "pclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(8), 2, GFLAGS),
 	GATE(PCLK_UART3, "pclk_uart3", "pclk_peri", 0, RK2928_CLKGATE_CON(8), 3, GFLAGS),
 	GATE(PCLK_I2C2, "pclk_i2c2", "pclk_peri", 0, RK2928_CLKGATE_CON(8), 6, GFLAGS),
 	GATE(PCLK_I2C3, "pclk_i2c3", "pclk_peri", 0, RK2928_CLKGATE_CON(8), 7, GFLAGS),
@@ -511,7 +511,7 @@ static struct rockchip_clk_branch rk3066a_clk_branches[] __initdata = {
 							    | CLK_DIVIDER_READ_ONLY,
 			RK2928_CLKGATE_CON(4), 9, GFLAGS),
 
-	GATE(CORE_L2C, "core_l2c", "aclk_cpu", 0,
+	GATE(CORE_L2C, "core_l2c", "aclk_cpu", CLK_IGNORE_UNUSED,
 			RK2928_CLKGATE_CON(9), 4, GFLAGS),
 
 	COMPOSITE(0, "aclk_peri_pre", mux_pll_src_gpll_cpll_p, 0,
@@ -633,7 +633,7 @@ static struct rockchip_clk_branch rk3188_clk_branches[] __initdata = {
 			RK2928_CLKSEL_CON(1), 14, 2, DFLAGS | CLK_DIVIDER_POWER_OF_TWO,
 			RK2928_CLKGATE_CON(4), 9, GFLAGS),
 
-	GATE(CORE_L2C, "core_l2c", "armclk", 0,
+	GATE(CORE_L2C, "core_l2c", "armclk", CLK_IGNORE_UNUSED,
 			RK2928_CLKGATE_CON(9), 4, GFLAGS),
 
 	COMPOSITE(0, "aclk_peri_pre", mux_pll_src_cpll_gpll_p, 0,
diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 4629182..472eb90 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -226,31 +226,33 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	 * Clock-Architecture Diagram 1
 	 */
 
-	GATE(0, "apll_core", "apll", 0,
+	GATE(0, "apll_core", "apll", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(0), 1, GFLAGS),
-	GATE(0, "gpll_core", "gpll", 0,
+	GATE(0, "gpll_core", "gpll", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(0), 2, GFLAGS),
+	COMPOSITE_NOGATE(0, "armclk", mux_armclk_p, CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(0), 15, 1, MFLAGS, 8, 5, DFLAGS),
 
-	COMPOSITE_NOMUX(0, "armcore0", "armclk", 0,
-			RK3288_CLKSEL_CON(36), 0, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
+	COMPOSITE_NOMUX(0, "armcore0", "armclk", CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(36), 0, 3, DFLAGS,
 			RK3288_CLKGATE_CON(12), 0, GFLAGS),
-	COMPOSITE_NOMUX(0, "armcore1", "armclk", 0,
-			RK3288_CLKSEL_CON(36), 4, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
+	COMPOSITE_NOMUX(0, "armcore1", "armclk", CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(36), 4, 3, DFLAGS,
 			RK3288_CLKGATE_CON(12), 1, GFLAGS),
-	COMPOSITE_NOMUX(0, "armcore2", "armclk", 0,
-			RK3288_CLKSEL_CON(36), 8, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
+	COMPOSITE_NOMUX(0, "armcore2", "armclk", CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(36), 8, 3, DFLAGS,
 			RK3288_CLKGATE_CON(12), 2, GFLAGS),
-	COMPOSITE_NOMUX(0, "armcore3", "armclk", 0,
-			RK3288_CLKSEL_CON(36), 12, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
+	COMPOSITE_NOMUX(0, "armcore3", "armclk", CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(36), 12, 3, DFLAGS,
 			RK3288_CLKGATE_CON(12), 3, GFLAGS),
-	COMPOSITE_NOMUX(0, "l2ram", "armclk", 0,
-			RK3288_CLKSEL_CON(37), 0, 3, DFLAGS | CLK_DIVIDER_READ_ONLY,
+	COMPOSITE_NOMUX(0, "l2ram", "armclk", CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(37), 0, 3, DFLAGS,
 			RK3288_CLKGATE_CON(12), 4, GFLAGS),
-	COMPOSITE_NOMUX(0, "aclk_core_m0", "armclk", 0,
-			RK3288_CLKSEL_CON(0), 0, 4, DFLAGS | CLK_DIVIDER_READ_ONLY,
+	COMPOSITE_NOMUX(0, "aclk_core_m0", "armclk", CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(0), 0, 4, DFLAGS,
 			RK3288_CLKGATE_CON(12), 5, GFLAGS),
-	COMPOSITE_NOMUX(0, "aclk_core_mp", "armclk", 0,
-			RK3288_CLKSEL_CON(0), 4, 4, DFLAGS | CLK_DIVIDER_READ_ONLY,
+	COMPOSITE_NOMUX(0, "aclk_core_mp", "armclk", CLK_IGNORE_UNUSED,
+			RK3288_CLKSEL_CON(0), 4, 4, DFLAGS,
 			RK3288_CLKGATE_CON(12), 6, GFLAGS),
 	COMPOSITE_NOMUX(0, "atclk", "armclk", 0,
 			RK3288_CLKSEL_CON(37), 4, 5, DFLAGS | CLK_DIVIDER_READ_ONLY,
@@ -265,28 +267,28 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(0, "pclk_core_niu", "pclk_dbg_pre", 0,
 			RK3288_CLKGATE_CON(12), 11, GFLAGS),
 
-	GATE(0, "dpll_ddr", "dpll", 0,
+	GATE(0, "dpll_ddr", "dpll", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(0), 8, GFLAGS),
 	GATE(0, "gpll_ddr", "gpll", 0,
 			RK3288_CLKGATE_CON(0), 9, GFLAGS),
-	COMPOSITE_NOGATE(0, "ddrphy", mux_ddrphy_p, 0,
+	COMPOSITE_NOGATE(0, "ddrphy", mux_ddrphy_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(26), 2, 1, MFLAGS, 0, 2,
 					DFLAGS | CLK_DIVIDER_POWER_OF_TWO),
 
-	GATE(0, "gpll_aclk_cpu", "gpll", 0,
+	GATE(0, "gpll_aclk_cpu", "gpll", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(0), 10, GFLAGS),
-	GATE(0, "cpll_aclk_cpu", "cpll", 0,
+	GATE(0, "cpll_aclk_cpu", "cpll", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(0), 11, GFLAGS),
-	COMPOSITE_NOGATE(0, "aclk_cpu_src", mux_aclk_cpu_src_p, 0,
+	COMPOSITE_NOGATE(0, "aclk_cpu_src", mux_aclk_cpu_src_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(1), 15, 1, MFLAGS, 3, 5, DFLAGS),
 	DIV(0, "aclk_cpu_pre", "aclk_cpu_src", 0,
 			RK3288_CLKSEL_CON(1), 0, 3, DFLAGS),
-	GATE(ACLK_CPU, "aclk_cpu", "aclk_cpu_pre", 0,
+	GATE(0, "aclk_cpu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(0), 3, GFLAGS),
-	COMPOSITE_NOMUX(PCLK_CPU, "pclk_cpu", "aclk_cpu_pre", 0,
+	COMPOSITE_NOMUX(0, "pclk_cpu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(1), 12, 3, DFLAGS,
 			RK3288_CLKGATE_CON(0), 5, GFLAGS),
-	COMPOSITE_NOMUX_DIVTBL(HCLK_CPU, "hclk_cpu", "aclk_cpu_pre", 0,
+	COMPOSITE_NOMUX_DIVTBL(0, "hclk_cpu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(1), 8, 2, DFLAGS, div_hclk_cpu_t,
 			RK3288_CLKGATE_CON(0), 4, GFLAGS),
 	GATE(0, "c2c_host", "aclk_cpu_src", 0,
@@ -294,7 +296,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE_NOMUX(0, "crypto", "aclk_cpu_pre", 0,
 			RK3288_CLKSEL_CON(26), 6, 2, DFLAGS,
 			RK3288_CLKGATE_CON(5), 4, GFLAGS),
-	GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", 0,
+	GATE(0, "aclk_bus_2pmu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(0), 7, GFLAGS),
 
 	COMPOSITE(0, "i2s_src", mux_pll_src_cpll_gpll_p, 0,
@@ -373,12 +375,12 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(HCLK_VCODEC, "hclk_vcodec", "hclk_vcodec_pre", 0,
 		RK3288_CLKGATE_CON(9), 1, GFLAGS),
 
-	COMPOSITE(0, "aclk_vio0", mux_pll_src_cpll_gpll_usb480m_p, 0,
+	COMPOSITE(0, "aclk_vio0", mux_pll_src_cpll_gpll_usb480m_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(31), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 0, GFLAGS),
 	DIV(0, "hclk_vio", "aclk_vio0", 0,
 			RK3288_CLKSEL_CON(28), 8, 5, DFLAGS),
-	COMPOSITE(0, "aclk_vio1", mux_pll_src_cpll_gpll_usb480m_p, 0,
+	COMPOSITE(0, "aclk_vio1", mux_pll_src_cpll_gpll_usb480m_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(31), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 2, GFLAGS),
 
@@ -389,10 +391,10 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(30), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 4, GFLAGS),
 
-	COMPOSITE(DCLK_VOP0, "dclk_vop0", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(DCLK_VOP0, "dclk_vop0", mux_pll_src_cpll_gpll_npll_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(27), 0, 2, MFLAGS, 8, 8, DFLAGS,
 			RK3288_CLKGATE_CON(3), 1, GFLAGS),
-	COMPOSITE(DCLK_VOP1, "dclk_vop1", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(DCLK_VOP1, "dclk_vop1", mux_pll_src_cpll_gpll_npll_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(29), 6, 2, MFLAGS, 8, 8, DFLAGS,
 			RK3288_CLKGATE_CON(3), 3, GFLAGS),
 
@@ -436,7 +438,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 
 	DIV(0, "pclk_pd_alive", "gpll", 0,
 			RK3288_CLKSEL_CON(33), 8, 5, DFLAGS),
-	COMPOSITE_NOMUX(0, "pclk_pd_pmu", "gpll", 0,
+	COMPOSITE_NOMUX(0, "pclk_pd_pmu", "gpll", CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(33), 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(5), 8, GFLAGS),
 
@@ -444,16 +446,16 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(34), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(5), 7, GFLAGS),
 
-	COMPOSITE(0, "aclk_peri_src", mux_pll_src_cpll_gpll_p, 0,
+	COMPOSITE(0, "aclk_peri_src", mux_pll_src_cpll_gpll_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(10), 15, 1, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(2), 0, GFLAGS),
 	COMPOSITE_NOMUX(PCLK_PERI, "pclk_peri", "aclk_peri_src", 0,
 			RK3288_CLKSEL_CON(10), 12, 2, DFLAGS | CLK_DIVIDER_POWER_OF_TWO,
 			RK3288_CLKGATE_CON(2), 3, GFLAGS),
-	COMPOSITE_NOMUX(HCLK_PERI, "hclk_peri", "aclk_peri_src", 0,
+	COMPOSITE_NOMUX(0, "hclk_peri", "aclk_peri_src", CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(10), 8, 2, DFLAGS | CLK_DIVIDER_POWER_OF_TWO,
 			RK3288_CLKGATE_CON(2), 2, GFLAGS),
-	GATE(ACLK_PERI, "aclk_peri", "aclk_peri_src", 0,
+	GATE(0, "aclk_peri", "aclk_peri_src", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(2), 1, GFLAGS),
 
 	/*
@@ -479,7 +481,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(SCLK_SDIO1, "sclk_sdio1", mux_mmc_src_p, 0,
 			RK3288_CLKSEL_CON(34), 14, 2, MFLAGS, 8, 6, DFLAGS,
 			RK3288_CLKGATE_CON(13), 2, GFLAGS),
-	COMPOSITE(SCLK_EMMC, "sclk_emmc", mux_mmc_src_p, 0,
+	COMPOSITE(SCLK_EMMC, "sclk_emmc", mux_mmc_src_p, CLK_IGNORE_UNUSED,
 			RK3288_CLKSEL_CON(12), 14, 2, MFLAGS, 8, 6, DFLAGS,
 			RK3288_CLKGATE_CON(13), 3, GFLAGS),
 
@@ -490,13 +492,13 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(35), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(4), 10, GFLAGS),
 
-	GATE(SCLK_OTGPHY0, "sclk_otgphy0", "usb480m", 0,
+	GATE(SCLK_OTGPHY0, "sclk_otgphy0", "usb480m", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(13), 4, GFLAGS),
-	GATE(SCLK_OTGPHY1, "sclk_otgphy1", "usb480m", 0,
+	GATE(SCLK_OTGPHY1, "sclk_otgphy1", "usb480m", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(13), 5, GFLAGS),
-	GATE(SCLK_OTGPHY2, "sclk_otgphy2", "usb480m", 0,
+	GATE(SCLK_OTGPHY2, "sclk_otgphy2", "usb480m", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(13), 6, GFLAGS),
-	GATE(SCLK_OTG_ADP, "sclk_otg_adp", "xin32k", 0,
+	GATE(SCLK_OTG_ADP, "sclk_otg_adp", "xin32k", CLK_IGNORE_UNUSED,
 			RK3288_CLKGATE_CON(13), 7, GFLAGS),
 
 	COMPOSITE_NOMUX(SCLK_TSADC, "sclk_tsadc", "xin32k", 0,
@@ -601,19 +603,19 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	 */
 
 	/* aclk_cpu gates */
-	GATE(0, "sclk_intmem0", "aclk_cpu", 0, RK3288_CLKGATE_CON(10), 5, GFLAGS),
-	GATE(0, "sclk_intmem1", "aclk_cpu", 0, RK3288_CLKGATE_CON(10), 6, GFLAGS),
-	GATE(0, "sclk_intmem2", "aclk_cpu", 0, RK3288_CLKGATE_CON(10), 7, GFLAGS),
+	GATE(0, "sclk_intmem0", "aclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 5, GFLAGS),
+	GATE(0, "sclk_intmem1", "aclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 6, GFLAGS),
+	GATE(0, "sclk_intmem2", "aclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 7, GFLAGS),
 	GATE(ACLK_DMAC1, "aclk_dmac1", "aclk_cpu", 0, RK3288_CLKGATE_CON(10), 12, GFLAGS),
-	GATE(0, "aclk_strc_sys", "aclk_cpu", 0, RK3288_CLKGATE_CON(10), 13, GFLAGS),
-	GATE(0, "aclk_intmem", "aclk_cpu", 0, RK3288_CLKGATE_CON(10), 4, GFLAGS),
+	GATE(0, "aclk_strc_sys", "aclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 13, GFLAGS),
+	GATE(0, "aclk_intmem", "aclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 4, GFLAGS),
 	GATE(ACLK_CRYPTO, "aclk_crypto", "aclk_cpu", 0, RK3288_CLKGATE_CON(11), 6, GFLAGS),
 	GATE(0, "aclk_ccp", "aclk_cpu", 0, RK3288_CLKGATE_CON(11), 8, GFLAGS),
 
 	/* hclk_cpu gates */
 	GATE(HCLK_CRYPTO, "hclk_crypto", "hclk_cpu", 0, RK3288_CLKGATE_CON(11), 7, GFLAGS),
 	GATE(HCLK_I2S0, "hclk_i2s0", "hclk_cpu", 0, RK3288_CLKGATE_CON(10), 8, GFLAGS),
-	GATE(HCLK_ROM, "hclk_rom", "hclk_cpu", 0, RK3288_CLKGATE_CON(10), 9, GFLAGS),
+	GATE(HCLK_ROM, "hclk_rom", "hclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 9, GFLAGS),
 	GATE(HCLK_SPDIF, "hclk_spdif", "hclk_cpu", 0, RK3288_CLKGATE_CON(10), 10, GFLAGS),
 	GATE(HCLK_SPDIF8CH, "hclk_spdif_8ch", "hclk_cpu", 0, RK3288_CLKGATE_CON(10), 11, GFLAGS),
 
@@ -622,42 +624,42 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_TIMER, "pclk_timer", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 1, GFLAGS),
 	GATE(PCLK_I2C0, "pclk_i2c0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 2, GFLAGS),
 	GATE(PCLK_I2C2, "pclk_i2c2", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 3, GFLAGS),
-	GATE(0, "pclk_ddrupctl0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 14, GFLAGS),
-	GATE(0, "pclk_publ0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 15, GFLAGS),
-	GATE(0, "pclk_ddrupctl1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 0, GFLAGS),
-	GATE(0, "pclk_publ1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 1, GFLAGS),
+	GATE(0, "pclk_ddrupctl0", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 14, GFLAGS),
+	GATE(0, "pclk_publ0", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(10), 15, GFLAGS),
+	GATE(0, "pclk_ddrupctl1", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 0, GFLAGS),
+	GATE(0, "pclk_publ1", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 1, GFLAGS),
 	GATE(0, "pclk_efuse_1024", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 2, GFLAGS),
 	GATE(PCLK_TZPC, "pclk_tzpc", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 3, GFLAGS),
-	GATE(PCLK_UART2, "pclk_uart2", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 9, GFLAGS),
+	GATE(PCLK_UART2, "pclk_uart2", "pclk_cpu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 9, GFLAGS),
 	GATE(0, "pclk_efuse_256", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 10, GFLAGS),
 	GATE(PCLK_RKPWM, "pclk_rkpwm", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 11, GFLAGS),
 
 	/* ddrctrl [DDR Controller PHY clock] gates */
-	GATE(0, "nclk_ddrupctl0", "ddrphy", 0, RK3288_CLKGATE_CON(11), 4, GFLAGS),
-	GATE(0, "nclk_ddrupctl1", "ddrphy", 0, RK3288_CLKGATE_CON(11), 5, GFLAGS),
+	GATE(0, "nclk_ddrupctl0", "ddrphy", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 4, GFLAGS),
+	GATE(0, "nclk_ddrupctl1", "ddrphy", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(11), 5, GFLAGS),
 
 	/* ddrphy gates */
-	GATE(0, "sclk_ddrphy0", "ddrphy", 0, RK3288_CLKGATE_CON(4), 12, GFLAGS),
-	GATE(0, "sclk_ddrphy1", "ddrphy", 0, RK3288_CLKGATE_CON(4), 13, GFLAGS),
+	GATE(0, "sclk_ddrphy0", "ddrphy", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(4), 12, GFLAGS),
+	GATE(0, "sclk_ddrphy1", "ddrphy", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(4), 13, GFLAGS),
 
 	/* aclk_peri gates */
-	GATE(0, "aclk_peri_axi_matrix", "aclk_peri", 0, RK3288_CLKGATE_CON(6), 2, GFLAGS),
+	GATE(0, "aclk_peri_axi_matrix", "aclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(6), 2, GFLAGS),
 	GATE(ACLK_DMAC2, "aclk_dmac2", "aclk_peri", 0, RK3288_CLKGATE_CON(6), 3, GFLAGS),
-	GATE(0, "aclk_peri_niu", "aclk_peri", 0, RK3288_CLKGATE_CON(7), 11, GFLAGS),
-	GATE(ACLK_MMU, "aclk_mmu", "aclk_peri", 0, RK3288_CLKGATE_CON(8), 12, GFLAGS),
+	GATE(0, "aclk_peri_niu", "aclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 11, GFLAGS),
+	GATE(ACLK_MMU, "aclk_mmu", "aclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(8), 12, GFLAGS),
 	GATE(ACLK_GMAC, "aclk_gmac", "aclk_peri", 0, RK3288_CLKGATE_CON(8), 0, GFLAGS),
 	GATE(HCLK_GPS, "hclk_gps", "aclk_peri", 0, RK3288_CLKGATE_CON(8), 2, GFLAGS),
 
 	/* hclk_peri gates */
-	GATE(0, "hclk_peri_matrix", "hclk_peri", 0, RK3288_CLKGATE_CON(6), 0, GFLAGS),
+	GATE(0, "hclk_peri_matrix", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(6), 0, GFLAGS),
 	GATE(HCLK_OTG0, "hclk_otg0", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 4, GFLAGS),
 	GATE(HCLK_USBHOST0, "hclk_host0", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 6, GFLAGS),
 	GATE(HCLK_USBHOST1, "hclk_host1", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 7, GFLAGS),
 	GATE(HCLK_HSIC, "hclk_hsic", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 8, GFLAGS),
-	GATE(0, "hclk_usb_peri", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 9, GFLAGS),
-	GATE(0, "hclk_peri_ahb_arbi", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 10, GFLAGS),
-	GATE(0, "hclk_emem", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 12, GFLAGS),
-	GATE(0, "hclk_mem", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 13, GFLAGS),
+	GATE(0, "hclk_usb_peri", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 9, GFLAGS),
+	GATE(0, "hclk_peri_ahb_arbi", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 10, GFLAGS),
+	GATE(0, "hclk_emem", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 12, GFLAGS),
+	GATE(0, "hclk_mem", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 13, GFLAGS),
 	GATE(HCLK_NANDC0, "hclk_nandc0", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 14, GFLAGS),
 	GATE(HCLK_NANDC1, "hclk_nandc1", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 15, GFLAGS),
 	GATE(HCLK_TSP, "hclk_tsp", "hclk_peri", 0, RK3288_CLKGATE_CON(8), 8, GFLAGS),
@@ -669,7 +671,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(0, "pmu_hclk_otg0", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 5, GFLAGS),
 
 	/* pclk_peri gates */
-	GATE(0, "pclk_peri_matrix", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 1, GFLAGS),
+	GATE(0, "pclk_peri_matrix", "pclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(6), 1, GFLAGS),
 	GATE(PCLK_SPI0, "pclk_spi0", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 4, GFLAGS),
 	GATE(PCLK_SPI1, "pclk_spi1", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 5, GFLAGS),
 	GATE(PCLK_SPI2, "pclk_spi2", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 6, GFLAGS),
@@ -705,22 +707,22 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_GPIO4, "pclk_gpio4", "pclk_pd_alive", 0, RK3288_CLKGATE_CON(14), 4, GFLAGS),
 	GATE(PCLK_GPIO5, "pclk_gpio5", "pclk_pd_alive", 0, RK3288_CLKGATE_CON(14), 5, GFLAGS),
 	GATE(PCLK_GPIO6, "pclk_gpio6", "pclk_pd_alive", 0, RK3288_CLKGATE_CON(14), 6, GFLAGS),
-	GATE(PCLK_GRF, "pclk_grf", "pclk_pd_alive", 0, RK3288_CLKGATE_CON(14), 11, GFLAGS),
-	GATE(0, "pclk_alive_niu", "pclk_pd_alive", 0, RK3288_CLKGATE_CON(14), 12, GFLAGS),
+	GATE(PCLK_GRF, "pclk_grf", "pclk_pd_alive", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(14), 11, GFLAGS),
+	GATE(0, "pclk_alive_niu", "pclk_pd_alive", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(14), 12, GFLAGS),
 
 	/* pclk_pd_pmu gates */
-	GATE(PCLK_PMU, "pclk_pmu", "pclk_pd_pmu", 0, RK3288_CLKGATE_CON(17), 0, GFLAGS),
-	GATE(0, "pclk_intmem1", "pclk_pd_pmu", 0, RK3288_CLKGATE_CON(17), 1, GFLAGS),
-	GATE(0, "pclk_pmu_niu", "pclk_pd_pmu", 0, RK3288_CLKGATE_CON(17), 2, GFLAGS),
-	GATE(PCLK_SGRF, "pclk_sgrf", "pclk_pd_pmu", 0, RK3288_CLKGATE_CON(17), 3, GFLAGS),
+	GATE(PCLK_PMU, "pclk_pmu", "pclk_pd_pmu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(17), 0, GFLAGS),
+	GATE(0, "pclk_intmem1", "pclk_pd_pmu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(17), 1, GFLAGS),
+	GATE(0, "pclk_pmu_niu", "pclk_pd_pmu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(17), 2, GFLAGS),
+	GATE(PCLK_SGRF, "pclk_sgrf", "pclk_pd_pmu", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(17), 3, GFLAGS),
 	GATE(PCLK_GPIO0, "pclk_gpio0", "pclk_pd_pmu", 0, RK3288_CLKGATE_CON(17), 4, GFLAGS),
 
 	/* hclk_vio gates */
 	GATE(HCLK_RGA, "hclk_rga", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 1, GFLAGS),
 	GATE(HCLK_VOP0, "hclk_vop0", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 6, GFLAGS),
-	GATE(HCLK_VOP1, "hclk_vop1", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 8, GFLAGS),
-	GATE(HCLK_VIO_AHB_ARBI, "hclk_vio_ahb_arbi", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 9, GFLAGS),
-	GATE(HCLK_VIO_NIU, "hclk_vio_niu", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 10, GFLAGS),
+	GATE(HCLK_VOP1, "hclk_vop1", "hclk_vio", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(15), 8, GFLAGS),
+	GATE(HCLK_VIO_AHB_ARBI, "hclk_vio_ahb_arbi", "hclk_vio", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(15), 9, GFLAGS),
+	GATE(HCLK_VIO_NIU, "hclk_vio_niu", "hclk_vio", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(15), 10, GFLAGS),
 	GATE(HCLK_VIP, "hclk_vip", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 15, GFLAGS),
 	GATE(HCLK_IEP, "hclk_iep", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 3, GFLAGS),
 	GATE(HCLK_ISP, "hclk_isp", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 1, GFLAGS),
@@ -729,7 +731,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_MIPI_DSI1, "pclk_mipi_dsi1", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 5, GFLAGS),
 	GATE(PCLK_MIPI_CSI, "pclk_mipi_csi", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 6, GFLAGS),
 	GATE(PCLK_LVDS_PHY, "pclk_lvds_phy", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 7, GFLAGS),
-	GATE(PCLK_EDP_CTRL, "pclk_edp_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 8, GFLAGS),
+	GATE(PCLK_EDP_CTRL, "pclk_edp_ctrl", "hclk_vio", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(16), 8, GFLAGS),
 	GATE(PCLK_HDMI_CTRL, "pclk_hdmi_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 9, GFLAGS),
 	GATE(PCLK_VIO2_H2P, "pclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 11, GFLAGS),
 
diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index 1e68bff..dec6f8d6 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -246,9 +246,6 @@ void __init rockchip_clk_register_branches(
 					list->div_flags, &clk_lock);
 			break;
 		case branch_fraction_divider:
-			/* keep all gates untouched for now */
-			flags |= CLK_IGNORE_UNUSED;
-
 			clk = rockchip_clk_register_frac_branch(list->name,
 				list->parent_names, list->num_parents,
 				reg_base, list->muxdiv_offset, list->div_flags,
@@ -258,18 +255,12 @@ void __init rockchip_clk_register_branches(
 		case branch_gate:
 			flags |= CLK_SET_RATE_PARENT;
 
-			/* keep all gates untouched for now */
-			flags |= CLK_IGNORE_UNUSED;
-
 			clk = clk_register_gate(NULL, list->name,
 				list->parent_names[0], flags,
 				reg_base + list->gate_offset,
 				list->gate_shift, list->gate_flags, &clk_lock);
 			break;
 		case branch_composite:
-			/* keep all gates untouched for now */
-			flags |= CLK_IGNORE_UNUSED;
-
 			clk = rockchip_clk_register_branch(list->name,
 				list->parent_names, list->num_parents,
 				reg_base, list->muxdiv_offset, list->mux_shift,
-- 
1.9.1

