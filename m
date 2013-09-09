Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3IICTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:19:40 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25640 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3IICTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:19:38 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 6/7] perf lock: limit bad rate precision
Date: Sun,  8 Sep 2013 19:19:18 -0700
Message-Id: <1378693159-8747-7-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two decimal precision should be enough for this.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/builtin-lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2674a42..5adebe6 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -686,7 +686,7 @@ static void print_bad_events(int bad, int total)
 
 	pr_info("\n=== output for debug===\n\n");
 	pr_info("bad: %d, total: %d\n", bad, total);
-	pr_info("bad rate: %f %%\n", (double)bad / (double)total * 100);
+	pr_info("bad rate: %.2f %%\n", (double)bad / (double)total * 100);
 	pr_info("histogram of events caused bad sequence\n");
 	for (i = 0; i < BROKEN_MAX; i++)
 		pr_info(" %10s: %d\n", name[i], bad_hist[i]);
-- 
1.7.11.7

