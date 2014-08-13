Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaHMFWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:22:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44738 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaHMFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:13:57 -0400
Date: Tue, 12 Aug 2014 22:13:37 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-07mrqzcuhsks9wfmxrzsvemz@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Rename ordered_samples bool to ordered_events
Git-Commit-ID: 0a8cb85c200c4082ed7e57efd90dd9d18c8d40b6
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

Commit-ID:  0a8cb85c200c4082ed7e57efd90dd9d18c8d40b6
Gitweb:     http://git.kernel.org/tip/0a8cb85c200c4082ed7e57efd90dd9d18c8d40b6
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 6 Jul 2014 14:18:21 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:54 -0300

perf tools: Rename ordered_samples bool to ordered_events

The time ordering is generic for all kinds of events, so using generic
name 'ordered_events' for ordered_samples bool in perf_tool struct.

No functional change was intended.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-07mrqzcuhsks9wfmxrzsvemz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |  2 +-
 tools/perf/builtin-diff.c      |  2 +-
 tools/perf/builtin-inject.c    |  2 +-
 tools/perf/builtin-kmem.c      |  2 +-
 tools/perf/builtin-kvm.c       |  4 ++--
 tools/perf/builtin-lock.c      |  2 +-
 tools/perf/builtin-mem.c       |  2 +-
 tools/perf/builtin-report.c    |  2 +-
 tools/perf/builtin-sched.c     |  2 +-
 tools/perf/builtin-script.c    |  2 +-
 tools/perf/builtin-timechart.c |  2 +-
 tools/perf/builtin-trace.c     |  2 +-
 tools/perf/util/session.c      | 10 +++++-----
 tools/perf/util/tool.h         |  2 +-
 14 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1ec429f..952b5ec 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -297,7 +297,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 			.comm	= perf_event__process_comm,
 			.exit	= perf_event__process_exit,
 			.fork	= perf_event__process_fork,
-			.ordered_samples = true,
+			.ordered_events = true,
 			.ordering_requires_timestamps = true,
 		},
 	};
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9a5a035..c10cc44 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -360,7 +360,7 @@ static struct perf_tool tool = {
 	.exit	= perf_event__process_exit,
 	.fork	= perf_event__process_fork,
 	.lost	= perf_event__process_lost,
-	.ordered_samples = true,
+	.ordered_events = true,
 	.ordering_requires_timestamps = true,
 };
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 9a02807..ee875cc 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -366,7 +366,7 @@ static int __cmd_inject(struct perf_inject *inject)
 	} else if (inject->sched_stat) {
 		struct perf_evsel *evsel;
 
-		inject->tool.ordered_samples = true;
+		inject->tool.ordered_events = true;
 
 		evlist__for_each(session->evlist, evsel) {
 			const char *name = perf_evsel__name(evsel);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index bef3376..b572111 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -256,7 +256,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool perf_kmem = {
 	.sample		 = process_sample_event,
 	.comm		 = perf_event__process_comm,
-	.ordered_samples = true,
+	.ordered_events	 = true,
 };
 
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index fe92dfd..a05f435 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1058,7 +1058,7 @@ static int read_events(struct perf_kvm_stat *kvm)
 	struct perf_tool eops = {
 		.sample			= process_sample_event,
 		.comm			= perf_event__process_comm,
-		.ordered_samples	= true,
+		.ordered_events		= true,
 	};
 	struct perf_data_file file = {
 		.path = kvm->file_name,
@@ -1311,7 +1311,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	kvm->tool.exit   = perf_event__process_exit;
 	kvm->tool.fork   = perf_event__process_fork;
 	kvm->tool.lost   = process_lost_event;
-	kvm->tool.ordered_samples = true;
+	kvm->tool.ordered_events = true;
 	perf_tool__fill_defaults(&kvm->tool);
 
 	/* set defaults */
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6148afc..c8122d3 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -852,7 +852,7 @@ static int __cmd_report(bool display_info)
 	struct perf_tool eops = {
 		.sample		 = process_sample_event,
 		.comm		 = perf_event__process_comm,
-		.ordered_samples = true,
+		.ordered_events	 = true,
 	};
 	struct perf_data_file file = {
 		.path = input_name,
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 4a1a6c9..80e57c8 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -194,7 +194,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 			.lost		= perf_event__process_lost,
 			.fork		= perf_event__process_fork,
 			.build_id	= perf_event__process_build_id,
-			.ordered_samples = true,
+			.ordered_events	= true,
 		},
 		.input_name		 = "perf.data",
 	};
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 21d830b..c72cc5a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -578,7 +578,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		 = perf_event__process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
-			.ordered_samples = true,
+			.ordered_events	 = true,
 			.ordering_requires_timestamps = true,
 		},
 		.max_stack		 = PERF_MAX_STACK_DEPTH,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f83c08c..7c16aeb 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1662,7 +1662,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 			.comm		 = perf_event__process_comm,
 			.lost		 = perf_event__process_lost,
 			.fork		 = perf_sched__process_fork_event,
-			.ordered_samples = true,
+			.ordered_events = true,
 		},
 		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
 		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f57035b..868c17d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1488,7 +1488,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		 = process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
