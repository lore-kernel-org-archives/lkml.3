Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaKQO4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:56:12 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53783 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaKQO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:56:07 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org, tomeu.vizoso@collabora.com,
        sboyd@codeaurora.org, Kever Yang <kever.yang@rock-chips.com>,
        Dmitry Torokhov <dtor@chromium.org>, Jianqun <jay.xu@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] clk: rockchip: leave npll for VOP0 only
Date: Mon, 17 Nov 2014 22:55:37 +0800
Message-Id: <1416236138-11010-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416236138-11010-1-git-send-email-kever.yang@rock-chips.com>
References: <1416236138-11010-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will need a pll to support all kinds of clock rate requirement
for HDMI(from DCLK_VOP0) which may change the rate at run time.

In order not to affect other clocks, remove the npll from the
parent list of other clocks and only DCLK_VOP0 can select npll
as parent.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk-rk3288.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index b4a74c2..6eb1407 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -174,7 +174,7 @@ PNAME(mux_ddrphy_p)		= { "dpll_ddr", "gpll_ddr" };
 PNAME(mux_aclk_cpu_src_p)	= { "cpll_aclk_cpu", "gpll_aclk_cpu" };
 
 PNAME(mux_pll_src_cpll_gpll_p)		= { "cpll", "gpll" };
-PNAME(mux_pll_src_npll_cpll_gpll_p)	= { "npll", "cpll", "gpll" };
+PNAME(mux_pll_src_npll_cpll_gpll_p)	= { "dummy", "cpll", "gpll" };
 PNAME(mux_pll_src_cpll_gpll_npll_p)	= { "cpll", "gpll", "npll" };
 PNAME(mux_pll_src_cpll_gpll_usb480m_p)	= { "cpll", "gpll", "usbphy480m_src" };
 PNAME(mux_pll_src_cpll_gll_usb_npll_p)	= { "cpll", "gpll", "usbphy480m_src", "npll" };
@@ -392,24 +392,24 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(30), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 4, GFLAGS),
 
-	COMPOSITE(DCLK_VOP0, "dclk_vop0", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(DCLK_VOP0, "dclk_vop0", mux_pll_src_cpll_gpll_npll_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(27), 0, 2, MFLAGS, 8, 8, DFLAGS,
 			RK3288_CLKGATE_CON(3), 1, GFLAGS),
-	COMPOSITE(DCLK_VOP1, "dclk_vop1", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(DCLK_VOP1, "dclk_vop1", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(29), 6, 2, MFLAGS, 8, 8, DFLAGS,
 			RK3288_CLKGATE_CON(3), 3, GFLAGS),
 
 	COMPOSITE_NODIV(SCLK_EDP_24M, "sclk_edp_24m", mux_edp_24m_p, 0,
 			RK3288_CLKSEL_CON(28), 15, 1, MFLAGS,
 			RK3288_CLKGATE_CON(3), 12, GFLAGS),
-	COMPOSITE(SCLK_EDP, "sclk_edp", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_EDP, "sclk_edp", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(28), 6, 2, MFLAGS, 0, 6, DFLAGS,
 			RK3288_CLKGATE_CON(3), 13, GFLAGS),
 
-	COMPOSITE(SCLK_ISP, "sclk_isp", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_ISP, "sclk_isp", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(6), 6, 2, MFLAGS, 0, 6, DFLAGS,
 			RK3288_CLKGATE_CON(3), 14, GFLAGS),
-	COMPOSITE(SCLK_ISP_JPE, "sclk_isp_jpe", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_ISP_JPE, "sclk_isp_jpe", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(6), 14, 2, MFLAGS, 8, 6, DFLAGS,
 			RK3288_CLKGATE_CON(3), 15, GFLAGS),
 
@@ -418,16 +418,16 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(SCLK_HDMI_CEC, "sclk_hdmi_cec", "xin32k", 0,
 			RK3288_CLKGATE_CON(5), 11, GFLAGS),
 
-	COMPOSITE(ACLK_HEVC, "aclk_hevc", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(ACLK_HEVC, "aclk_hevc", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(39), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(13), 13, GFLAGS),
 	DIV(HCLK_HEVC, "hclk_hevc", "aclk_hevc", 0,
 			RK3288_CLKSEL_CON(40), 12, 2, DFLAGS),
 
-	COMPOSITE(SCLK_HEVC_CABAC, "sclk_hevc_cabac", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_HEVC_CABAC, "sclk_hevc_cabac", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(42), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(13), 14, GFLAGS),
-	COMPOSITE(SCLK_HEVC_CORE, "sclk_hevc_core", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_HEVC_CORE, "sclk_hevc_core", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(42), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(13), 15, GFLAGS),
 
@@ -443,7 +443,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(33), 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(5), 8, GFLAGS),
 
-	COMPOSITE(SCLK_GPU, "sclk_gpu", mux_pll_src_cpll_gll_usb_npll_p, 0,
+	COMPOSITE(SCLK_GPU, "sclk_gpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
 			RK3288_CLKSEL_CON(34), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(5), 7, GFLAGS),
 
@@ -489,7 +489,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(0, "sclk_tspout", mux_tspout_p, 0,
 			RK3288_CLKSEL_CON(35), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(4), 11, GFLAGS),
-	COMPOSITE(0, "sclk_tsp", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(0, "sclk_tsp", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(35), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(4), 10, GFLAGS),
 
@@ -520,7 +520,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(38), 15, 1, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(5), 6, GFLAGS),
 
-	COMPOSITE(0, "uart0_src", mux_pll_src_cpll_gll_usb_npll_p, 0,
+	COMPOSITE(0, "uart0_src", mux_pll_src_cpll_gpll_usb480m_p, 0,
 			RK3288_CLKSEL_CON(13), 13, 2, MFLAGS, 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(1), 8, GFLAGS),
 	COMPOSITE_FRAC(0, "uart0_frac", "uart0_src", 0,
-- 
1.9.1

