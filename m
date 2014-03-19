Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbaCSNHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:07:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933771AbaCSNGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:06:54 -0400
Date: Wed, 19 Mar 2014 06:06:39 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-80790e0b7ef768b6591fdf764b62c572b76a5d80@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, artagnon@gmail.com, tglx@linutronix.de
In-Reply-To: <1395065901-25740-1-git-send-email-artagnon@gmail.com>
References: <1395065901-25740-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Fixup header alignment in 'latency'
  output
Git-Commit-ID: 80790e0b7ef768b6591fdf764b62c572b76a5d80
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80790e0b7ef768b6591fdf764b62c572b76a5d80
Gitweb:     http://git.kernel.org/tip/80790e0b7ef768b6591fdf764b62c572b76a5d80
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Mon, 17 Mar 2014 10:18:21 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:16:55 -0300

perf sched: Fixup header alignment in 'latency' output

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
 
