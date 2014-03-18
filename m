Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbaCRV0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaCRV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/13] perf sched: Fixup header alignment in 'latency' output
Date: Tue, 18 Mar 2014 18:25:54 -0300
Message-Id: <1395177965-8879-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

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

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395065901-25740-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6a76a07b6789..9ac0a495c954 100644
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
1.8.1.4

