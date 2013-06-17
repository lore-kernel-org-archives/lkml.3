Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3FQWsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:48:53 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56824 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3FQWsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:48:52 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes
Date: Mon, 17 Jun 2013 15:47:40 -0700
Message-Id: <1371509260-2340-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq's Ethernet clocks are created by the following hierarchy:
	mux0 ---> div0 ---> div1 ---> mux1 ---> gate
Rate change requests on the gate have to propagate all the way up to
div0 to properly leverage all dividers. Mux1 was missing the
CLK_SET_RATE_PARENT flag, which is required to achieve this.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/zynq/clkc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 515a573..089d3e3 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -365,8 +365,9 @@ static void __init zynq_clk_setup(struct device_node *np)
 			CLK_SET_RATE_PARENT, SLCR_GEM0_CLK_CTRL, 20, 6,
 			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
 			&gem0clk_lock);
-	clk = clk_register_mux(NULL, "gem0_emio_mux", gem0_mux_parents, 2, 0,
-			SLCR_GEM0_CLK_CTRL, 6, 1, 0, &gem0clk_lock);
+	clk = clk_register_mux(NULL, "gem0_emio_mux", gem0_mux_parents, 2,
+			CLK_SET_RATE_PARENT, SLCR_GEM0_CLK_CTRL, 6, 1, 0,
+			&gem0clk_lock);
 	clks[gem0] = clk_register_gate(NULL, clk_output_name[gem0],
 			"gem0_emio_mux", CLK_SET_RATE_PARENT,
 			SLCR_GEM0_CLK_CTRL, 0, 0, &gem0clk_lock);
@@ -387,8 +388,9 @@ static void __init zynq_clk_setup(struct device_node *np)
 			CLK_SET_RATE_PARENT, SLCR_GEM1_CLK_CTRL, 20, 6,
 			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
 			&gem1clk_lock);
-	clk = clk_register_mux(NULL, "gem1_emio_mux", gem1_mux_parents, 2, 0,
-			SLCR_GEM1_CLK_CTRL, 6, 1, 0, &gem1clk_lock);
+	clk = clk_register_mux(NULL, "gem1_emio_mux", gem1_mux_parents, 2,
+			CLK_SET_RATE_PARENT, SLCR_GEM1_CLK_CTRL, 6, 1, 0,
+			&gem1clk_lock);
 	clks[gem1] = clk_register_gate(NULL, clk_output_name[gem1],
 			"gem1_emio_mux", CLK_SET_RATE_PARENT,
 			SLCR_GEM1_CLK_CTRL, 0, 0, &gem1clk_lock);
-- 
1.8.3.1

