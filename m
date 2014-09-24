Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaIXPd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:33:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59380 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaIXPd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:33:57 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] clk: rockchip: use the clock id for nodes init
Date: Wed, 24 Sep 2014 23:33:21 +0800
Message-Id: <1411572802-22042-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com>
References: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use the new defined clock ID to initial the clock nodes.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---

Changes in v2:
- split into two patches of add clock node in PD_VIDEO and
  use new defined clock ID

 drivers/clk/rockchip/clk-rk3288.c | 68 +++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 8ea885b..d691a56 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -219,12 +219,12 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(1), 15, 1, MFLAGS, 3, 5, DFLAGS),
 	DIV(0, "aclk_cpu_pre", "aclk_cpu_src", 0,
 			RK3288_CLKSEL_CON(1), 0, 3, DFLAGS),
-	GATE(0, "aclk_cpu", "aclk_cpu_pre", 0,
+	GATE(ACLK_CPU, "aclk_cpu", "aclk_cpu_pre", 0,
 			RK3288_CLKGATE_CON(0), 3, GFLAGS),
-	COMPOSITE_NOMUX(0, "pclk_cpu", "aclk_cpu_pre", 0,
+	COMPOSITE_NOMUX(PCLK_CPU, "pclk_cpu", "aclk_cpu_pre", 0,
 			RK3288_CLKSEL_CON(1), 12, 3, DFLAGS,
 			RK3288_CLKGATE_CON(0), 5, GFLAGS),
-	COMPOSITE_NOMUX_DIVTBL(0, "hclk_cpu", "aclk_cpu_pre", 0,
+	COMPOSITE_NOMUX_DIVTBL(HCLK_CPU, "hclk_cpu", "aclk_cpu_pre", 0,
 			RK3288_CLKSEL_CON(1), 8, 2, DFLAGS, div_hclk_cpu_t,
 			RK3288_CLKGATE_CON(0), 4, GFLAGS),
 	GATE(0, "c2c_host", "aclk_cpu_src", 0,
@@ -309,7 +309,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(0, "aclk_rga_pre", mux_pll_src_cpll_gpll_usb480m_p, 0,
 			RK3288_CLKSEL_CON(30), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 5, GFLAGS),
-	COMPOSITE(0, "sclk_rga", mux_pll_src_cpll_gpll_usb480m_p, 0,
+	COMPOSITE(SCLK_RGA, "sclk_rga", mux_pll_src_cpll_gpll_usb480m_p, 0,
 			RK3288_CLKSEL_CON(30), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 4, GFLAGS),
 
@@ -320,35 +320,35 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(29), 6, 2, MFLAGS, 8, 8, DFLAGS,
 			RK3288_CLKGATE_CON(3), 3, GFLAGS),
 
-	COMPOSITE_NODIV(0, "sclk_edp_24m", mux_edp_24m_p, 0,
+	COMPOSITE_NODIV(SCLK_EDP_24M, "sclk_edp_24m", mux_edp_24m_p, 0,
 			RK3288_CLKSEL_CON(28), 15, 1, MFLAGS,
 			RK3288_CLKGATE_CON(3), 12, GFLAGS),
-	COMPOSITE(0, "sclk_edp", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_EDP, "sclk_edp", mux_pll_src_cpll_gpll_npll_p, 0,
 			RK3288_CLKSEL_CON(28), 6, 2, MFLAGS, 0, 6, DFLAGS,
 			RK3288_CLKGATE_CON(3), 13, GFLAGS),
 
-	COMPOSITE(0, "sclk_isp", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_ISP, "sclk_isp", mux_pll_src_cpll_gpll_npll_p, 0,
 			RK3288_CLKSEL_CON(6), 6, 2, MFLAGS, 0, 6, DFLAGS,
 			RK3288_CLKGATE_CON(3), 14, GFLAGS),
-	COMPOSITE(0, "sclk_isp_jpe", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_ISP_JPE, "sclk_isp_jpe", mux_pll_src_cpll_gpll_npll_p, 0,
 			RK3288_CLKSEL_CON(6), 14, 2, MFLAGS, 8, 6, DFLAGS,
 			RK3288_CLKGATE_CON(3), 15, GFLAGS),
 
-	GATE(0, "sclk_hdmi_hdcp", "xin24m", 0,
+	GATE(SCLK_HDMI_HDCP, "sclk_hdmi_hdcp", "xin24m", 0,
 			RK3288_CLKGATE_CON(5), 12, GFLAGS),
-	GATE(0, "sclk_hdmi_cec", "xin32k", 0,
+	GATE(SCLK_HDMI_CEC, "sclk_hdmi_cec", "xin32k", 0,
 			RK3288_CLKGATE_CON(5), 11, GFLAGS),
 
-	COMPOSITE(0, "aclk_hevc", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(ACLK_HEVC, "aclk_hevc", mux_pll_src_cpll_gpll_npll_p, 0,
 			RK3288_CLKSEL_CON(39), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(13), 13, GFLAGS),
-	DIV(0, "hclk_hevc", "aclk_hevc", 0,
+	DIV(HCLK_HEVC, "hclk_hevc", "aclk_hevc", 0,
 			RK3288_CLKSEL_CON(40), 12, 2, DFLAGS),
 
-	COMPOSITE(0, "sclk_hevc_cabac", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_HEVC_CABAC, "sclk_hevc_cabac", mux_pll_src_cpll_gpll_npll_p, 0,
 			RK3288_CLKSEL_CON(42), 6, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(13), 14, GFLAGS),
-	COMPOSITE(0, "sclk_hevc_core", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE(SCLK_HEVC_CORE, "sclk_hevc_core", mux_pll_src_cpll_gpll_npll_p, 0,
 			RK3288_CLKSEL_CON(42), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(13), 15, GFLAGS),
 
@@ -371,13 +371,13 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(0, "aclk_peri_src", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(10), 15, 1, MFLAGS, 0, 5, DFLAGS,
 			RK3288_CLKGATE_CON(2), 0, GFLAGS),
-	COMPOSITE_NOMUX(0, "pclk_peri", "aclk_peri_src", 0,
+	COMPOSITE_NOMUX(PCLK_PERI, "pclk_peri", "aclk_peri_src", 0,
 			RK3288_CLKSEL_CON(10), 12, 2, DFLAGS | CLK_DIVIDER_POWER_OF_TWO,
 			RK3288_CLKGATE_CON(2), 3, GFLAGS),
-	COMPOSITE_NOMUX(0, "hclk_peri", "aclk_peri_src", 0,
+	COMPOSITE_NOMUX(HCLK_PERI, "hclk_peri", "aclk_peri_src", 0,
 			RK3288_CLKSEL_CON(10), 8, 2, DFLAGS | CLK_DIVIDER_POWER_OF_TWO,
 			RK3288_CLKGATE_CON(2), 2, GFLAGS),
-	GATE(0, "aclk_peri", "aclk_peri_src", 0,
+	GATE(ACLK_PERI, "aclk_peri", "aclk_peri_src", 0,
 			RK3288_CLKGATE_CON(2), 1, GFLAGS),
 
 	/*
@@ -643,34 +643,34 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(HCLK_RGA, "hclk_rga", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 1, GFLAGS),
 	GATE(HCLK_VOP0, "hclk_vop0", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 6, GFLAGS),
 	GATE(HCLK_VOP1, "hclk_vop1", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 8, GFLAGS),
-	GATE(0, "hclk_vio_ahb_arbi", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 9, GFLAGS),
-	GATE(0, "hclk_vio_niu", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 10, GFLAGS),
-	GATE(0, "hclk_vip", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 15, GFLAGS),
+	GATE(HCLK_VIO_AHB_ARBI, "hclk_vio_ahb_arbi", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 9, GFLAGS),
+	GATE(HCLK_VIO_NIU, "hclk_vio_niu", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 10, GFLAGS),
+	GATE(HCLK_VIP, "hclk_vip", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 15, GFLAGS),
 	GATE(HCLK_IEP, "hclk_iep", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 3, GFLAGS),
 	GATE(HCLK_ISP, "hclk_isp", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 1, GFLAGS),
-	GATE(0, "hclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 10, GFLAGS),
-	GATE(0, "pclk_mipi_dsi0", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 4, GFLAGS),
-	GATE(0, "pclk_mipi_dsi1", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 5, GFLAGS),
-	GATE(0, "pclk_mipi_csi", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 6, GFLAGS),
-	GATE(0, "pclk_lvds_phy", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 7, GFLAGS),
-	GATE(0, "pclk_edp_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 8, GFLAGS),
-	GATE(0, "pclk_hdmi_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 9, GFLAGS),
-	GATE(0, "pclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 11, GFLAGS),
+	GATE(HCLK_VIO2_H2P, "hclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 10, GFLAGS),
+	GATE(PCLK_MIPI_DSI0, "pclk_mipi_dsi0", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 4, GFLAGS),
+	GATE(PCLK_MIPI_DSI1, "pclk_mipi_dsi1", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 5, GFLAGS),
+	GATE(PCLK_MIPI_CSI, "pclk_mipi_csi", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 6, GFLAGS),
+	GATE(PCLK_LVDS_PHY, "pclk_lvds_phy", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 7, GFLAGS),
+	GATE(PCLK_EDP_CTRL, "pclk_edp_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 8, GFLAGS),
+	GATE(PCLK_HDMI_CTRL, "pclk_hdmi_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 9, GFLAGS),
+	GATE(PCLK_VIO2_H2P, "pclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 11, GFLAGS),
 
 	/* aclk_vio0 gates */
 	GATE(ACLK_VOP0, "aclk_vop0", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 5, GFLAGS),
-	GATE(0, "aclk_iep", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 2, GFLAGS),
-	GATE(0, "aclk_vio0_niu", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 11, GFLAGS),
-	GATE(0, "aclk_vip", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 14, GFLAGS),
+	GATE(ACLK_IEP, "aclk_iep", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 2, GFLAGS),
+	GATE(ACLK_VIO0_NIU, "aclk_vio0_niu", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 11, GFLAGS),
+	GATE(ACLK_VIP, "aclk_vip", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 14, GFLAGS),
 
 	/* aclk_vio1 gates */
 	GATE(ACLK_VOP1, "aclk_vop1", "aclk_vio1", 0, RK3288_CLKGATE_CON(15), 7, GFLAGS),
-	GATE(0, "aclk_isp", "aclk_vio1", 0, RK3288_CLKGATE_CON(16), 2, GFLAGS),
-	GATE(0, "aclk_vio1_niu", "aclk_vio1", 0, RK3288_CLKGATE_CON(15), 12, GFLAGS),
+	GATE(ACLK_ISP, "aclk_isp", "aclk_vio1", 0, RK3288_CLKGATE_CON(16), 2, GFLAGS),
+	GATE(ACLK_VIO1_NIU, "aclk_vio1_niu", "aclk_vio1", 0, RK3288_CLKGATE_CON(15), 12, GFLAGS),
 
 	/* aclk_rga_pre gates */
 	GATE(ACLK_RGA, "aclk_rga", "aclk_rga_pre", 0, RK3288_CLKGATE_CON(15), 0, GFLAGS),
-	GATE(0, "aclk_rga_niu", "aclk_rga_pre", 0, RK3288_CLKGATE_CON(15), 13, GFLAGS),
+	GATE(ACLK_RGA_NIU, "aclk_rga_niu", "aclk_rga_pre", 0, RK3288_CLKGATE_CON(15), 13, GFLAGS),
 
 	/*
 	 * Other ungrouped clocks.
-- 
1.9.1

