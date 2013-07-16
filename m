Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3GPMRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:17:48 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52004 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3GPMRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:17:47 -0400
MIME-Version: 1.0
Date: Tue, 16 Jul 2013 20:17:45 +0800
Message-ID: <CAPgLHd_RTeUgZtsLd=GqW7tG0q-ccDcd8gBNgDxo3E8qLE141g@mail.gmail.com>
Subject: [PATCH -next] clk: sunxi: fix return value check
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mturquette@linaro.org, emilio@elopez.com.ar,
        gregory.clement@free-electrons.com, maxime.ripard@free-electrons.com,
        cate@cateee.net
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_register_composite() and
clk_register_factors() returns ERR_PTR() not NULL. The NULL test
in the return value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/sunxi/clk-sunxi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 412912b..02e440b 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -64,7 +64,7 @@ static void __init sunxi_osc_clk_setup(struct device_node *node)
 			&gate->hw, &clk_gate_ops,
 			CLK_IS_ROOT);
 
-	if (clk) {
+	if (!IS_ERR(clk)) {
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 		clk_register_clkdev(clk, clk_name, NULL);
 	}
@@ -221,7 +221,7 @@ static void __init sunxi_factors_clk_setup(struct device_node *node,
 	clk = clk_register_factors(NULL, clk_name, parent, 0, reg,
 				   data->table, data->getter, &clk_lock);
 
-	if (clk) {
+	if (!IS_ERR(clk)) {
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 		clk_register_clkdev(clk, clk_name, NULL);
 	}

