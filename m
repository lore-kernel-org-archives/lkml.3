Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaFRO72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:59:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaFRO7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:59:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/18] perf tools: Rename ordered_samples to ordered_events
Date: Wed, 18 Jun 2014 16:58:44 +0200
Message-Id: <1403103539-16807-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time ordering is generic for all kinds of events, so
using generic name 'ordered_events' for related struct.

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
 tools/perf/builtin-kvm.c       |  6 ++--
 tools/perf/builtin-lock.c      |  2 +-
 tools/perf/builtin-mem.c       |  2 +-
 tools/perf/builtin-report.c    |  2 +-
 tools/perf/builtin-sched.c     |  2 +-
 tools/perf/builtin-script.c    |  2 +-
 tools/perf/builtin-timechart.c |  2 +-
 tools/perf/builtin-trace.c     |  2 +-
 tools/perf/util/session.c      | 64 +++++++++++++++++++++---------------------
 tools/perf/util/session.h      | 24 ++++++++--------
 tools/perf/util/tool.h         |  2 +-
 15 files changed, 59 insertions(+), 59 deletions(-)

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
index 16c7c11..94173dd 100644
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
index 0f1e5a2..b2f0ddb 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -955,7 +955,7 @@ static int perf_kvm__mmap_read(struct perf_kvm_stat *kvm)
 
 	/* flush queue after each round in which we processed events */
 	if (ntotal) {
-		kvm->session->ordered_samples.next_flush = flush_time;
+		kvm->session->ordered_events.next_flush = flush_time;
 		err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
 		if (err) {
 			if (kvm->lost_events)
@@ -1228,7 +1228,7 @@ static int read_events(struct perf_kvm_stat *kvm)
 	struct perf_tool eops = {
 		.sample			= process_sample_event,
 		.comm			= perf_event__process_comm,
-		.ordered_samples	= true,
+		.ordered_events		= true,
 	};
 	struct perf_data_file file = {
 		.path = kvm->file_name,
@@ -1480,7 +1480,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
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
index c38d06c..5cb39a3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1660,7 +1660,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 			.comm		 = perf_event__process_comm,
 			.lost		 = perf_event__process_lost,
 			.fork		 = perf_sched__process_fork_event,
-			.ordered_samples = true,
+			.ordered_events = true,
 		},
 		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
 		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9e9c91f..ba4162e 100644
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
index 74db256..257d9d6 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1279,7 +1279,7 @@ int cmd_timechart(int argc, const char **argv,
 			.fork		 = process_fork_event,
 			.exit		 = process_exit_event,
 			.sample		 = process_sample_event,
-			.ordered_samples = true,
+			.ordered_events	 = true,
 		},
 		.proc_num = 15,
 	};
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f954c26..c1d338e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2068,7 +2068,7 @@ static int trace__replay(struct trace *trace)
 	trace->tool.tracing_data = perf_event__process_tracing_data;
 	trace->tool.build_id	  = perf_event__process_build_id;
 
-	trace->tool.ordered_samples = true;
+	trace->tool.ordered_events = true;
 	trace->tool.ordering_requires_timestamps = true;
 
 	/* add tid to output */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index aec3dcd..315d522 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -76,9 +76,9 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		goto out;
 
 	session->repipe = repipe;
-	INIT_LIST_HEAD(&session->ordered_samples.samples);
-	INIT_LIST_HEAD(&session->ordered_samples.sample_cache);
-	INIT_LIST_HEAD(&session->ordered_samples.to_free);
+	INIT_LIST_HEAD(&session->ordered_events.samples);
+	INIT_LIST_HEAD(&session->ordered_events.sample_cache);
+	INIT_LIST_HEAD(&session->ordered_events.to_free);
 	machines__init(&session->machines);
 
 	if (file) {
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
@@ -446,7 +446,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
-struct sample_queue {
+struct ordered_event {
 	u64			timestamp;
 	u64			file_offset;
 	union perf_event	*event;
@@ -455,12 +455,12 @@ struct sample_queue {
 
 static void perf_session_free_sample_buffers(struct perf_session *session)
 {
-	struct ordered_samples *os = &session->ordered_samples;
+	struct ordered_events_queue *os = &session->ordered_events;
 
 	while (!list_empty(&os->to_free)) {
-		struct sample_queue *sq;
+		struct ordered_event *sq;
 
-		sq = list_entry(os->to_free.next, struct sample_queue, list);
+		sq = list_entry(os->to_free.next, struct ordered_event, list);
 		list_del(&sq->list);
 		free(sq);
 	}
@@ -472,12 +472,12 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static int flush_sample_queue(struct perf_session *s,
+static int ordered_events_flush(struct perf_session *s,
 		       struct perf_tool *tool)
 {
-	struct ordered_samples *os = &s->ordered_samples;
+	struct ordered_events_queue *os = &s->ordered_events;
 	struct list_head *head = &os->samples;
-	struct sample_queue *tmp, *iter;
+	struct ordered_event *tmp, *iter;
 	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
@@ -485,7 +485,7 @@ static int flush_sample_queue(struct perf_session *s,
 	struct ui_progress prog;
 	int ret;
 
-	if (!tool->ordered_samples || !limit)
+	if (!tool->ordered_events || !limit)
 		return 0;
 
 	if (show_progress)
@@ -521,7 +521,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_sample = NULL;
 	} else if (last_ts <= limit) {
 		os->last_sample =
-			list_entry(head->prev, struct sample_queue, list);
+			list_entry(head->prev, struct ordered_event, list);
 	}
 
 	return 0;
@@ -570,18 +570,18 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = flush_sample_queue(session, tool);
+	int ret = ordered_events_flush(session, tool);
 	if (!ret)
-		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
+		session->ordered_events.next_flush = session->ordered_events.max_timestamp;
 
 	return ret;
 }
 
 /* The queue is ordered by time */
-static void __queue_event(struct sample_queue *new, struct perf_session *s)
+static void __queue_event(struct ordered_event *new, struct perf_session *s)
 {
-	struct ordered_samples *os = &s->ordered_samples;
-	struct sample_queue *sample = os->last_sample;
+	struct ordered_events_queue *os = &s->ordered_events;
+	struct ordered_event *sample = os->last_sample;
 	u64 timestamp = new->timestamp;
 	struct list_head *p;
 
@@ -607,7 +607,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 				os->max_timestamp = timestamp;
 				return;
 			}
-			sample = list_entry(p, struct sample_queue, list);
+			sample = list_entry(p, struct ordered_event, list);
 		}
 		list_add_tail(&new->list, &sample->list);
 	} else {
@@ -617,32 +617,32 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 				list_add(&new->list, &os->samples);
 				return;
 			}
-			sample = list_entry(p, struct sample_queue, list);
+			sample = list_entry(p, struct ordered_event, list);
 		}
 		list_add(&new->list, &sample->list);
 	}
 }
 
-#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
+#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
-	struct ordered_samples *os = &s->ordered_samples;
+	struct ordered_events_queue *os = &s->ordered_events;
 	struct list_head *sc = &os->sample_cache;
 	u64 timestamp = sample->time;
-	struct sample_queue *new;
+	struct ordered_event *new;
 
 	if (!timestamp || timestamp == ~0ULL)
 		return -ETIME;
 
-	if (timestamp < s->ordered_samples.last_flush) {
+	if (timestamp < s->ordered_events.last_flush) {
 		printf("Warning: Timestamp below last timeslice flush\n");
 		return -EINVAL;
 	}
 
 	if (!list_empty(sc)) {
-		new = list_entry(sc->next, struct sample_queue, list);
+		new = list_entry(sc->next, struct ordered_event, list);
 		list_del(&new->list);
 	} else if (os->sample_buffer) {
 		new = os->sample_buffer + os->sample_buffer_idx;
@@ -1062,7 +1062,7 @@ static int perf_session__process_event(struct perf_session *session,
 	if (ret)
 		return ret;
 
-	if (tool->ordered_samples) {
+	if (tool->ordered_events) {
 		ret = perf_session_queue_event(session, event, &sample,
 					       file_offset);
 		if (ret != -ETIME)
@@ -1221,8 +1221,8 @@ more:
 		goto more;
 done:
 	/* do the final flush for ordered samples */
-	session->ordered_samples.next_flush = ULLONG_MAX;
-	err = flush_sample_queue(session, tool);
+	session->ordered_events.next_flush = ULLONG_MAX;
+	err = ordered_events_flush(session, tool);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
@@ -1357,8 +1357,8 @@ more:
 
 out:
 	/* do the final flush for ordered samples */
-	session->ordered_samples.next_flush = ULLONG_MAX;
-	err = flush_sample_queue(session, tool);
+	session->ordered_events.next_flush = ULLONG_MAX;
+	err = ordered_events_flush(session, tool);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3140f8a..91902ea 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -12,32 +12,32 @@
 #include <linux/rbtree.h>
 #include <linux/perf_event.h>
 
-struct sample_queue;
+struct ordered_event;
 struct ip_callchain;
 struct thread;
 
-struct ordered_samples {
+struct ordered_events_queue {
 	u64			last_flush;
 	u64			next_flush;
 	u64			max_timestamp;
 	struct list_head	samples;
 	struct list_head	sample_cache;
 	struct list_head	to_free;
-	struct sample_queue	*sample_buffer;
-	struct sample_queue	*last_sample;
+	struct ordered_event	*sample_buffer;
+	struct ordered_event	*last_sample;
 	int			sample_buffer_idx;
 	unsigned int		nr_samples;
 };
 
 struct perf_session {
-	struct perf_header	header;
-	struct machines		machines;
-	struct perf_evlist	*evlist;
-	struct trace_event	tevent;
-	struct events_stats	stats;
-	bool			repipe;
-	struct ordered_samples	ordered_samples;
-	struct perf_data_file	*file;
+	struct perf_header		header;
+	struct machines			machines;
+	struct perf_evlist		*evlist;
+	struct trace_event		tevent;
+	struct events_stats		stats;
+	bool				repipe;
+	struct ordered_events_queue	ordered_events;
+	struct perf_data_file		*file;
 };
 
 #define PRINT_IP_OPT_IP		(1<<0)
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
 
-- 
1.8.3.1

