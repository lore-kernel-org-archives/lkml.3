Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3I2Aj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 20:39:29 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39114 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3I2AjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 20:39:00 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 2/3] clk: Use kcalloc() to allocate arrays
Date: Sun, 29 Sep 2013 02:37:15 +0200
Message-Id: <1380415036-15997-2-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380415036-15997-1-git-send-email-tomasz.figa@gmail.com>
References: <1380415036-15997-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calculating sizes of arrays manually, kcalloc() can be used
to allocate arrays of elements with defined size. This is just a cleanup
patch without any functional changes.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/clk/clk.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9e0a837..63f9ac1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1085,8 +1085,8 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
 	int i;
 
 	if (!clk->parents) {
-		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
-								GFP_KERNEL);
+		clk->parents = kcalloc(clk->num_parents,
+					sizeof(struct clk *), GFP_KERNEL);
 		if (!clk->parents)
 			return -ENOMEM;
 	}
@@ -1535,7 +1535,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
 
 	if (!clk->parents)
 		clk->parents =
-			kzalloc((sizeof(struct clk*) * clk->num_parents),
+			kcalloc(clk->num_parents, sizeof(struct clk *),
 					GFP_KERNEL);
 
 	ret = clk_get_parent_by_index(clk, index);
@@ -1692,8 +1692,8 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * for clock drivers to statically initialize clk->parents.
 	 */
 	if (clk->num_parents > 1 && !clk->parents) {
-		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
-				GFP_KERNEL);
+		clk->parents = kcalloc(clk->num_parents, sizeof(struct clk *),
+					GFP_KERNEL);
 		/*
 		 * __clk_lookup returns NULL for parents that have not been
 		 * clk_init'd; thus any access to clk->parents[] must check
@@ -1833,8 +1833,8 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 	hw->clk = clk;
 
 	/* allocate local copy in case parent_names is __initdata */
-	clk->parent_names = kzalloc((sizeof(char*) * clk->num_parents),
-			GFP_KERNEL);
+	clk->parent_names = kcalloc(clk->num_parents, sizeof(char *),
+					GFP_KERNEL);
 
 	if (!clk->parent_names) {
 		pr_err("%s: could not allocate clk->parent_names\n", __func__);
-- 
1.8.3.2

