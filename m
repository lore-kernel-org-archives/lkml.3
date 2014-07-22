Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaGVCU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:20:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46282 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaGVCU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:20:56 -0400
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, s.trumtrar@pengutronix.de,
        dinguyen@altera.com, cslee@altera.com
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 1/3] clk : Clean up checkpatch warnings
Date: Tue, 22 Jul 2014 14:20:32 +1200
Message-Id: <1405995634-3297-2-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
References: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 drivers/clk/clk.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73ede..ec41922 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -99,7 +99,7 @@ static void clk_enable_unlock(unsigned long flags)
 
 static struct dentry *rootdir;
 static struct dentry *orphandir;
-static int inited = 0;
+static int inited;
 
 static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 {
@@ -182,11 +182,11 @@ static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
 	clk_dump_one(s, c, level);
 
 	hlist_for_each_entry(child, &c->children, child_node) {
-		seq_printf(s, ",");
+		seq_puts(s, ",");
 		clk_dump_subtree(s, child, level + 1);
 	}
 
-	seq_printf(s, "}");
+	seq_puts(s, "}");
 }
 
 static int clk_dump(struct seq_file *s, void *data)
@@ -194,25 +194,25 @@ static int clk_dump(struct seq_file *s, void *data)
 	struct clk *c;
 	bool first_node = true;
 
-	seq_printf(s, "{");
+	seq_puts(s, "{");
 
 	clk_prepare_lock();
 
 	hlist_for_each_entry(c, &clk_root_list, child_node) {
 		if (!first_node)
-			seq_printf(s, ",");
+			seq_puts(s, ",");
 		first_node = false;
 		clk_dump_subtree(s, c, 0);
 	}
 
 	hlist_for_each_entry(c, &clk_orphan_list, child_node) {
-		seq_printf(s, ",");
+		seq_puts(s, ",");
 		clk_dump_subtree(s, c, 0);
 	}
 
 	clk_prepare_unlock();
 
-	seq_printf(s, "}");
+	seq_puts(s, "}");
 	return 0;
 }
 
@@ -294,7 +294,7 @@ out:
 static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
 {
 	struct clk *child;
-	int ret = -EINVAL;;
+	int ret = -EINVAL;
 
 	if (!clk || !pdentry)
 		goto out;
@@ -1455,7 +1455,8 @@ out:
  * so that in case of an error we can walk down the whole tree again and
  * abort the change.
  */
-static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
+static struct clk *clk_propagate_rate_change(struct clk *clk,
+					     unsigned long event)
 {
 	struct clk *child, *tmp_clk, *fail_clk = NULL;
 	int ret = NOTIFY_DONE;
@@ -1798,14 +1799,14 @@ int __clk_init(struct device *dev, struct clk *clk)
 	if (clk->ops->set_rate &&
 	    !((clk->ops->round_rate || clk->ops->determine_rate) &&
 	      clk->ops->recalc_rate)) {
-		pr_warning("%s: %s must implement .round_rate or .determine_rate in addition to .recalc_rate\n",
+		pr_warn("%s: %s must implement .round_rate or .determine_rate in addition to .recalc_rate\n",
 				__func__, clk->name);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (clk->ops->set_parent && !clk->ops->get_parent) {
-		pr_warning("%s: %s must implement .get_parent & .set_parent\n",
+		pr_warn("%s: %s must implement .get_parent & .set_parent\n",
 				__func__, clk->name);
 		ret = -EINVAL;
 		goto out;
@@ -2116,8 +2117,8 @@ void clk_unregister(struct clk *clk)
 {
 	unsigned long flags;
 
-       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
-               return;
+	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
+		return;
 
 	clk_prepare_lock();
 
@@ -2194,6 +2195,7 @@ EXPORT_SYMBOL_GPL(devm_clk_register);
 static int devm_clk_match(struct device *dev, void *res, void *data)
 {
 	struct clk *c = res;
+
 	if (WARN_ON(!c))
 		return 0;
 	return c == data;
@@ -2409,8 +2411,9 @@ EXPORT_SYMBOL_GPL(of_clk_src_onecell_get);
  * @data: context pointer for @clk_src_get callback.
  */
 int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *clkspec,
-						   void *data),
+			struct clk *(*clk_src_get)
+					(struct of_phandle_args *clkspec,
+					 void *data),
 			void *data)
 {
 	struct of_clk_provider *cp;
-- 
1.9.1

