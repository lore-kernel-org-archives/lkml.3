Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaIEFwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:52:01 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:45987 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIEFv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:51:59 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <b505b6202449e0d9ef58092e16300215>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: jianqun <xjq@rock-chips.com>
To: heiko@sntech.de, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: xjq@rock-chips.com, kever.yang@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com
Subject: [PATCH] Rockchip: RK3288: CRU: swap value of bit for CORE clock pll source selection
Date: Fri,  5 Sep 2014 13:49:26 +0800
Message-Id: <1409896166-32732-1-git-send-email-xjq@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xujianqun <xjq@rock-chips.com>

For RK3288, core clock pll source select APLL when bit value is 1, select GPLL
when bit value is 0;

CRU_CLKSEL0_CON [15]
- core_clk_pll_sel
- CORE clock pll source selection
-- 1'b1: select ARM PLL
-- 1'b0: select GENERAL PLL

BUG=none
TEST= "cat /sys/kernel/debug/clk/clk_summary |grep apll" check parent of core clock

Change-Id: I44a528af256da1fad573b4ccf9d0a20ad4cf6d68
Signed-off-by: xujianqun <xjq@rock-chips.com>
---
 drivers/clk/rockchip/clk-cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-cpu.c b/drivers/clk/rockchip/clk-cpu.c
index c5b14e9..1725ac7 100644
--- a/drivers/clk/rockchip/clk-cpu.c
+++ b/drivers/clk/rockchip/clk-cpu.c
@@ -136,7 +136,7 @@ static int rockchip_cpuclk_pre_rate_change(struct rockchip_cpuclk *cpuclk,
 	}
 
 	/* select alternate parent */
-	writel(HIWORD_UPDATE(1, 1, reg_data->mux_core_shift),
+	writel(HIWORD_UPDATE(0, 1, reg_data->mux_core_shift),
 	       cpuclk->reg_base + reg_data->core_reg);
 
 	/* alternate parent is active now. set the dividers */
@@ -163,7 +163,7 @@ static int rockchip_cpuclk_post_rate_change(struct rockchip_cpuclk *cpuclk,
 	spin_lock(cpuclk->lock);
 
 	/* post-rate change event, re-mux back to primary parent */
-	writel(HIWORD_UPDATE(0, 1, reg_data->mux_core_shift),
+	writel(HIWORD_UPDATE(1, 1, reg_data->mux_core_shift),
 	       cpuclk->reg_base + RK2928_CLKSEL_CON(0));
 
 	/* remove any core dividers */
-- 
1.9.1


