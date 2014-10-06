Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaJFRPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:15:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43122 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaJFRPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:15:53 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, Kever Yang <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: Add CLK_SET_RATE_PARENT to aclk_cpu_pre
Date: Mon,  6 Oct 2014 10:15:27 -0700
Message-Id: <1412615727-8772-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd like to be able to call clk_set_rate() on aclk_cpu (a gate) at
bootup.  In order for this to have any effect we need its parent
(aclk_cpu_pre) to percolate the rate change to _its_ parent
(aclk_cpu_src).  Add CLK_SET_RATE_PARENT to make this happen.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index d053529..4d98f53 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -279,7 +279,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKGATE_CON(0), 11, GFLAGS),
 	COMPOSITE_NOGATE(0, "aclk_cpu_src", mux_aclk_cpu_src_p, 0,
 			RK3288_CLKSEL_CON(1), 15, 1, MFLAGS, 3, 5, DFLAGS),
-	DIV(0, "aclk_cpu_pre", "aclk_cpu_src", 0,
+	DIV(0, "aclk_cpu_pre", "aclk_cpu_src", CLK_SET_RATE_PARENT,
 			RK3288_CLKSEL_CON(1), 0, 3, DFLAGS),
 	GATE(ACLK_CPU, "aclk_cpu", "aclk_cpu_pre", 0,
 			RK3288_CLKGATE_CON(0), 3, GFLAGS),
-- 
2.1.0.rc2.206.gedb03e5

