Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaJCNnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:43:35 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:41382 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaJCNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:43:34 -0400
From: Stefan Agner <stefan@agner.ch>
To: mturquette@linaro.org
Cc: geert+renesas@glider.be, linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH] clk: Neaten clk_summary output even more
Date: Fri,  3 Oct 2014 15:43:28 +0200
Message-Id: <1412343808-10790-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SoC have lots of clock gates, mux and divider options and hence
a deep clock tree. This patch makes more room for the clock name as
well as decreases the indent per level from 3 to 2 spaces.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
Before:
...
                      sys_sel                   1            1   500210526          0
                         sys_bus                2            2   500210526          0
                            platform_bus           7            7   166736842          0
                               dmamux3           1            1   166736842          0
                               dmamux2           1            1   166736842          0
                               dmamux1           1            1   166736842          0
                               dmamux0           1            1   166736842          0
                               esdhc1_sel           0            0   166736842          0
                                  esdhc1_en           0            0   166736842          0
                                     esdhc1_div           0            0   166736842          0
                                        eshc1           0            0   166736842          0

After:
...
                 sys_sel                     1         1   500210526          0
                   sys_bus                   2         2   500210526          0
                     platform_bus            7         7   166736842          0
                       dmamux3               1         1   166736842          0
                       dmamux2               1         1   166736842          0
                       dmamux1               1         1   166736842          0
                       dmamux0               1         1   166736842          0
                       esdhc1_sel            0         0   166736842          0
                         esdhc1_en           0         0   166736842          0
                           esdhc1_div        0         0   166736842          0
                             eshc1           0         0   166736842          0

 drivers/clk/clk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b76fa69..7018815 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -117,9 +117,9 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 	if (!c)
 		return;
 
-	seq_printf(s, "%*s%-*s %11d %12d %11lu %10lu\n",
-		   level * 3 + 1, "",
-		   30 - level * 3, c->name,
+	seq_printf(s, "%*s%-*s %7d %9d %11lu %10lu\n",
+		   level * 2 + 1, "",
+		   37 - level * 2, c->name,
 		   c->enable_count, c->prepare_count, clk_get_rate(c),
 		   clk_get_accuracy(c));
 }
@@ -143,7 +143,7 @@ static int clk_summary_show(struct seq_file *s, void *data)
 	struct clk *c;
 	struct hlist_head **lists = (struct hlist_head **)s->private;
 
-	seq_puts(s, "   clock                         enable_cnt  prepare_cnt        rate   accuracy\n");
+	seq_puts(s, " clock                                  en_cnt  prep_cnt        rate   accuracy\n");
 	seq_puts(s, "--------------------------------------------------------------------------------\n");
 
 	clk_prepare_lock();
-- 
2.1.2