-			.ordered_samples = true,
+			.ordered_events	 = true,
 			.ordering_requires_timestamps = true,
 		},
 	};
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 2f1a522..912e3b5 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1920,7 +1920,7 @@ int cmd_timechart(int argc, const char **argv,
 			.fork		 = process_fork_event,
 			.exit		 = process_exit_event,
 			.sample		 = process_sample_event,
-			.ordered_samples = true,
+			.ordered_events	 = true,
 		},
 		.proc_num = 15,
 		.min_time = 1000000,
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a6c3752..36ae51d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2209,7 +2209,7 @@ static int trace__replay(struct trace *trace)
 	trace->tool.tracing_data = perf_event__process_tracing_data;
 	trace->tool.build_id	  = perf_event__process_build_id;
 
-	trace->tool.ordered_samples = true;
+	trace->tool.ordered_events = true;
 	trace->tool.ordering_requires_timestamps = true;
 
 	/* add tid to output */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 88dfef7..a2c97ff 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -104,9 +104,9 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 	}
 
 	if (tool && tool->ordering_requires_timestamps &&
-	    tool->ordered_samples && !perf_evlist__sample_id_all(session->evlist)) {
+	    tool->ordered_events && !perf_evlist__sample_id_all(session->evlist)) {
 		dump_printf("WARNING: No sample_id_all support, falling back to unordered processing\n");
-		tool->ordered_samples = false;
+		tool->ordered_events = false;
 	}
 
 	return session;
@@ -238,7 +238,7 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 	if (tool->build_id == NULL)
 		tool->build_id = process_finished_round_stub;
 	if (tool->finished_round == NULL) {
-		if (tool->ordered_samples)
+		if (tool->ordered_events)
 			tool->finished_round = process_finished_round;
 		else
 			tool->finished_round = process_finished_round_stub;
@@ -483,7 +483,7 @@ static int flush_sample_queue(struct perf_session *s,
 	struct ui_progress prog;
 	int ret;
 
-	if (!tool->ordered_samples || !limit)
+	if (!tool->ordered_events || !limit)
 		return 0;
 
 	if (show_progress)
@@ -1062,7 +1062,7 @@ static s64 perf_session__process_event(struct perf_session *session,
 	if (ret)
 		return ret;
 
-	if (tool->ordered_samples) {
+	if (tool->ordered_events) {
 		ret = perf_session_queue_event(session, event, &sample,
 					       file_offset);
 		if (ret != -ETIME)
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 4385816..f116369 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -40,7 +40,7 @@ struct perf_tool {
 	event_op2	tracing_data;
 	event_op2	finished_round,
 			build_id;
-	bool		ordered_samples;
+	bool		ordered_events;
 	bool		ordering_requires_timestamps;
 };
 
