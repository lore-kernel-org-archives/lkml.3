Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaJGPWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:22:55 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48156 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaJGPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:22:53 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] clk: change clk_debugfs_add_file to take a struct clk_hw
Date: Tue,  7 Oct 2014 17:21:50 +0200
Message-Id: <1412695334-2608-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of struct clk, as this should be only used by providers.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c            | 6 +++---
 include/linux/clk-provider.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1dcd81a..a344d3e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -361,13 +361,13 @@ static void clk_debug_unregister(struct clk *clk)
 	debugfs_remove_recursive(clk->dentry);
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
index eef1778..37bd7a5 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -618,7 +618,7 @@ static inline void clk_writel(u32 val, u32 __iomem *reg)
 #endif	/* platform dependent I/O accessors */
 
 #ifdef CONFIG_DEBUG_FS
-struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+struct dentry *clk_debugfs_add_file(struct clk_hw *hw, char *name, umode_t mode,
 				void *data, const struct file_operations *fops);
 #endif
 
-- 
1.9.3

