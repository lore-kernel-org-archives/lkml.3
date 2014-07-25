Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbaGYO4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbaGYO4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:56:38 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/19] perf tools: Rename ordered_samples bool to ordered_events
Date: Fri, 25 Jul 2014 16:56:00 +0200
Message-Id: <1406300177-31805-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time ordering is generic for all kinds of events, so using
generic name 'ordered_events' for ordered_samples bool in
perf_tool struct.

No functional change was intended.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
index 1ec429fef2be..952b5ece6740 100644
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
index 9a5a035cb426..c10cc44bae19 100644
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
index cf6a605a13e8..cbfd1a020b74 100644
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
index bef3376bfaf3..b5721116713b 100644
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
index 43367eb00510..25f0c287c5c5 100644
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
index 6148afc995c6..c8122d323621 100644
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
index 4a1a6c94a5eb..80e57c84adef 100644
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
index 21d830bafff3..c72cc5a12144 100644
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
index f83c08c0dd87..7c16aeb6b675 100644
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
index 9e9c91f5b7fa..ba4162e707e0 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1510,7 +1510,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		 = process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
-			.ordered_samples = true,
+			.ordered_events	 = true,
 			.ordering_requires_timestamps = true,
 		},
 	};
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 2f1a5220c090..912e3b5bb22b 100644
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
index c4a5a7d7b2cf..552831ad88dc 100644
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
index ff6a69afe045..0362cfcfb0a5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -105,9 +105,9 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 	}
 
 	if (tool && tool->ordering_requires_timestamps &&
-	    tool->ordered_samples && !perf_evlist__sample_id_all(session->evlist)) {
+	    tool->ordered_events && !perf_evlist__sample_id_all(session->evlist)) {
 		dump_printf("WARNING: No sample_id_all support, falling back to unordered processing\n");
-		tool->ordered_samples = false;
+		tool->ordered_events = false;
 	}
 
 	return session;
@@ -240,7 +240,7 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 	if (tool->build_id == NULL)
 		tool->build_id = process_finished_round_stub;
 	if (tool->finished_round == NULL) {
-		if (tool->ordered_samples)
+		if (tool->ordered_events)
 			tool->finished_round = process_finished_round;
 		else
 			tool->finished_round = process_finished_round_stub;
@@ -485,7 +485,7 @@ static int flush_sample_queue(struct perf_session *s,
 	struct ui_progress prog;
 	int ret;
 
-	if (!tool->ordered_samples || !limit)
+	if (!tool->ordered_events || !limit)
 		return 0;
 
 	if (show_progress)
@@ -1062,7 +1062,7 @@ static int perf_session__process_event(struct perf_session *session,
 	if (ret)
 		return ret;
 
-	if (tool->ordered_samples) {
+	if (tool->ordered_events) {
 		ret = perf_session_queue_event(session, event, &sample,
 					       file_offset);
 		if (ret != -ETIME)
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 4385816d3d49..f11636966a0f 100644
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
 
-- 
1.8.3.1

