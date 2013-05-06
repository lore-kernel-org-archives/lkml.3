Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3EFJtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:49:24 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:45085 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3EFJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:49:23 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        ldv-project@linuxtesting.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: fixed-factor: remove exported function from __init section
Date: Mon,  6 May 2013 13:48:38 +0400
Message-Id: <1367833718-2626-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol of_fixed_factor_clk_setup is exported and annotated __init.
It looks like section mismatch. Fix by removing the __init annotation of
of_fixed_factor_clk_setup. The patch is similar to e4eda8e06.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/clk/clk-fixed-factor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index 9ff7d51..4022297 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -101,7 +101,7 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
 /**
  * of_fixed_factor_clk_setup() - Setup function for simple fixed factor clock
  */
-void __init of_fixed_factor_clk_setup(struct device_node *node)
+void of_fixed_factor_clk_setup(struct device_node *node)
 {
 	struct clk *clk;
 	const char *clk_name = node->name;
-- 
1.8.1.4

