Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbaDIOBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:01:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60838 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933353AbaDINvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:31 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 05/15] clk: sunxi: add A31 APB0 clk gate defintions
Date: Wed,  9 Apr 2014 15:51:08 +0200
Message-Id: <1397051478-4113-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APB0 gates support for the A31 SoC.
This gates are controlled by the PRCM (Power/Reset/Clock Management) block
and thus will act on a different iomem range.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index abb6c5a..f9b11c3 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -718,6 +718,10 @@ static const struct gates_data sun5i_a13_apb0_gates_data __initconst = {
 	.mask = {0x61},
 };
 
+static const struct gates_data sun6i_a31_apb0_gates_data __initconst = {
+	.mask = { 0x7f },
+};
+
 static const struct gates_data sun7i_a20_apb0_gates_data __initconst = {
 	.mask = { 0x4ff },
 };
@@ -1013,6 +1017,7 @@ static const struct of_device_id clk_gates_match[] __initconst = {
 	{.compatible = "allwinner,sun4i-apb0-gates-clk", .data = &sun4i_apb0_gates_data,},
 	{.compatible = "allwinner,sun5i-a10s-apb0-gates-clk", .data = &sun5i_a10s_apb0_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-apb0-gates-clk", .data = &sun5i_a13_apb0_gates_data,},
+	{.compatible = "allwinner,sun6i-a31-apb0-gates-clk", .data = &sun6i_a31_apb0_gates_data,},
 	{.compatible = "allwinner,sun7i-a20-apb0-gates-clk", .data = &sun7i_a20_apb0_gates_data,},
 	{.compatible = "allwinner,sun4i-apb1-gates-clk", .data = &sun4i_apb1_gates_data,},
 	{.compatible = "allwinner,sun5i-a10s-apb1-gates-clk", .data = &sun5i_a10s_apb1_gates_data,},
-- 
1.8.3.2

