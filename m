Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaJTJ5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:57:12 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:51359 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaJTJ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:57:10 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: mturquette@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <4b5a3c9aa1be535384dc60264e26992b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun <jay.xu@rock-chips.com>
To: mturquette@linaro.org, dianders@chromium.org, heiko@sntech.de,
        jay.xu@rock-chips.com, kever.yang@rock-chips.com,
        dbasehore@chromium.org, mark.yao@rock-chips.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: [PATCH] clk: rockchip: rk3288: removing the CLK_SET_RATE_PARENT from i2s_clkout
Date: Mon, 20 Oct 2014 17:55:03 +0800
Message-Id: <1413798903-13967-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the CLK_SET_RATE_PARENT from i2s_clkout, to limit i2s0_clkout
to select between its two parent without being able influence the core
i2s clock.

Tested on rk3288 board, suggested by Heiko.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 drivers/clk/rockchip/clk-rk3288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 2327829..6f97fe4 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -305,7 +305,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKGATE_CON(4), 2, GFLAGS),
 	MUX(0, "i2s_pre", mux_i2s_pre_p, CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(4), 8, 2, MFLAGS),
-	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, CLK_SET_RATE_PARENT,
+	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, 0,
 			RK3288_CLKSEL_CON(4), 12, 1, MFLAGS,
 			RK3288_CLKGATE_CON(4), 0, GFLAGS),
 	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", CLK_SET_RATE_PARENT,
-- 
1.9.1


