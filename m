Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaILKWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:22:53 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:60708 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752001AbaILKWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:22:51 -0400
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: mturquette@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <10935af9cd601eadd6f05b9815f8beed>
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
Subject: [PATCH] clk: rockchip: rk3288: Document HDMI clock names
Date: Fri, 12 Sep 2014 18:22:23 +0800
Message-Id: <1410517343-18848-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds clock names for rk3288 HDMI.

Signed-off-by: Mark yao <mark.yao@rock-chips.com>
---
 drivers/clk/rockchip/clk-rk3288.c      | 6 +++---
 include/dt-bindings/clock/rk3288-cru.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index bfe18b5..de85e55 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -334,9 +334,9 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(6), 14, 2, MFLAGS, 8, 6, DFLAGS,
 			RK3288_CLKGATE_CON(3), 15, GFLAGS),
 
-	GATE(0, "sclk_hdmi_hdcp", "xin24m", 0,
+	GATE(SCLK_HDMI_HDCP, "sclk_hdmi_hdcp", "xin24m", 0,
 			RK3288_CLKGATE_CON(5), 12, GFLAGS),
-	GATE(0, "sclk_hdmi_cec", "xin32k", 0,
+	GATE(SCLK_HDMI_CEC, "sclk_hdmi_cec", "xin32k", 0,
 			RK3288_CLKGATE_CON(5), 11, GFLAGS),
 
 	COMPOSITE(0, "aclk_hevc", mux_pll_src_cpll_gpll_npll_p, 0,
@@ -654,7 +654,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(0, "pclk_mipi_csi", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 6, GFLAGS),
 	GATE(0, "pclk_lvds_phy", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 7, GFLAGS),
 	GATE(PCLK_EDP_CTRL, "pclk_edp_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 8, GFLAGS),
-	GATE(0, "pclk_hdmi_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 9, GFLAGS),
+	GATE(PCLK_HDMI_CTRL, "pclk_hdmi_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 9, GFLAGS),
 	GATE(0, "pclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 11, GFLAGS),
 
 	/* aclk_vio0 gates */
diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 0f7369d..5ce4457 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -63,6 +63,8 @@
 #define SCLK_MAC_TX		103
 #define SCLK_EDP_24M		104
 #define SCLK_EDP		105
+#define SCLK_HDMI_HDCP		106
+#define SCLK_HDMI_CEC		107
 
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
@@ -115,6 +117,7 @@
 #define PCLK_TIMER		353
 #define PCLK_TZPC		354
 #define PCLK_EDP_CTRL		355
+#define PCLK_HDMI_CTRL		356
 
 /* hclk gates */
 #define HCLK_GPS		448
-- 
1.9.1

