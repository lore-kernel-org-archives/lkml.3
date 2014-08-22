Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaHVQik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:38:40 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:64299 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbaHVQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:38:39 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: Fix the clocks for i2c1 and i2c2
Date: Fri, 22 Aug 2014 09:38:28 -0700
Message-Id: <1408725508-24066-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocks for i2c1 and i2c2 are flipped.  The clock tree matched the
Technical Reference Manual (TRM) but the TRM was wrong.  Swap them in
the clock tree.  This was determined experimentally (by Addy) and
confirmed by the Rockchip IC team.

Seires-cc: Eddie Cai <eddie.cai@rock-chips.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Reported-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/clk/rockchip/clk-rk3288.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 0d8c6c5..b22a2d2 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -545,7 +545,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_PWM, "pclk_pwm", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 0, GFLAGS),
 	GATE(PCLK_TIMER, "pclk_timer", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 1, GFLAGS),
 	GATE(PCLK_I2C0, "pclk_i2c0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 2, GFLAGS),
-	GATE(PCLK_I2C1, "pclk_i2c1", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 3, GFLAGS),
+	GATE(PCLK_I2C2, "pclk_i2c2", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 3, GFLAGS),
 	GATE(0, "pclk_ddrupctl0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 14, GFLAGS),
 	GATE(0, "pclk_publ0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 15, GFLAGS),
 	GATE(0, "pclk_ddrupctl1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 0, GFLAGS),
@@ -603,7 +603,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_I2C4, "pclk_i2c4", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 15, GFLAGS),
 	GATE(PCLK_UART3, "pclk_uart3", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 11, GFLAGS),
 	GATE(PCLK_UART4, "pclk_uart4", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 12, GFLAGS),
-	GATE(PCLK_I2C2, "pclk_i2c2", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 13, GFLAGS),
+	GATE(PCLK_I2C1, "pclk_i2c1", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 13, GFLAGS),
 	GATE(PCLK_I2C3, "pclk_i2c3", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 14, GFLAGS),
 	GATE(PCLK_SARADC, "pclk_saradc", "pclk_peri", 0, RK3288_CLKGATE_CON(7), 1, GFLAGS),
 	GATE(PCLK_TSADC, "pclk_tsadc", "pclk_peri", 0, RK3288_CLKGATE_CON(7), 2, GFLAGS),
-- 
2.1.0.rc2.206.gedb03e5

