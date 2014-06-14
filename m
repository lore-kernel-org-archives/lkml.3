Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaFNBsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 21:48:15 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45058 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaFNBsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 21:48:14 -0400
From: Nick <xerofoify@gmail.com>
X-Google-Original-From: Nick <nickkrause@sympatico.ca>
To: emilio@elopez.com.ar
Cc: mturquette@linaro.org, maxime.ripard@free-electrons.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Fixes two memory leaks in drivers/clk/sunxi/clk-sunxi.c
Date: Fri, 13 Jun 2014 21:47:53 -0400
Message-Id: <1402710473-3295-1-git-send-email-nickkrause@sympatico.ca>
X-Mailer: git-send-email 1.9.1
Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 4264834..07b45d1 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -41,9 +41,11 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
 	const char *clk_name = node->name;
 	u32 rate;
 
-	if (of_property_read_u32(node, "clock-frequency", &rate))
+	if (of_property_read_u32(node, "clock-frequency", &rate)) {
+		kfree(fixed);
+		kfree(gate);
 		return;
-
+	}
 	/* allocate fixed-rate and gate clock structs */
 	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
 	if (!fixed)
-- 
1.9.1

