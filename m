Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaFNSL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 14:11:56 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:61240 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbaFNSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 14:11:55 -0400
From: Nick <xerofoify@gmail.com>
To: emilio@elopez.com.ar
Cc: mturquette@linaro.org, maxime.ripard@free-electrons.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Frees gate after if statement in clk-sunxi.c
Date: Sat, 14 Jun 2014 14:11:48 -0400
Message-Id: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick <xerofoify@gmail.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 4264834..6f4fc51 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -42,6 +42,7 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
 	u32 rate;
 
 	if (of_property_read_u32(node, "clock-frequency", &rate))
+		kree(gate);
 		return;
 
 	/* allocate fixed-rate and gate clock structs */
-- 
1.9.1

