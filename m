Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaJIPCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:02:54 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59361 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbaJIPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:02:21 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/8] clk: change clk_debugfs_add_file to take a struct clk_hw
Date: Thu,  9 Oct 2014 17:01:13 +0200
Message-Id: <1412866903-6970-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com>
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
index 3c650c4..627dc91 100644
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

