Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3IICUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:20:25 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:45945 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3IICTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:19:37 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 5/7] perf lock: do not cut lock name
Date: Sun,  8 Sep 2013 19:19:17 -0700
Message-Id: <1378693159-8747-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
References: <1378693159-8747-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While this could be seen as personal taste, there really isn't any
reason for being so stingy printing the lock name. Furthermore, some
symbol names are really just too long, and cutting them at 16 characters
doesn't help at all.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/builtin-lock.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 780484f..2674a42 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -696,10 +696,9 @@ static void print_bad_events(int bad, int total)
 static void print_result(void)
 {
 	struct lock_stat *st;
-	char cut_name[20];
 	int bad, total;
 
-	pr_info("%20s ", "Name");
+	pr_info("%40s ", "Name");
 	pr_info("%10s ", "acquired");
 	pr_info("%10s ", "contended");
 
@@ -716,21 +715,8 @@ static void print_result(void)
 			bad++;
 			continue;
 		}
-		bzero(cut_name, 20);
-
-		if (strlen(st->name) < 16) {
-			/* output raw name */
-			pr_info("%20s ", st->name);
-		} else {
-			strncpy(cut_name, st->name, 16);
-			cut_name[16] = '.';
-			cut_name[17] = '.';
-			cut_name[18] = '.';
-			cut_name[19] = '\0';
-			/* cut off name for saving output style */
-			pr_info("%20s ", cut_name);
-		}
 
+		pr_info("%40s ", st->name);
 		pr_info("%10u ", st->nr_acquired);
 		pr_info("%10u ", st->nr_contended);
 
-- 
1.7.11.7

