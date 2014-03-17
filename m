Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbaCQORk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:17:40 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:51604 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaCQORj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:17:39 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v2] perf sched latency: prettify printed table
Date: Mon, 17 Mar 2014 10:18:21 -0400
Message-Id: <1395065901-25740-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
In-Reply-To: <20140317065143.GA1240@krava.brq.redhat.com>
References: <20140317065143.GA1240@krava.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:

 ---------------------------------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |
 ---------------------------------------------------------------------------------------------------------------
  ...                   |               |          |                  |                  |
  git:24540             |    336.622 ms |       10 | avg:    0.032 ms | max:    0.062 ms | max at: 115610.111046 s
  git:24541             |      0.457 ms |        1 | avg:    0.000 ms | max:    0.000 ms | max at:  0.000000 s
 -----------------------------------------------------------------------------------------
  TOTAL:                |    396.542 ms |      353 |
 ---------------------------------------------------

After:

 -----------------------------------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at       |
 -----------------------------------------------------------------------------------------------------------------
  ...                   |               |          |                  |                  |
  git:24540             |    336.622 ms |       10 | avg:    0.032 ms | max:    0.062 ms | max at: 115610.111046 s
  git:24541             |      0.457 ms |        1 | avg:    0.000 ms | max:    0.000 ms | max at:      0.000000 s
 -----------------------------------------------------------------------------------------------------------------
  TOTAL:                |    396.542 ms |      353 |
 ---------------------------------------------------

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-sched.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6a76a07..9ac0a49 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1124,7 +1124,7 @@ static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_
 
 	avg = work_list->total_lat / work_list->nb_atoms;
 
-	printf("|%11.3f ms |%9" PRIu64 " | avg:%9.3f ms | max:%9.3f ms | max at: %9.6f s\n",
+	printf("|%11.3f ms |%9" PRIu64 " | avg:%9.3f ms | max:%9.3f ms | max at: %13.6f s\n",
 	      (double)work_list->total_runtime / 1e6,
 		 work_list->nb_atoms, (double)avg / 1e6,
 		 (double)work_list->max_lat / 1e6,
@@ -1527,9 +1527,9 @@ static int perf_sched__lat(struct perf_sched *sched)
 
 	perf_sched__sort_lat(sched);
 
-	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
-	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |\n");
-	printf(" ---------------------------------------------------------------------------------------------------------------\n");
+	printf("\n -----------------------------------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at       |\n");
+	printf(" -----------------------------------------------------------------------------------------------------------------\n");
 
 	next = rb_first(&sched->sorted_atom_root);
 
@@ -1541,7 +1541,7 @@ static int perf_sched__lat(struct perf_sched *sched)
 		next = rb_next(next);
 	}
 
-	printf(" -----------------------------------------------------------------------------------------\n");
+	printf(" -----------------------------------------------------------------------------------------------------------------\n");
 	printf("  TOTAL:                |%11.3f ms |%9" PRIu64 " |\n",
 		(double)sched->all_runtime / 1e6, sched->all_count);
 
-- 
1.9.0.431.g014438b

