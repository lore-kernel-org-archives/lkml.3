Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3JNUat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38896 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 083/161] perf lock: Limit bad rate precision
Date: Mon, 14 Oct 2013 17:01:12 -0300
Message-Id: <1381780950-25642-84-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Two decimal precision should be enough for this.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378693159-8747-7-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 780484fb59a0..972310cbeb63 100644
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
1.8.1.4

