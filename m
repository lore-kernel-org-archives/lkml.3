Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaANQjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:39:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaANQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:39:26 -0500
Date: Tue, 14 Jan 2014 08:38:49 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6jimc80yu89qkx6zb8465s6t@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Pack 'struct trace'
Git-Commit-ID: 98eafce6bda705529e90d33b7f23706b346a6c8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:38:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98eafce6bda705529e90d33b7f23706b346a6c8a
Gitweb:     http://git.kernel.org/tip/98eafce6bda705529e90d33b7f23706b346a6c8a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 6 Jan 2014 15:43:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:23 -0300

perf trace: Pack 'struct trace'

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
index 399b4b9..4bd44ab 100644
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
