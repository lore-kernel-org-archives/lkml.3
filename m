Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321AbaLBIAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:00:48 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61609 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbaLBH4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:56:09 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v7 4/7] clk: change clk_debugfs_add_file to take a struct clk_hw
Date: Tue,  2 Dec 2014 08:54:21 +0100
Message-Id: <1417506933-8915-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
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
index 73247e9..f549e8b 100644
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
index 270137a..5e06f23 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -650,7 +650,7 @@ static inline void clk_writel(u32 val, u32 __iomem *reg)
 #endif	/* platform dependent I/O accessors */
 
 #ifdef CONFIG_DEBUG_FS
-struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+struct dentry *clk_debugfs_add_file(struct clk_hw *hw, char *name, umode_t mode,
 				void *data, const struct file_operations *fops);
 #endif
 
-- 
1.9.3

