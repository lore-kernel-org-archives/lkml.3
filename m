Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3LTTK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38563 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3LTTJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:35 -0500
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
Subject: [PATCH 17/35] perf tools: Rename 'perf_record_opts' to 'record_opts
Date: Fri, 20 Dec 2013 16:08:52 -0300
Message-Id: <1387566550-3524-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Reduce typing, functions use class__method convention, so unlikely to
clash with other libraries.

This actually was discussed in the "Link:" referenced message below.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20131112113427.GA4053@ghostprotocols.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c                  |  2 +-
 tools/perf/builtin-record.c               | 18 +++++++++---------
 tools/perf/builtin-top.c                  |  8 ++++----
 tools/perf/builtin-trace.c                |  2 +-
 tools/perf/perf.h                         |  2 +-
 tools/perf/tests/code-reading.c           |  2 +-
 tools/perf/tests/keep-tracking.c          |  2 +-
 tools/perf/tests/open-syscall-tp-fields.c |  2 +-
 tools/perf/tests/perf-record.c            |  2 +-
 tools/perf/tests/perf-time-to-tsc.c       |  2 +-
 tools/perf/util/callchain.h               |  2 +-
 tools/perf/util/evlist.h                  |  7 +++----
 tools/perf/util/evsel.c                   |  3 +--
 tools/perf/util/evsel.h                   |  4 ++--
 tools/perf/util/record.c                  |  9 ++++-----
 tools/perf/util/top.c                     |  2 +-
 tools/perf/util/top.h                     |  2 +-
 17 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 154b397a5d27..5a80da6ba413 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -89,7 +89,7 @@ struct exit_reasons_table {
 
 struct perf_kvm_stat {
 	struct perf_tool    tool;
-	struct perf_record_opts opts;
+	struct record_opts  opts;
 	struct perf_evlist  *evlist;
 	struct perf_session *session;
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f2624d43333e..6ec0cbc2a5d5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -64,7 +64,7 @@ static void __handle_on_exit_funcs(void)
 
 struct record {
 	struct perf_tool	tool;
-	struct perf_record_opts	opts;
+	struct record_opts	opts;
 	u64			bytes_written;
 	struct perf_data_file	file;
 	struct perf_evlist	*evlist;
@@ -178,7 +178,7 @@ static int record__open(struct record *rec)
 	struct perf_evsel *pos;
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
-	struct perf_record_opts *opts = &rec->opts;
+	struct record_opts *opts = &rec->opts;
 	int rc = 0;
 
 	perf_evlist__config(evlist, opts);
@@ -348,7 +348,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	const bool forks = argc > 0;
 	struct machine *machine;
 	struct perf_tool *tool = &rec->tool;
-	struct perf_record_opts *opts = &rec->opts;
+	struct record_opts *opts = &rec->opts;
 	struct perf_evlist *evsel_list = rec->evlist;
 	struct perf_data_file *file = &rec->file;
 	struct perf_session *session;
@@ -657,7 +657,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* HAVE_LIBUNWIND_SUPPORT */
 
-int record_parse_callchain(const char *arg, struct perf_record_opts *opts)
+int record_parse_callchain(const char *arg, struct record_opts *opts)
 {
 	char *tok, *name, *saveptr = NULL;
 	char *buf;
@@ -713,7 +713,7 @@ int record_parse_callchain(const char *arg, struct perf_record_opts *opts)
 	return ret;
 }
 
-static void callchain_debug(struct perf_record_opts *opts)
+static void callchain_debug(struct record_opts *opts)
 {
 	pr_debug("callchain: type %d\n", opts->call_graph);
 
@@ -726,7 +726,7 @@ int record_parse_callchain_opt(const struct option *opt,
 			       const char *arg,
 			       int unset)
 {
-	struct perf_record_opts *opts = opt->value;
+	struct record_opts *opts = opt->value;
 	int ret;
 
 	/* --no-call-graph */
@@ -747,7 +747,7 @@ int record_callchain_opt(const struct option *opt,
 			 const char *arg __maybe_unused,
 			 int unset __maybe_unused)
 {
-	struct perf_record_opts *opts = opt->value;
+	struct record_opts *opts = opt->value;
 
 	if (opts->call_graph == CALLCHAIN_NONE)
 		opts->call_graph = CALLCHAIN_FP;
@@ -796,7 +796,7 @@ const char record_callchain_help[] = CALLCHAIN_HELP "fp";
 /*
  * XXX Will stay a global variable till we fix builtin-script.c to stop messing
  * with it and switch to use the library functions in perf_evlist that came
- * from builtin-record.c, i.e. use perf_record_opts,
+ * from builtin-record.c, i.e. use record_opts,
  * perf_evlist__prepare_workload, etc instead of fork+exec'in 'perf record',
  * using pipes, etc.
  */
@@ -944,7 +944,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
-	if (perf_record_opts__config(&rec->opts)) {
+	if (record_opts__config(&rec->opts)) {
 		err = -EINVAL;
 		goto out_free_fd;
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2c6cb66f5358..172e91a9ce62 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -854,7 +854,7 @@ static int perf_top__start_counters(struct perf_top *top)
 	char msg[512];
 	struct perf_evsel *counter;
 	struct perf_evlist *evlist = top->evlist;
-	struct perf_record_opts *opts = &top->record_opts;
+	struct record_opts *opts = &top->record_opts;
 
 	perf_evlist__config(evlist, opts);
 
@@ -906,7 +906,7 @@ static int perf_top__setup_sample_type(struct perf_top *top __maybe_unused)
 
 static int __cmd_top(struct perf_top *top)
 {
-	struct perf_record_opts *opts = &top->record_opts;
+	struct record_opts *opts = &top->record_opts;
 	pthread_t thread;
 	int ret;
 
@@ -1028,7 +1028,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		.max_stack	     = PERF_MAX_STACK_DEPTH,
 		.sym_pcnt_filter     = 5,
 	};
-	struct perf_record_opts *opts = &top.record_opts;
+	struct record_opts *opts = &top.record_opts;
 	struct target *target = &opts->target;
 	const struct option options[] = {
 	OPT_CALLBACK('e', "event", &top.evlist, "event",
@@ -1179,7 +1179,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.delay_secs < 1)
 		top.delay_secs = 1;
 
-	if (perf_record_opts__config(opts)) {
+	if (record_opts__config(opts)) {
 		status = -EINVAL;
 		goto out_delete_maps;
 	}
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 56bbca5bc2dc..f64b5b0aa8b1 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1159,7 +1159,7 @@ struct trace {
 		int		max;
 		struct syscall  *table;
 	} syscalls;
-	struct perf_record_opts opts;
+	struct record_opts	opts;
 	struct machine		*host;
 	u64			base_time;
 	bool			full_time;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b23fed527514..b1cc84b01d5b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -247,7 +247,7 @@ enum perf_call_graph_mode {
 	CALLCHAIN_DWARF
 };
 
-struct perf_record_opts {
+struct record_opts {
 	struct target target;
 	int	     call_graph;
 	bool	     group;
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 85d4919dd623..4248d1e96848 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -391,7 +391,7 @@ static int do_test_code_reading(bool try_kcore)
 	struct machines machines;
 	struct machine *machine;
 	struct thread *thread;
-	struct perf_record_opts opts = {
+	struct record_opts opts = {
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index 376c35608534..27eb75142b88 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -51,7 +51,7 @@ static int find_comm(struct perf_evlist *evlist, const char *comm)
  */
 int test__keep_tracking(void)
 {
-	struct perf_record_opts opts = {
+	struct record_opts opts = {
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 41cc0badb74b..774620a5aecb 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -6,7 +6,7 @@
 
 int test__syscall_open_tp_fields(void)
 {
-	struct perf_record_opts opts = {
+	struct record_opts opts = {
 		.target = {
 			.uid = UINT_MAX,
 			.uses_mmap = true,
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 93a62b06c3af..eeba562920e9 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -34,7 +34,7 @@ realloc:
 
 int test__PERF_RECORD(void)
 {
-	struct perf_record_opts opts = {
+	struct record_opts opts = {
 		.target = {
 			.uid = UINT_MAX,
 			.uses_mmap = true,
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 4ca1b938f6a6..c6398b90e897 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -46,7 +46,7 @@ static u64 rdtsc(void)
  */
 int test__perf_time_to_tsc(void)
 {
-	struct perf_record_opts opts = {
+	struct record_opts opts = {
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 4f7f989876ec..08b25af9eea1 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -146,7 +146,7 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 
 struct option;
 
-int record_parse_callchain(const char *arg, struct perf_record_opts *opts);
+int record_parse_callchain(const char *arg, struct record_opts *opts);
 int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
 int record_callchain_opt(const struct option *opt, const char *arg, int unset);
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9f64ede3ecbd..2fe51958ed85 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -12,7 +12,7 @@
 struct pollfd;
 struct thread_map;
 struct cpu_map;
-struct perf_record_opts;
+struct record_opts;
 
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
@@ -97,9 +97,8 @@ void perf_evlist__close(struct perf_evlist *evlist);
 
 void perf_evlist__set_id_pos(struct perf_evlist *evlist);
 bool perf_can_sample_identifier(void);
-void perf_evlist__config(struct perf_evlist *evlist,
-			 struct perf_record_opts *opts);
-int perf_record_opts__config(struct perf_record_opts *opts);
+void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts);
+int record_opts__config(struct record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct target *target,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 01ff4cfde1f5..6874e0485693 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -528,8 +528,7 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
  *     enable/disable events specifically, as there's no
  *     initial traced exec call.
  */
-void perf_evsel__config(struct perf_evsel *evsel,
-			struct perf_record_opts *opts)
+void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 {
 	struct perf_evsel *leader = evsel->leader;
 	struct perf_event_attr *attr = &evsel->attr;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8120eeb86ac1..f1b325665aae 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -96,7 +96,7 @@ struct perf_evsel {
 struct cpu_map;
 struct thread_map;
 struct perf_evlist;
-struct perf_record_opts;
+struct record_opts;
 
 struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx);
 
@@ -120,7 +120,7 @@ void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 void perf_evsel__config(struct perf_evsel *evsel,
-			struct perf_record_opts *opts);
+			struct record_opts *opts);
 
 int __perf_evsel__sample_size(u64 sample_type);
 void perf_evsel__calc_id_pos(struct perf_evsel *evsel);
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index e5104538c354..104a47563d39 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -74,8 +74,7 @@ bool perf_can_sample_identifier(void)
 	return perf_probe_api(perf_probe_sample_identifier);
 }
 
-void perf_evlist__config(struct perf_evlist *evlist,
-			struct perf_record_opts *opts)
+void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 {
 	struct perf_evsel *evsel;
 	bool use_sample_identifier = false;
@@ -123,7 +122,7 @@ static int get_max_rate(unsigned int *rate)
 	return filename__read_int(path, (int *) rate);
 }
 
-static int perf_record_opts__config_freq(struct perf_record_opts *opts)
+static int record_opts__config_freq(struct record_opts *opts)
 {
 	bool user_freq = opts->user_freq != UINT_MAX;
 	unsigned int max_rate;
@@ -173,9 +172,9 @@ static int perf_record_opts__config_freq(struct perf_record_opts *opts)
 	return 0;
 }
 
-int perf_record_opts__config(struct perf_record_opts *opts)
+int record_opts__config(struct record_opts *opts)
 {
-	return perf_record_opts__config_freq(opts);
+	return record_opts__config_freq(opts);
 }
 
 bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index ce793c7dd23c..8e517def925b 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -26,7 +26,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	float samples_per_sec;
 	float ksamples_per_sec;
 	float esamples_percent;
-	struct perf_record_opts *opts = &top->record_opts;
+	struct record_opts *opts = &top->record_opts;
 	struct target *target = &opts->target;
 	size_t ret = 0;
 
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 88cfeaff600b..dab14d0ad3d0 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -14,7 +14,7 @@ struct perf_session;
 struct perf_top {
 	struct perf_tool   tool;
 	struct perf_evlist *evlist;
-	struct perf_record_opts record_opts;
+	struct record_opts record_opts;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
 	 * get out after decayed.
-- 
1.8.1.4

