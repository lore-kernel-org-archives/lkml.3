Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbbAVQOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:14:01 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47246 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbbAVQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:13:56 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v12 2/6] clk: Remove __clk_register
Date: Thu, 22 Jan 2015 17:13:12 +0100
Message-Id: <1421943207-5180-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421943207-5180-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1421943207-5180-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it has never been used.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c           | 42 ------------------------------------------
 include/linux/clk-private.h |  2 --
 2 files changed, 44 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 97f3425..fd3d671 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1975,48 +1975,6 @@ out:
 }
 
 /**
- * __clk_register - register a clock and return a cookie.
- *
- * Same as clk_register, except that the .clk field inside hw shall point to a
- * preallocated (generally statically allocated) struct clk. None of the fields
- * of the struct clk need to be initialized.
- *
- * The data pointed to by .init and .clk field shall NOT be marked as init
- * data.
- *
- * __clk_register is only exposed via clk-private.h and is intended for use with
- * very large numbers of clocks that need to be statically initialized.  It is
- * a layering violation to include clk-private.h from any code which implements
- * a clock's .ops; as such any statically initialized clock data MUST be in a
- * separate C file from the logic that implements its operations.  Returns 0
- * on success, otherwise an error code.
- */
-struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
-{
-	int ret;
-	struct clk *clk;
-
-	clk = hw->clk;
-	clk->name = hw->init->name;
-	clk->ops = hw->init->ops;
-	clk->hw = hw;
-	clk->flags = hw->init->flags;
-	clk->parent_names = hw->init->parent_names;
-	clk->num_parents = hw->init->num_parents;
-	if (dev && dev->driver)
-		clk->owner = dev->driver->owner;
-	else
-		clk->owner = NULL;
-
-	ret = __clk_init(dev, clk);
-	if (ret)
-		return ERR_PTR(ret);
-
-	return clk;
-}
-EXPORT_SYMBOL_GPL(__clk_register);
-
-/**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
  * @hw: link to hardware-specific clock data
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 0ca5f60..c5f40d0 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -214,7 +214,5 @@ struct clk {
  */
 int __clk_init(struct device *dev, struct clk *clk);
 
-struct clk *__clk_register(struct device *dev, struct clk_hw *hw);
-
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PRIVATE_H */
-- 
1.9.3

