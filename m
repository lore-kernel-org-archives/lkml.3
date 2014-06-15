Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaFOBPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 21:15:50 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:43870 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaFOBPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 21:15:49 -0400
From: Nick <xerofoify@gmail.com>
To: emilio@elopez.com.ar
Cc: mturquette@linaro.org, maxime.ripard@free-electrons.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHV2]Fixes memory leak in clk-sunxi.c
Date: Sat, 14 Jun 2014 21:15:44 -0400
Message-Id: <1402794944-3357-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick <xerofoify@gmail.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 6f4fc51..c2ce538 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -41,10 +41,10 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
 	const char *clk_name = node->name;
 	u32 rate;
 
-	if (of_property_read_u32(node, "clock-frequency", &rate))
+	if (of_property_read_u32(node, "clock-frequency", &rate)) {
 		kree(gate);
 		return;
-
+	}
 	/* allocate fixed-rate and gate clock structs */
 	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
 	if (!fixed)
-- 
1.9.1

