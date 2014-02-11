Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaBKNZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:25:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45118 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBKNZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:25:51 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Cc: tony@atomide.com, t-kristo@ti.com, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] clk:ti: Fix memory leak in of_ti_composite_divider_clk_setup()
Date: Tue, 11 Feb 2014 22:25:41 +0900
Message-Id: <1392125141-14769-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck detected following error
[drivers/clk/ti/divider.c:480]: (error) Memory leak: div

The original code forgot to free div and just returned.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/clk/ti/divider.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index a15e445..a105d94 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -477,7 +477,6 @@ static void __init of_ti_composite_divider_clk_setup(struct device_node *node)
 		goto cleanup;
 
 	if (!ti_clk_add_component(node, &div->hw, CLK_COMPONENT_TYPE_DIVIDER))
-		return;
 
 cleanup:
 	kfree(div->table);
-- 
1.9.rc1

