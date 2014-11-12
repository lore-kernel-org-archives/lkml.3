Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaKLViy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:38:54 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:48089 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaKLVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:38:49 -0500
Date: Wed, 12 Nov 2014 13:38:45 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, Jianqun <jay.xu@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Mark yao <mark.yao@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: ensure HCLK_VIO2_H2P and PCLK_VIO2_H2P stay
 enabled
Message-ID: <20141112213845.GA14153@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no driver owning these clocks and they have to stay
up for the system to function properly, so let's mark them as
CLK_IGNORE_UNUSED.

Without this patch we have trouble with suspend/resume and we have
trouble turning the eDP back on if it ever idles off.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 2327829..d79d52f 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -724,14 +724,14 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(HCLK_VIP, "hclk_vip", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 15, GFLAGS),
 	GATE(HCLK_IEP, "hclk_iep", "hclk_vio", 0, RK3288_CLKGATE_CON(15), 3, GFLAGS),
 	GATE(HCLK_ISP, "hclk_isp", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 1, GFLAGS),
-	GATE(HCLK_VIO2_H2P, "hclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 10, GFLAGS),
+	GATE(HCLK_VIO2_H2P, "hclk_vio2_h2p", "hclk_vio", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(16), 10, GFLAGS),
 	GATE(PCLK_MIPI_DSI0, "pclk_mipi_dsi0", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 4, GFLAGS),
 	GATE(PCLK_MIPI_DSI1, "pclk_mipi_dsi1", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 5, GFLAGS),
 	GATE(PCLK_MIPI_CSI, "pclk_mipi_csi", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 6, GFLAGS),
 	GATE(PCLK_LVDS_PHY, "pclk_lvds_phy", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 7, GFLAGS),
 	GATE(PCLK_EDP_CTRL, "pclk_edp_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 8, GFLAGS),
 	GATE(PCLK_HDMI_CTRL, "pclk_hdmi_ctrl", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 9, GFLAGS),
-	GATE(PCLK_VIO2_H2P, "pclk_vio2_h2p", "hclk_vio", 0, RK3288_CLKGATE_CON(16), 11, GFLAGS),
+	GATE(PCLK_VIO2_H2P, "pclk_vio2_h2p", "hclk_vio", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(16), 11, GFLAGS),
 
 	/* aclk_vio0 gates */
 	GATE(ACLK_VOP0, "aclk_vop0", "aclk_vio0", 0, RK3288_CLKGATE_CON(15), 5, GFLAGS),
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
