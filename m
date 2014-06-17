Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbaFQOx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:53:29 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41364 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbaFQOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:53:25 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 13/20] clk: sunxi: Add A23 specific compatible to sun6i-a31-apb0-gates-clk
Date: Tue, 17 Jun 2014 22:52:50 +0800
Message-Id: <1403016777-15121-14-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sun6i-a31-apb0-gates-clk driver is generic in that it supports
the "clock-indicies" DT property with "clock-output-names" to list
the valid clock gate bits.

However this might lead one to assume that the clock in the A23 is
the same as the A31. To make it clear, we add a new compatible for
the A23, "allwinner,sun8i-a23-apb0-gates-clk".

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/clock/sunxi.txt | 1 +
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index e3a47ec..ad446b2 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -34,6 +34,7 @@ Required properties:
 	"allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
 	"allwinner,sun6i-a31-apb0-gates-clk" - for the APB0 gates on A31
 	"allwinner,sun7i-a20-apb0-gates-clk" - for the APB0 gates on A20
+	"allwinner,sun8i-a23-apb0-gates-clk" - for the APB0 gates on A23
 	"allwinner,sun4i-a10-apb1-clk" - for the APB1 clock
 	"allwinner,sun4i-a10-apb1-mux-clk" - for the APB1 clock muxing
 	"allwinner,sun4i-a10-apb1-gates-clk" - for the APB1 gates on A10
diff --git a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
index b342f2a..f147fee 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
@@ -85,6 +85,7 @@ static int sun6i_a31_apb0_gates_clk_probe(struct platform_device *pdev)
 
 const struct of_device_id sun6i_a31_apb0_gates_clk_dt_ids[] = {
 	{ .compatible = "allwinner,sun6i-a31-apb0-gates-clk" },
+	{ .compatible = "allwinner,sun8i-a23-apb0-gates-clk" },
 	{ /* sentinel */ }
 };
 
-- 
2.0.0

