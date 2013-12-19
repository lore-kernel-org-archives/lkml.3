Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab3LSFoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:44:15 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54324 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3LSFoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:44:14 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH] clk: remove CONFIG_COMMON_CLK_DEBUG
Date: Wed, 18 Dec 2013 21:43:20 -0800
Message-Id: <1387431800-10092-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate ${DEBUGS_MOUNT_POINT}/clk if CONFIG_DEBUG_FS is set. This
eliminates the extra (annoying) step of enabling the config option
manually.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Kconfig         | 10 ----------
 drivers/clk/clk.c           |  2 +-
 include/linux/clk-private.h |  2 +-
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 3089f05..407cffb 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -23,16 +23,6 @@ config COMMON_CLK
 menu "Common Clock Framework"
 	depends on COMMON_CLK
 
-config COMMON_CLK_DEBUG
-	bool "DebugFS representation of clock tree"
-	select DEBUG_FS
-	---help---
-	  Creates a directory hierarchy in debugfs for visualizing the clk
-	  tree structure.  Each directory contains read-only members
-	  that export information specific to that clk node: clk_rate,
-	  clk_flags, clk_prepare_count, clk_enable_count &
-	  clk_notifier_count.
-
 config COMMON_CLK_WM831X
 	tristate "Clock driver for WM831x/2x PMICs"
 	depends on MFD_WM831X
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8312736..41e46df 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -92,7 +92,7 @@ static void clk_enable_unlock(unsigned long flags)
 
 /***        debugfs support        ***/
 
-#ifdef CONFIG_COMMON_CLK_DEBUG
+#ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 
 static struct dentry *rootdir;
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 8138c94..98f8614 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -44,7 +44,7 @@ struct clk {
 	struct hlist_head	children;
 	struct hlist_node	child_node;
 	unsigned int		notifier_count;
-#ifdef CONFIG_COMMON_CLK_DEBUG
+#ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
 #endif
 };
-- 
1.8.3.2

