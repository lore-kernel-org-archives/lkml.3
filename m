Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaILKVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:21:43 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:48374 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245AbaILKVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:21:41 -0400
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: mturquette@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <8da01d20b8cc24872ce2f3cec46f1db8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Mark yao <mark.yao@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, heiko@sntech.de,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, dianders@chromium.org, dkl@rock-chips.com,
        eddie.cai@rock-chips.com, xjq@rock-chips.com, kfx@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yxj@rock-chips.com,
        cym@rock-chips.com, zhengsq@rock-chips.com, caesar.wang@rock-chips.com,
        kever.yang@rock-chips.com, Mark yao <mark.yao@rock-chips.com>
Subject: [PATCH] clk: rockchip: rk3288: Document eDP clock names
Date: Fri, 12 Sep 2014 18:20:58 +0800
Message-Id: <1410517258-18789-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds clock names for rk3288 eDP.

Signed-off-by: Mark yao <mark.yao@rock-chips.com>
---
 drivers/clk/rockchip/clk-rk3288.c      | 6 +++---
 include/dt-bindings/clock/rk3288-cru.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 2e1d790..bfe18b5 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -320,10 +320,10 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
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
 
@@ -653,7 +653,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(0, "pclk_mipi_dsi1", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 5, GFLAGS),
 	GATE(0, "pclk_mipi_csi", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 6, GFLAGS),
 	GATE(0, "pclk_lvds_phy", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 7, GFLAGS),
-	GATE(0, "pclk_edp_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 8, GFLAGS),
+	GATE(PCLK_EDP_CTRL, "pclk_edp_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 8, GFLAGS),
 	GATE(0, "pclk_hdmi_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 9, GFLAGS),
 	GATE(0, "pclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 11, GFLAGS),
 
diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 4d65959..0f7369d 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -61,6 +61,8 @@
 #define SCLK_LCDC_PWM1		101
 #define SCLK_MAC_RX		102
 #define SCLK_MAC_TX		103
+#define SCLK_EDP_24M		104
+#define SCLK_EDP		105
 
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
@@ -112,6 +114,7 @@
 #define PCLK_PS2C		352
 #define PCLK_TIMER		353
 #define PCLK_TZPC		354
+#define PCLK_EDP_CTRL		355
 
 /* hclk gates */
 #define HCLK_GPS		448
-- 
1.9.1

