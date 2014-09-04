Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbaIDBCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:02:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39513 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102AbaIDBBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:01:10 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 3/4] clk: Use lockless functions for debug printing
Date: Wed,  3 Sep 2014 18:01:05 -0700
Message-Id: <1409792466-5092-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future we're going to move the prepare lock to a
per-clock ww_mutex. Use the lockless functions here for printing
the rate and accuracy so that we don't run into AA deadlocks in
the future.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 248a8612a12d..d2da11674f0b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -122,8 +122,8 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "%*s%-*s %11d %12d %11lu %10lu\n",
 		   level * 3 + 1, "",
 		   30 - level * 3, c->name,
-		   c->enable_count, c->prepare_count, clk_get_rate(c),
-		   clk_get_accuracy(c));
+		   c->enable_count, c->prepare_count, __clk_get_rate(c),
+		   __clk_get_accuracy(c));
 }
 
 static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
@@ -180,8 +180,8 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "\"%s\": { ", c->name);
 	seq_printf(s, "\"enable_count\": %d,", c->enable_count);
 	seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
-	seq_printf(s, "\"rate\": %lu", clk_get_rate(c));
-	seq_printf(s, "\"accuracy\": %lu", clk_get_accuracy(c));
+	seq_printf(s, "\"rate\": %lu", __clk_get_rate(c));
+	seq_printf(s, "\"accuracy\": %lu", __clk_get_accuracy(c));
 }
 
 static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

