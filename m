Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaAMUyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40416 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/38] perf trace: Pack 'struct trace'
Date: Mon, 13 Jan 2014 17:47:16 -0300
Message-Id: <1389646059-24881-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Initial struct stats:

	/* size: 368, cachelines: 6, members: 24 */
	/* sum members: 353, holes: 3, sum holes: 15 */
	/* last cacheline: 48 bytes */

After reorg:

[acme@ssdandy linux]$ pahole -C trace ~/bin/trace | tail -4
	/* size: 360, cachelines: 6, members: 24 */
	/* padding: 7 */
	/* last cacheline: 40 bytes */
};
[acme@ssdandy linux]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6jimc80yu89qkx6zb8465s6t@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 399b4b91b456..4bd44aba343e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1160,26 +1160,27 @@ struct trace {
 	struct record_opts	opts;
 	struct machine		*host;
 	u64			base_time;
-	bool			full_time;
 	FILE			*output;
 	unsigned long		nr_events;
 	struct strlist		*ev_qualifier;
-	bool			not_ev_qualifier;
-	bool			live;
 	const char 		*last_vfs_getname;
 	struct intlist		*tid_list;
 	struct intlist		*pid_list;
+	double			duration_filter;
+	double			runtime_ms;
+	struct {
+		u64		vfs_getname,
+				proc_getname;
+	} stats;
+	bool			not_ev_qualifier;
+	bool			live;
+	bool			full_time;
 	bool			sched;
 	bool			multiple_threads;
 	bool			summary;
 	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
-	double			duration_filter;
-	double			runtime_ms;
-	struct {
-		u64		vfs_getname, proc_getname;
-	} stats;
 };
 
 static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
-- 
1.8.1.4

