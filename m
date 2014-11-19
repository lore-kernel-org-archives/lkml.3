Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaKSHPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:15:25 -0500
Received: from mail-pa0-f74.google.com ([209.85.220.74]:40906 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaKSHPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:15:24 -0500
From: Sonny Rao <sonnyrao@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, dianders@chromium.org,
        Mike Turquette <mturquette@linaro.org>,
        Mark yao <mark.yao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] clk: rockchip: rk3288 export i2s0_clkout for use in DT
Date: Tue, 18 Nov 2014 23:15:19 -0800
Message-Id: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exposes the clock that comes out of the i2s block which generally
goes to the audio codec.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c      | 3 ++-
 include/dt-bindings/clock/rk3288-cru.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 2327829..8777737 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -305,7 +305,8 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKGATE_CON(4), 2, GFLAGS),
 	MUX(0, "i2s_pre", mux_i2s_pre_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(4), 8, 2, MFLAGS),
-	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, CLK_SET_RATE_PARENT,
+	COMPOSITE_NODIV(SCLK_I2S0_OUT, "i2s0_clkout", mux_i2s_clkout_p,
+			CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(4), 12, 1, MFLAGS,
 			RK3288_CLKGATE_CON(4), 0, GFLAGS),
 	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", CLK_SET_RATE_PARENT,
diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 100a08c..4acc730 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -71,6 +71,7 @@
 #define SCLK_HDMI_CEC		110
 #define SCLK_HEVC_CABAC		111
 #define SCLK_HEVC_CORE		112
+#define SCLK_I2S0_OUT           113
 
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
-- 
2.1.0.rc2.206.gedb03e5

