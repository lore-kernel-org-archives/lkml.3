Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3JXMZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:25:33 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:48338 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3JXMZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:25:32 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: mturquette@linaro.org, emilio@elopez.com.ar,
        maxime.ripard@free-electrons.com, gregory.clement@free-electrons.com,
        sboyd@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] clk: sunxi: fix memory leaks
Date: Thu, 24 Oct 2013 15:25:13 +0300
Message-Id: <1382617513-9259-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the if condition is true, "fixed" and "gate" should be free'd before return.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 34ee69f..a970b55 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -48,8 +48,11 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
 		return;
 	}
 
-	if (of_property_read_u32(node, "clock-frequency", &rate))
+	if (of_property_read_u32(node, "clock-frequency", &rate)) {
+		kfree(fixed);
+		kfree(gate);
 		return;
+	}
 
 	/* set up gate and fixed rate properties */
 	gate->reg = of_iomap(node, 0);
-- 
1.8.1.2

