Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3HPCRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:17:51 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61712 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3HPCRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:17:50 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH] clk: export fixed-factor, gate & mux registration
Date: Thu, 15 Aug 2013 19:16:48 -0700
Message-Id: <1376619408-19923-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These registration calls may be used by loadable modules. Export them.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk-fixed-factor.c | 2 ++
 drivers/clk/clk-gate.c         | 1 +
 drivers/clk/clk-mux.c          | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index 9ff7d51..0e1d89b 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -97,6 +97,8 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
 
 	return clk;
 }
+EXPORT_SYMBOL_GPL(clk_register_fixed_factor);
+
 #ifdef CONFIG_OF
 /**
  * of_fixed_factor_clk_setup() - Setup function for simple fixed factor clock
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 790306e..2b28a00 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -161,3 +161,4 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 
 	return clk;
 }
+EXPORT_SYMBOL_GPL(clk_register_gate);
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 92f1a1b..b918dc3 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -162,6 +162,7 @@ struct clk *clk_register_mux_table(struct device *dev, const char *name,
 
 	return clk;
 }
+EXPORT_SYMBOL_GPL(clk_register_mux_table);
 
 struct clk *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
@@ -174,3 +175,4 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 				      flags, reg, shift, mask, clk_mux_flags,
 				      NULL, lock);
 }
+EXPORT_SYMBOL_GPL(clk_register_mux);
-- 
1.8.1.2

