Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935060Ab3GWW3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:29:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51820 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308Ab3GWW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:29:25 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/2] clk: sunxi: Add A10s gates
Date: Wed, 24 Jul 2013 00:28:23 +0200
Message-Id: <1374618504-19391-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A10s has a slightly different gates set than the A10 and
A13, so add these gates to the clk driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 412912b..db1c45b 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -341,6 +341,10 @@ static const __initconst struct gates_data sun4i_ahb_gates_data = {
 	.mask = {0x7F77FFF, 0x14FB3F},
 };
 
+static const __initconst struct gates_data sun5i_a10s_ahb_gates_data = {
+	.mask = {0x147667e7, 0x185915},
+};
+
 static const __initconst struct gates_data sun5i_a13_ahb_gates_data = {
 	.mask = {0x107067e7, 0x185111},
 };
@@ -349,6 +353,10 @@ static const __initconst struct gates_data sun4i_apb0_gates_data = {
 	.mask = {0x4EF},
 };
 
+static const __initconst struct gates_data sun5i_a10s_apb0_gates_data = {
+	.mask = {0x469},
+};
+
 static const __initconst struct gates_data sun5i_a13_apb0_gates_data = {
 	.mask = {0x61},
 };
@@ -357,6 +365,10 @@ static const __initconst struct gates_data sun4i_apb1_gates_data = {
 	.mask = {0xFF00F7},
 };
 
+static const __initconst struct gates_data sun5i_a10s_apb1_gates_data = {
+	.mask = {0xf0007},
+};
+
 static const __initconst struct gates_data sun5i_a13_apb1_gates_data = {
 	.mask = {0xa0007},
 };
@@ -442,10 +454,13 @@ static const __initconst struct of_device_id clk_mux_match[] = {
 static const __initconst struct of_device_id clk_gates_match[] = {
 	{.compatible = "allwinner,sun4i-axi-gates-clk", .data = &sun4i_axi_gates_data,},
 	{.compatible = "allwinner,sun4i-ahb-gates-clk", .data = &sun4i_ahb_gates_data,},
+	{.compatible = "allwinner,sun5i-a10s-ahb-gates-clk", .data = &sun5i_a10s_ahb_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-ahb-gates-clk", .data = &sun5i_a13_ahb_gates_data,},
 	{.compatible = "allwinner,sun4i-apb0-gates-clk", .data = &sun4i_apb0_gates_data,},
+	{.compatible = "allwinner,sun5i-a10s-apb0-gates-clk", .data = &sun5i_a10s_apb0_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-apb0-gates-clk", .data = &sun5i_a13_apb0_gates_data,},
 	{.compatible = "allwinner,sun4i-apb1-gates-clk", .data = &sun4i_apb1_gates_data,},
+	{.compatible = "allwinner,sun5i-a10s-apb1-gates-clk", .data = &sun5i_a10s_apb1_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-apb1-gates-clk", .data = &sun5i_a13_apb1_gates_data,},
 	{}
 };
-- 
1.8.3.2

