Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaKZANb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:13:31 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37453 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaKZANT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:13:19 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, cym@rock-chips.com,
        Mike Turquette <mturquette@linaro.org>
Cc: Derek Basehore <dbasehore@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] clk: rockchip: use clock ID for DMC (memory controller) on rk3288
Date: Tue, 25 Nov 2014 16:13:03 -0800
Message-Id: <1416960783-25119-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416960783-25119-1-git-send-email-dianders@chromium.org>
References: <1416960783-25119-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Chen <cym@rock-chips.com>

The DMC clocks need to be turned off at runtime.  Use the newly
assigned clock IDs to export them.

Signed-off-by: Jeff Chen <cym@rock-chips.com>
[dianders: split into two patches; adjusted commit msg]
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index ad8a27a..2328097 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -625,10 +625,10 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	GATE(PCLK_TIMER, "pclk_timer", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 1, GFLAGS),
 	GATE(PCLK_I2C0, "pclk_i2c0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 2, GFLAGS),
 	GATE(PCLK_I2C2, "pclk_i2c2", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 3, GFLAGS),
-	GATE(0, "pclk_ddrupctl0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 14, GFLAGS),
-	GATE(0, "pclk_publ0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 15, GFLAGS),
-	GATE(0, "pclk_ddrupctl1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 0, GFLAGS),
-	GATE(0, "pclk_publ1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 1, GFLAGS),
+	GATE(PCLK_DDRUPCTL0, "pclk_ddrupctl0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 14, GFLAGS),
+	GATE(PCLK_PUBL0, "pclk_publ0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 15, GFLAGS),
+	GATE(PCLK_DDRUPCTL1, "pclk_ddrupctl1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 0, GFLAGS),
+	GATE(PCLK_PUBL1, "pclk_publ1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 1, GFLAGS),
 	GATE(0, "pclk_efuse_1024", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 2, GFLAGS),
 	GATE(PCLK_TZPC, "pclk_tzpc", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 3, GFLAGS),
 	GATE(PCLK_UART2, "pclk_uart2", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 9, GFLAGS),
-- 
2.1.0.rc2.206.gedb03e5

