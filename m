Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaI3DOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:14:19 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:54714 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaI3DOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:14:15 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: mturquette@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <5025b10300502d91822cc90b8fc7639a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: mturquette@linaro.org, dianders@chromium.org, heiko@sntech.de,
        jay.xu@rock-chips.com, kever.yang@rock-chips.com,
        dbasehore@chromium.org, mark.yao@rock-chips.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: [PATCH] clk: rockchip: rk3288: i2s_frac adds flag to set parent's rate
Date: Tue, 30 Sep 2014 11:12:04 +0800
Message-Id: <1412046724-28069-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The relation of i2s nodes as follows:
          i2s_src               0           0            594000000  0
             i2s_frac           0           0            11289600   0
                i2s_pre         0           0            11289600   0
                   sclk_i2s0    0           0            11289600   0
                   i2s0_clkout  0           0            11289600   0
                      hclk_i2s0 1           1            99000000   0

sclk_i2s0 is the master clock, when to set rate of sclk_i2s0, should
allow to set its parent's rate, by add flag CLK_SET_RATE_PARENT for
"i2s_frac", "i2s_pre", "i2s0_clkout" and "sclk_i2s0".

Tested on rk3288 board using max98090, with command "aplay <music.wav>"

Change-Id: I12faad082566532b65a7de8c0a6845e1c17870e6
Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 drivers/clk/rockchip/clk-rk3288.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index c770de0..baf19b4 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -301,15 +301,15 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(0, "i2s_src", mux_pll_src_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(4), 15, 1, MFLAGS, 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(4), 1, GFLAGS),
-	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", 0,
+	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(8), 0,
 			RK3288_CLKGATE_CON(4), 2, GFLAGS),
-	MUX(0, "i2s_pre", mux_i2s_pre_p, 0,
+	MUX(0, "i2s_pre", mux_i2s_pre_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(4), 8, 2, MFLAGS),
-	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, 0,
+	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(4), 12, 1, MFLAGS,
 			RK3288_CLKGATE_CON(4), 0, GFLAGS),
-	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", 0,
+	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", CLK_SET_RATE_PARENT,
 			RK3288_CLKGATE_CON(4), 3, GFLAGS),
 
 	MUX(0, "spdif_src", mux_pll_src_cpll_gpll_p, 0,
-- 
1.9.1


