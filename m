Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaJTNll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:41:41 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33406 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaJTNl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:41:28 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/8] clk: change clk_debugfs_add_file to take a struct clk_hw
Date: Mon, 20 Oct 2014 15:40:05 +0200
Message-Id: <1413812442-24956-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of struct clk, as this should be only used by providers.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 6 +++---
 include/linux/clk-provider.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 99cb0a1..909fbae 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -354,13 +354,13 @@ out:
 	mutex_unlock(&clk_debug_lock);
 }
 
-struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+struct dentry *clk_debugfs_add_file(struct clk_hw *hw, char *name, umode_t mode,
 				void *data, const struct file_operations *fops)
 {
 	struct dentry *d = NULL;
 
-	if (clk->dentry)
-		d = debugfs_create_file(name, mode, clk->dentry, data, fops);
+	if (hw->clk->dentry)
+		d = debugfs_create_file(name, mode, hw->clk->dentry, data, fops);
 
 	return d;
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 67c29e5..55f3b49 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -651,7 +651,7 @@ static inline void clk_writel(u32 val, u32 __iomem *reg)
 #endif	/* platform dependent I/O accessors */
 
 #ifdef CONFIG_DEBUG_FS
-struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+struct dentry *clk_debugfs_add_file(struct clk_hw *hw, char *name, umode_t mode,
 				void *data, const struct file_operations *fops);
 #endif
 
-- 
1.9.3

