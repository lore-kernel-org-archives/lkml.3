Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbbATN0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:26:51 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61977 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbbATNZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:25:21 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v10 1/3] clk: Remove unneeded NULL checks
Date: Tue, 20 Jan 2015 14:24:57 +0100
Message-Id: <1421760306-6301-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421760306-6301-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1421760306-6301-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As clk_unprepare_unused_subtree and clk_disable_unused_subtree are
always called with a valid struct clk.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4963b7..97f3425 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -432,9 +432,6 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 {
 	struct clk *child;
 
-	if (!clk)
-		return;
-
 	hlist_for_each_entry(child, &clk->children, child_node)
 		clk_unprepare_unused_subtree(child);
 
@@ -458,9 +455,6 @@ static void clk_disable_unused_subtree(struct clk *clk)
 	struct clk *child;
 	unsigned long flags;
 
-	if (!clk)
-		goto out;
-
 	hlist_for_each_entry(child, &clk->children, child_node)
 		clk_disable_unused_subtree(child);
 
@@ -486,9 +480,6 @@ static void clk_disable_unused_subtree(struct clk *clk)
 
 unlock_out:
 	clk_enable_unlock(flags);
-
-out:
-	return;
 }
 
 static bool clk_ignore_unused;
-- 
1.9.3

