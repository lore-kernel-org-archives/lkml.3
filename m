Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3FEPHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:07:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18689 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3FEPHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:07:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 08:06:42 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] clk: use clk_get_rate() for debugfs
Date: Wed, 5 Jun 2013 18:06:35 +0300
Message-ID: <1370444796-18648-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370444796-18648-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370444796-18648-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs uses the rate field directly. However this ignores the
CLK_GET_RATE_NOCACHE flag. Call clk_get_rate() instead.

Tested-by: Mark Zhang <markz@nvidia.com>
Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index af0dbcc..9b2f941 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -107,7 +107,7 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "%*s%-*s %-11d %-12d %-10lu",
 		   level * 3 + 1, "",
 		   30 - level * 3, c->name,
-		   c->enable_count, c->prepare_count, c->rate);
+		   c->enable_count, c->prepare_count, clk_get_rate(c));
 	seq_printf(s, "\n");
 }
 
@@ -166,7 +166,7 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "\"%s\": { ", c->name);
 	seq_printf(s, "\"enable_count\": %d,", c->enable_count);
 	seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
-	seq_printf(s, "\"rate\": %lu", c->rate);
+	seq_printf(s, "\"rate\": %lu", clk_get_rate(c));
 }
 
 static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
-- 
1.7.7.rc0.72.g4b5ea.dirty

