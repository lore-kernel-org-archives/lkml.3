Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab3KMU7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:59:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54300 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3KMU6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:58:53 -0500
Date: Wed, 13 Nov 2013 21:58:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates
Message-ID: <20131113205848.GA32638@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: d969135aae1434547f41853f0e8eaa622e8b8816 Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

A number of fixes:

  * Fix segfault on perf trace -i perf.data, from Namhyung Kim.

  * Fix segfault with --no-mmap-pages, from David Ahern.

  * Don't force a refresh during progress update in the TUI, greatly reducing
    startup costs, fix from Patrick Palka.

  * Fix sw clock event period test wrt not checking if using > max_sample_freq.

  * Handle throttle events in 'object code reading' test, fix from Adrian Hunter.

  * Prevent condition that all sort keys are elided, fix from Namhyung Kim.

  * Round mmap pages to power 2, from David Ahern.

And a number of late arrival changes:

  * Add summary only option to 'perf trace', suppressing the decoding of
    events, from David Ahern

  * 'perf trace --summary' formatting simplifications, from Pekka Emberg.

  * Beautify fifth argument of mmap() as fd, in 'perf trace', from Namhyung Kim.

  * Add direct access to dynamic arrays in libtraceevent, from Steven Rostedt.

  * Synthesize non-exec MMAP records when --data used, allowing the resolution of
    data addresses to symbols (global variables, etc), by Arnaldo Carvalho de Melo.

  * Code cleanups by David Ahern and Adrian Hunter.

 Thanks,

	Ingo

------------------>
Adrian Hunter (3):
      perf record: Use correct return type for write()
      perf tests: Compensate lower sample freq with longer test loop
      perf tests: Handle throttle events in 'object code reading' test

Arnaldo Carvalho de Melo (7):
      perf evsel: Remove idx parm from constructor
      perf record: Synthesize non-exec MMAP records when --data used
      perf machine: Introduce synthesize_threads method out of open coded equivalent
      perf machine: Simplify synthesize_threads method
      perf tests: Check return of perf_evlist__open sw clock event period test
      perf tests: Use lower sample_freq in sw clock event period test
      perf target: Shorten perf_target__ to target__

David Ahern (5):
      perf record: Move existing write_output into helper function
      perf trace: Add summary only option
      perf record: Fix segfault with --no-mmap-pages
      perf evlist: Round mmap pages to power 2 - v2
      perf evlist: Refactor mmap_pages parsing

Namhyung Kim (4):
      perf tools: Prevent condition that all sort keys are elided
      perf trace: Beautify fifth argument of mmap() as fd
      perf trace: Separate tp syscall field caching into init routine to be reused
      perf trace: Fix segfault on perf trace -i perf.data

Patrick Palka (1):
      perf ui tui progress: Don't force a refresh during progress update

Pekka Enberg (2):
      perf trace: Change syscall summary duration order
      perf trace: Simplify '--summary' output

Steven Rostedt (1):
      tools lib traceevent: Add direct access to dynamic arrays


 tools/lib/traceevent/event-parse.c        |  13 +++
 tools/perf/Documentation/perf-trace.txt   |  10 ++-
 tools/perf/builtin-kvm.c                  |  20 ++---
 tools/perf/builtin-record.c               |  35 ++++----
 tools/perf/builtin-stat.c                 |  21 +++--
 tools/perf/builtin-top.c                  |  24 ++---
 tools/perf/builtin-trace.c                | 143 +++++++++++++++++-------------
 tools/perf/perf.h                         |   2 +-
 tools/perf/tests/code-reading.c           |  17 +++-
 tools/perf/tests/evsel-tp-sched.c         |   4 +-
 tools/perf/tests/mmap-basic.c             |   2 +-
 tools/perf/tests/open-syscall-all-cpus.c  |   2 +-
 tools/perf/tests/open-syscall-tp-fields.c |   2 +-
 tools/perf/tests/open-syscall.c           |   2 +-
 tools/perf/tests/sw-clock.c               |  15 +++-
 tools/perf/tests/task-exit.c              |   2 +-
 tools/perf/ui/tui/progress.c              |   3 +-
 tools/perf/util/event.c                   |  50 ++++++-----
 tools/perf/util/event.h                   |   4 +-
 tools/perf/util/evlist.c                  |  73 ++++++++-------
 tools/perf/util/evlist.h                  |   5 +-
 tools/perf/util/evsel.c                   |  13 ++-
 tools/perf/util/evsel.h                   |  18 +++-
 tools/perf/util/header.c                  |   4 +-
 tools/perf/util/machine.c                 |  12 +++
 tools/perf/util/machine.h                 |  12 +++
 tools/perf/util/parse-events.c            |   6 +-
 tools/perf/util/sort.c                    |  13 +++
 tools/perf/util/target.c                  |  54 ++++++-----
 tools/perf/util/target.h                  |  44 +++++----
 tools/perf/util/top.c                     |   2 +-
 31 files changed, 363 insertions(+), 264 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8f450ad..0362d57 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3435,6 +3435,19 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			goto out_warning_op;
 		}
 		break;
+	case PRINT_DYNAMIC_ARRAY:
+		/* Without [], we pass the address to the dynamic data */
+		offset = pevent_read_number(pevent,
+					    data + arg->dynarray.field->offset,
+					    arg->dynarray.field->size);
+		/*
+		 * The actual length of the dynamic array is stored
+		 * in the top half of the field, and the offset
+		 * is in the bottom half of the 32 bit field.
+		 */
+		offset &= 0xffff;
+		val = (unsigned long long)(data + offset);
+		break;
 	default: /* not sure what to do there */
 		return 0;
 	}
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 7b0497f..fae38d9 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -93,9 +93,15 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --comm::
         Show process COMM right beside its ID, on by default, disable with --no-comm.
 
+-s::
 --summary::
-	Show a summary of syscalls by thread with min, max, and average times (in
-    msec) and relative stddev.
+	Show only a summary of syscalls by thread with min, max, and average times
+    (in msec) and relative stddev.
+
+-S::
+--with-summary::
+	Show all syscalls followed by a summary by thread with min, max, and
+    average times (in msec) and relative stddev.
 
 --tool_stats::
 	Show tool stats such as number of times fd->pathname was discovered thru
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index cd9f920..f8bf5f2 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1510,13 +1510,13 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	/*
 	 * target related setups
 	 */
-	err = perf_target__validate(&kvm->opts.target);
+	err = target__validate(&kvm->opts.target);
 	if (err) {
-		perf_target__strerror(&kvm->opts.target, err, errbuf, BUFSIZ);
+		target__strerror(&kvm->opts.target, err, errbuf, BUFSIZ);
 		ui__warning("%s", errbuf);
 	}
 
-	if (perf_target__none(&kvm->opts.target))
+	if (target__none(&kvm->opts.target))
 		kvm->opts.target.system_wide = true;
 
 
@@ -1544,18 +1544,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	}
 	kvm->session->evlist = kvm->evlist;
 	perf_session__set_id_hdr_size(kvm->session);
-
-
-	if (perf_target__has_task(&kvm->opts.target))
-		perf_event__synthesize_thread_map(&kvm->tool,
-						  kvm->evlist->threads,
-						  perf_event__process,
-						  &kvm->session->machines.host);
-	else
-		perf_event__synthesize_threads(&kvm->tool, perf_event__process,
-					       &kvm->session->machines.host);
-
-
+	machine__synthesize_threads(&kvm->session->machines.host, &kvm->opts.target,
+				    kvm->evlist->threads, false);
 	err = kvm_live_open_events(kvm);
 	if (err)
 		goto out;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 15280b5..4d644fe 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,12 +76,12 @@ struct perf_record {
 	long			samples;
 };
 
-static int write_output(struct perf_record *rec, void *buf, size_t size)
+static int do_write_output(struct perf_record *rec, void *buf, size_t size)
 {
 	struct perf_data_file *file = &rec->file;
 
 	while (size) {
-		int ret = write(file->fd, buf, size);
+		ssize_t ret = write(file->fd, buf, size);
 
 		if (ret < 0) {
 			pr_err("failed to write perf data, error: %m\n");
@@ -97,6 +97,11 @@ static int write_output(struct perf_record *rec, void *buf, size_t size)
 	return 0;
 }
 
+static int write_output(struct perf_record *rec, void *buf, size_t size)
+{
+	return do_write_output(rec, buf, size);
+}
+
 static int process_synthesized_event(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_sample *sample __maybe_unused,
@@ -480,16 +485,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 					 perf_event__synthesize_guest_os, tool);
 	}
 
-	if (perf_target__has_task(&opts->target))
-		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
-						  process_synthesized_event,
-						  machine);
-	else if (perf_target__has_cpu(&opts->target))
-		err = perf_event__synthesize_threads(tool, process_synthesized_event,
-					       machine);
-	else /* command specified */
-		err = 0;
-
+	err = __machine__synthesize_threads(machine, tool, &opts->target, evsel_list->threads,
+					    process_synthesized_event, opts->sample_address);
 	if (err != 0)
 		goto out_delete_session;
 
@@ -509,7 +506,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	 * (apart from group members) have enable_on_exec=1 set,
 	 * so don't spoil it by prematurely enabling them.
 	 */
-	if (!perf_target__none(&opts->target))
+	if (!target__none(&opts->target))
 		perf_evlist__enable(evsel_list);
 
 	/*
@@ -538,7 +535,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		 * die with the process and we wait for that. Thus no need to
 		 * disable events in this case.
 		 */
-		if (done && !disabled && !perf_target__none(&opts->target)) {
+		if (done && !disabled && !target__none(&opts->target)) {
 			perf_evlist__disable(evsel_list);
 			disabled = true;
 		}
@@ -909,7 +906,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && perf_target__none(&rec->opts.target))
+	if (!argc && target__none(&rec->opts.target))
 		usage_with_options(record_usage, record_options);
 
 	if (nr_cgroups && !rec->opts.target.system_wide) {
@@ -939,17 +936,17 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		goto out_symbol_exit;
 	}
 
-	err = perf_target__validate(&rec->opts.target);
+	err = target__validate(&rec->opts.target);
 	if (err) {
-		perf_target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
+		target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
 		ui__warning("%s", errbuf);
 	}
 
-	err = perf_target__parse_uid(&rec->opts.target);
+	err = target__parse_uid(&rec->opts.target);
 	if (err) {
 		int saved_errno = errno;
 
-		perf_target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
+		target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
 		ui__error("%s", errbuf);
 
 		err = -saved_errno;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0fc1c94..ee0d565 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -108,7 +108,7 @@ enum {
 
 static struct perf_evlist	*evsel_list;
 
-static struct perf_target	target = {
+static struct target target = {
 	.uid	= UINT_MAX,
 };
 
@@ -294,11 +294,10 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 
 	attr->inherit = !no_inherit;
 
-	if (perf_target__has_cpu(&target))
+	if (target__has_cpu(&target))
 		return perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
 
-	if (!perf_target__has_task(&target) &&
-	    perf_evsel__is_group_leader(evsel)) {
+	if (!target__has_task(&target) && perf_evsel__is_group_leader(evsel)) {
 		attr->disabled = 1;
 		if (!initial_delay)
 			attr->enable_on_exec = 1;
@@ -1236,7 +1235,7 @@ static void print_stat(int argc, const char **argv)
 			fprintf(output, "\'system wide");
 		else if (target.cpu_list)
 			fprintf(output, "\'CPU(s) %s", target.cpu_list);
-		else if (!perf_target__has_task(&target)) {
+		else if (!target__has_task(&target)) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
@@ -1667,7 +1666,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
 		big_num = false;
 
-	if (!argc && perf_target__none(&target))
+	if (!argc && target__none(&target))
 		usage_with_options(stat_usage, options);
 
 	if (run_count < 0) {
@@ -1680,8 +1679,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((aggr_mode != AGGR_GLOBAL || nr_cgroups)
-	     && !perf_target__has_cpu(&target)) {
+	if ((aggr_mode != AGGR_GLOBAL || nr_cgroups) &&
+	    !target__has_cpu(&target)) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
@@ -1694,14 +1693,14 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (add_default_attributes())
 		goto out;
 
-	perf_target__validate(&target);
+	target__validate(&target);
 
 	if (perf_evlist__create_maps(evsel_list, &target) < 0) {
-		if (perf_target__has_task(&target)) {
+		if (target__has_task(&target)) {
 			pr_err("Problems finding threads of monitor\n");
 			parse_options_usage(stat_usage, options, "p", 1);
 			parse_options_usage(NULL, options, "t", 1);
-		} else if (perf_target__has_cpu(&target)) {
+		} else if (target__has_cpu(&target)) {
 			perror("failed to parse CPUs map");
 			parse_options_usage(stat_usage, options, "C", 1);
 			parse_options_usage(NULL, options, "a", 1);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9acca88..b8f8e29 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -950,14 +950,8 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (perf_target__has_task(&opts->target))
-		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
-						  perf_event__process,
-						  &top->session->machines.host);
-	else
-		perf_event__synthesize_threads(&top->tool, perf_event__process,
-					       &top->session->machines.host);
-
+	machine__synthesize_threads(&top->session->machines.host, &opts->target,
+				    top->evlist->threads, false);
 	ret = perf_top__start_counters(top);
 	if (ret)
 		goto out_delete;
@@ -973,7 +967,7 @@ static int __cmd_top(struct perf_top *top)
 	 * XXX 'top' still doesn't start workloads like record, trace, but should,
 	 * so leave the check here.
 	 */
-        if (!perf_target__none(&opts->target))
+        if (!target__none(&opts->target))
                 perf_evlist__enable(top->evlist);
 
 	/* Wait for a minimal set of events before starting the snapshot */
@@ -1059,7 +1053,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		.sym_pcnt_filter     = 5,
 	};
 	struct perf_record_opts *opts = &top.record_opts;
-	struct perf_target *target = &opts->target;
+	struct target *target = &opts->target;
 	const struct option options[] = {
 	OPT_CALLBACK('e', "event", &top.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
@@ -1175,24 +1169,24 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_browser(false);
 
-	status = perf_target__validate(target);
+	status = target__validate(target);
 	if (status) {
-		perf_target__strerror(target, status, errbuf, BUFSIZ);
+		target__strerror(target, status, errbuf, BUFSIZ);
 		ui__warning("%s", errbuf);
 	}
 
-	status = perf_target__parse_uid(target);
+	status = target__parse_uid(target);
 	if (status) {
 		int saved_errno = errno;
 
-		perf_target__strerror(target, status, errbuf, BUFSIZ);
+		target__strerror(target, status, errbuf, BUFSIZ);
 		ui__error("%s", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;
 	}
 
-	if (perf_target__none(target))
+	if (target__none(target))
 		target->system_wide = true;
 
 	if (perf_evlist__create_maps(top.evlist, target) < 0)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 329b783..6b230af 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -149,21 +149,32 @@ static void perf_evsel__delete_priv(struct perf_evsel *evsel)
 	perf_evsel__delete(evsel);
 }
 
-static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction,
-						    void *handler, int idx)
+static int perf_evsel__init_syscall_tp(struct perf_evsel *evsel, void *handler)
 {
-	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction, idx);
-
-	if (evsel) {
-		evsel->priv = malloc(sizeof(struct syscall_tp));
-
-		if (evsel->priv == NULL)
-			goto out_delete;
-
+	evsel->priv = malloc(sizeof(struct syscall_tp));
+	if (evsel->priv != NULL) {
 		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
 			goto out_delete;
 
 		evsel->handler = handler;
+		return 0;
+	}
+
+	return -ENOMEM;
+
+out_delete:
+	free(evsel->priv);
+	evsel->priv = NULL;
+	return -ENOENT;
+}
+
+static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction, void *handler)
+{
+	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
+
+	if (evsel) {
+		if (perf_evsel__init_syscall_tp(evsel, handler))
+			goto out_delete;
 	}
 
 	return evsel;
@@ -186,17 +197,16 @@ static int perf_evlist__add_syscall_newtp(struct perf_evlist *evlist,
 					  void *sys_exit_handler)
 {
 	int ret = -1;
-	int idx = evlist->nr_entries;
 	struct perf_evsel *sys_enter, *sys_exit;
 
-	sys_enter = perf_evsel__syscall_newtp("sys_enter", sys_enter_handler, idx++);
+	sys_enter = perf_evsel__syscall_newtp("sys_enter", sys_enter_handler);
 	if (sys_enter == NULL)
 		goto out;
 
 	if (perf_evsel__init_sc_tp_ptr_field(sys_enter, args))
 		goto out_delete_sys_enter;
 
-	sys_exit = perf_evsel__syscall_newtp("sys_exit", sys_exit_handler, idx++);
+	sys_exit = perf_evsel__syscall_newtp("sys_exit", sys_exit_handler);
 	if (sys_exit == NULL)
 		goto out_delete_sys_enter;
 
@@ -953,7 +963,8 @@ static struct syscall_fmt {
 	{ .name	    = "mmap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
 			     [2] = SCA_MMAP_PROT, /* prot */
-			     [3] = SCA_MMAP_FLAGS, /* flags */ }, },
+			     [3] = SCA_MMAP_FLAGS, /* flags */
+			     [4] = SCA_FD, 	  /* fd */ }, },
 	{ .name	    = "mprotect",   .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* start */
 			     [2] = SCA_MMAP_PROT, /* prot */ }, },
@@ -1157,6 +1168,7 @@ struct trace {
 	bool			sched;
 	bool			multiple_threads;
 	bool			summary;
+	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
 	double			duration_filter;
@@ -1342,15 +1354,8 @@ static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 	if (trace->host == NULL)
 		return -ENOMEM;
 
-	if (perf_target__has_task(&trace->opts.target)) {
-		err = perf_event__synthesize_thread_map(&trace->tool, evlist->threads,
-							trace__tool_process,
-							trace->host);
-	} else {
-		err = perf_event__synthesize_threads(&trace->tool, trace__tool_process,
-						     trace->host);
-	}
-
+	err = __machine__synthesize_threads(trace->host, &trace->tool, &trace->opts.target,
+					    evlist->threads, trace__tool_process, false);
 	if (err)
 		symbol__exit();
 
@@ -1607,7 +1612,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 					   args, trace, thread);
 
 	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
-		if (!trace->duration_filter) {
+		if (!trace->duration_filter && !trace->summary_only) {
 			trace__fprintf_entry_head(trace, thread, 1, sample->time, trace->output);
 			fprintf(trace->output, "%-70s\n", ttrace->entry_str);
 		}
@@ -1660,6 +1665,9 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	} else if (trace->duration_filter)
 		goto out;
 
+	if (trace->summary_only)
+		goto out;
+
 	trace__fprintf_entry_head(trace, thread, duration, sample->time, trace->output);
 
 	if (ttrace->entry_pending) {
@@ -1762,16 +1770,6 @@ static int trace__process_sample(struct perf_tool *tool,
 	return err;
 }
 
-static bool
-perf_session__has_tp(struct perf_session *session, const char *name)
-{
-	struct perf_evsel *evsel;
-
-	evsel = perf_evlist__find_tracepoint_by_name(session->evlist, name);
-
-	return evsel != NULL;
-}
-
 static int parse_target_str(struct trace *trace)
 {
 	if (trace->opts.target.pid) {
@@ -1824,8 +1822,7 @@ static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
 
 static void perf_evlist__add_vfs_getname(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = perf_evsel__newtp("probe", "vfs_getname",
-						     evlist->nr_entries);
+	struct perf_evsel *evsel = perf_evsel__newtp("probe", "vfs_getname");
 	if (evsel == NULL)
 		return;
 
@@ -2009,8 +2006,6 @@ out_error:
 static int trace__replay(struct trace *trace)
 {
 	const struct perf_evsel_str_handler handlers[] = {
-		{ "raw_syscalls:sys_enter",  trace__sys_enter, },
-		{ "raw_syscalls:sys_exit",   trace__sys_exit, },
 		{ "probe:vfs_getname",	     trace__vfs_getname, },
 	};
 	struct perf_data_file file = {
@@ -2018,6 +2013,7 @@ static int trace__replay(struct trace *trace)
 		.mode  = PERF_DATA_MODE_READ,
 	};
 	struct perf_session *session;
+	struct perf_evsel *evsel;
 	int err = -1;
 
 	trace->tool.sample	  = trace__process_sample;
@@ -2049,13 +2045,29 @@ static int trace__replay(struct trace *trace)
 	if (err)
 		goto out;
 
-	if (!perf_session__has_tp(session, "raw_syscalls:sys_enter")) {
-		pr_err("Data file does not have raw_syscalls:sys_enter events\n");
+	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
+						     "raw_syscalls:sys_enter");
+	if (evsel == NULL) {
+		pr_err("Data file does not have raw_syscalls:sys_enter event\n");
 		goto out;
 	}
 
-	if (!perf_session__has_tp(session, "raw_syscalls:sys_exit")) {
-		pr_err("Data file does not have raw_syscalls:sys_exit events\n");
+	if (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
+	    perf_evsel__init_sc_tp_ptr_field(evsel, args)) {
+		pr_err("Error during initialize raw_syscalls:sys_enter event\n");
+		goto out;
+	}
+
+	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
+						     "raw_syscalls:sys_exit");
+	if (evsel == NULL) {
+		pr_err("Data file does not have raw_syscalls:sys_exit event\n");
+		goto out;
+	}
+
+	if (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
+	    perf_evsel__init_sc_tp_uint_field(evsel, ret)) {
+		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
 		goto out;
 	}
 
@@ -2082,12 +2094,7 @@ static size_t trace__fprintf_threads_header(FILE *fp)
 {
 	size_t printed;
 
-	printed  = fprintf(fp, "\n _____________________________________________________________________________\n");
-	printed += fprintf(fp, " __)    Summary of events    (__\n\n");
-	printed += fprintf(fp, "              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]\n");
-	printed += fprintf(fp, "                                  syscall  count    min     max    avg  stddev\n");
-	printed += fprintf(fp, "                                                   msec    msec   msec     %%\n");
-	printed += fprintf(fp, " _____________________________________________________________________________\n\n");
+	printed  = fprintf(fp, "\n Summary of events:\n\n");
 
 	return printed;
 }
@@ -2105,6 +2112,10 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 
 	printed += fprintf(fp, "\n");
 
+	printed += fprintf(fp, "                                                    msec/call\n");
+	printed += fprintf(fp, "   syscall            calls      min      avg      max stddev\n");
+	printed += fprintf(fp, "   --------------- -------- -------- -------- -------- ------\n");
+
 	/* each int_node is a syscall */
 	while (inode) {
 		stats = inode->priv;
@@ -2119,10 +2130,10 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 			avg /= NSEC_PER_MSEC;
 
 			sc = &trace->syscalls.table[inode->i];
-			printed += fprintf(fp, "%24s  %14s : ", "", sc->name);
-			printed += fprintf(fp, "%5" PRIu64 "  %8.3f  %8.3f",
-					   n, min, max);
-			printed += fprintf(fp, "  %8.3f  %6.2f\n", avg, pct);
+			printed += fprintf(fp, "   %-15s", sc->name);
+			printed += fprintf(fp, " %8" PRIu64 " %8.3f %8.3f",
+					   n, min, avg);
+			printed += fprintf(fp, " %8.3f %6.2f\n", max, pct);
 		}
 
 		inode = intlist__next(inode);
@@ -2163,10 +2174,10 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	printed += color_fprintf(fp, color, "%20s", thread__comm_str(thread));
-	printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
-	printed += color_fprintf(fp, color, "%5.1f%%", ratio);
-	printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
+	printed += color_fprintf(fp, color, " %s (%d), ", thread__comm_str(thread), thread->tid);
+	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
+	printed += color_fprintf(fp, color, "%.1f%%", ratio);
+	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
 	data->printed += printed;
@@ -2275,8 +2286,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_BOOLEAN('T', "time", &trace.full_time,
 		    "Show full timestamp, not time relative to first start"),
-	OPT_BOOLEAN(0, "summary", &trace.summary,
-		    "Show syscall summary with statistics"),
+	OPT_BOOLEAN('s', "summary", &trace.summary_only,
+		    "Show only syscall summary with statistics"),
+	OPT_BOOLEAN('S', "with-summary", &trace.summary,
+		    "Show all syscalls and summary with statistics"),
 	OPT_END()
 	};
 	int err;
@@ -2287,6 +2300,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 
+	/* summary_only implies summary option, but don't overwrite summary if set */
+	if (trace.summary_only)
+		trace.summary = trace.summary_only;
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
@@ -2310,21 +2327,21 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 	}
 
-	err = perf_target__validate(&trace.opts.target);
+	err = target__validate(&trace.opts.target);
 	if (err) {
-		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
+		target__strerror(&trace.opts.target, err, bf, sizeof(bf));
 		fprintf(trace.output, "%s", bf);
 		goto out_close;
 	}
 
-	err = perf_target__parse_uid(&trace.opts.target);
+	err = target__parse_uid(&trace.opts.target);
 	if (err) {
-		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
+		target__strerror(&trace.opts.target, err, bf, sizeof(bf));
 		fprintf(trace.output, "%s", bf);
 		goto out_close;
 	}
 
-	if (!argc && perf_target__none(&trace.opts.target))
+	if (!argc && target__none(&trace.opts.target))
 		trace.opts.target.system_wide = true;
 
 	if (input_name)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 6a587e84..b079304 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -248,7 +248,7 @@ enum perf_call_graph_mode {
 };
 
 struct perf_record_opts {
-	struct perf_target target;
+	struct target target;
 	int	     call_graph;
 	bool	     group;
 	bool	     inherit_stat;
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 49ccc3b..85d4919 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -275,8 +275,19 @@ static int process_event(struct machine *machine, struct perf_evlist *evlist,
 	if (event->header.type == PERF_RECORD_SAMPLE)
 		return process_sample_event(machine, evlist, event, state);
 
-	if (event->header.type < PERF_RECORD_MAX)
-		return machine__process_event(machine, event, NULL);
+	if (event->header.type == PERF_RECORD_THROTTLE ||
+	    event->header.type == PERF_RECORD_UNTHROTTLE)
+		return 0;
+
+	if (event->header.type < PERF_RECORD_MAX) {
+		int ret;
+
+		ret = machine__process_event(machine, event, NULL);
+		if (ret < 0)
+			pr_debug("machine__process_event failed, event type %u\n",
+				 event->header.type);
+		return ret;
+	}
 
 	return 0;
 }
@@ -441,7 +452,7 @@ static int do_test_code_reading(bool try_kcore)
 	}
 
 	ret = perf_event__synthesize_thread_map(NULL, threads,
-						perf_event__process, machine);
+						perf_event__process, machine, false);
 	if (ret < 0) {
 		pr_debug("perf_event__synthesize_thread_map failed\n");
 		goto out_err;
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index 9b98c15..4774f7f 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -32,7 +32,7 @@ static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 
 int test__perf_evsel__tp_sched_test(void)
 {
-	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
+	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch");
 	int ret = 0;
 
 	if (evsel == NULL) {
@@ -63,7 +63,7 @@ int test__perf_evsel__tp_sched_test(void)
 
 	perf_evsel__delete(evsel);
 
-	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
+	evsel = perf_evsel__newtp("sched", "sched_wakeup");
 
 	if (perf_evsel__test_field(evsel, "comm", 16, true))
 		ret = -1;
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index a7232c2..d64ab79 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -65,7 +65,7 @@ int test__basic_mmap(void)
 		char name[64];
 
 		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
-		evsels[i] = perf_evsel__newtp("syscalls", name, i);
+		evsels[i] = perf_evsel__newtp("syscalls", name);
 		if (evsels[i] == NULL) {
 			pr_debug("perf_evsel__new\n");
 			goto out_free_evlist;
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index b0657a9..5fecdbd 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -26,7 +26,7 @@ int test__open_syscall_event_on_all_cpus(void)
 
 	CPU_ZERO(&cpu_set);
 
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
 		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
 		goto out_thread_map_delete;
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 524b221..41cc0ba 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -27,7 +27,7 @@ int test__syscall_open_tp_fields(void)
 		goto out;
 	}
 
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
 		pr_debug("%s: perf_evsel__newtp\n", __func__);
 		goto out_delete_evlist;
diff --git a/tools/perf/tests/open-syscall.c b/tools/perf/tests/open-syscall.c
index befc067..c1dc7d2 100644
--- a/tools/perf/tests/open-syscall.c
+++ b/tools/perf/tests/open-syscall.c
@@ -15,7 +15,7 @@ int test__open_syscall_event(void)
 		return -1;
 	}
 
-	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open");
 	if (evsel == NULL) {
 		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
 		goto out_thread_map_delete;
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 6e2b44e..6664a7c 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -9,7 +9,7 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 
-#define NR_LOOPS  1000000
+#define NR_LOOPS  10000000
 
 /*
  * This test will open software clock events (cpu-clock, task-clock)
@@ -34,7 +34,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		.freq = 1,
 	};
 
-	attr.sample_freq = 10000;
+	attr.sample_freq = 500;
 
 	evlist = perf_evlist__new();
 	if (evlist == NULL) {
@@ -42,7 +42,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		return -1;
 	}
 
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__new(&attr);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
 		goto out_free_evlist;
@@ -57,7 +57,14 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		goto out_delete_maps;
 	}
 
-	perf_evlist__open(evlist);
+	if (perf_evlist__open(evlist)) {
+		const char *knob = "/proc/sys/kernel/perf_event_max_sample_rate";
+
+		err = -errno;
+		pr_debug("Couldn't open evlist: %s\nHint: check %s, using %" PRIu64 " in this test.\n",
+			 strerror(errno), knob, (u64)attr.sample_freq);
+		goto out_delete_maps;
+	}
 
 	err = perf_evlist__mmap(evlist, 128, true);
 	if (err < 0) {
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index c33d95f..d09ab57 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -28,7 +28,7 @@ int test__task_exit(void)
 	union perf_event *event;
 	struct perf_evsel *evsel;
 	struct perf_evlist *evlist;
-	struct perf_target target = {
+	struct target target = {
 		.uid		= UINT_MAX,
 		.uses_mmap	= true,
 	};
diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
index 3e2d936..c61d14b 100644
--- a/tools/perf/ui/tui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -18,13 +18,14 @@ static void tui_progress__update(struct ui_progress *p)
 	if (p->total == 0)
 		return;
 
-	ui__refresh_dimensions(true);
+	ui__refresh_dimensions(false);
 	pthread_mutex_lock(&ui__lock);
 	y = SLtt_Screen_Rows / 2 - 2;
 	SLsmg_set_color(0);
 	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
 	SLsmg_gotorc(y++, 1);
 	SLsmg_write_string((char *)p->title);
+	SLsmg_fill_region(y, 1, 1, SLtt_Screen_Cols - 2, ' ');
 	SLsmg_set_color(HE_COLORSET_SELECTED);
 	bar = ((SLtt_Screen_Cols - 2) * p->curr) / p->total;
 	SLsmg_fill_region(y, 1, 1, bar, ' ');
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ec9ae11..6e3a846 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -170,7 +170,8 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 					      union perf_event *event,
 					      pid_t pid, pid_t tgid,
 					      perf_event__handler_t process,
-					      struct machine *machine)
+					      struct machine *machine,
+					      bool mmap_data)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -188,10 +189,6 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	}
 
 	event->header.type = PERF_RECORD_MMAP;
-	/*
-	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
-	 */
-	event->header.misc = PERF_RECORD_MISC_USER;
 
 	while (1) {
 		char bf[BUFSIZ];
@@ -215,9 +212,17 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 
 		if (n != 5)
 			continue;
+		/*
+		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
+		 */
+		event->header.misc = PERF_RECORD_MISC_USER;
 
-		if (prot[2] != 'x')
-			continue;
+		if (prot[2] != 'x') {
+			if (!mmap_data || prot[0] != 'r')
+				continue;
+
+			event->header.misc |= PERF_RECORD_MISC_MMAP_DATA;
+		}
 
 		if (!strcmp(execname, ""))
 			strcpy(execname, anonstr);
@@ -304,20 +309,21 @@ static int __event__synthesize_thread(union perf_event *comm_event,
 				      pid_t pid, int full,
 					  perf_event__handler_t process,
 				      struct perf_tool *tool,
-				      struct machine *machine)
+				      struct machine *machine, bool mmap_data)
 {
 	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, full,
 						 process, machine);
 	if (tgid == -1)
 		return -1;
 	return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
-						  process, machine);
+						  process, machine, mmap_data);
 }
 
 int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
-				      struct machine *machine)
+				      struct machine *machine,
+				      bool mmap_data)
 {
 	union perf_event *comm_event, *mmap_event;
 	int err = -1, thread, j;
@@ -334,7 +340,8 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 	for (thread = 0; thread < threads->nr; ++thread) {
 		if (__event__synthesize_thread(comm_event, mmap_event,
 					       threads->map[thread], 0,
-					       process, tool, machine)) {
+					       process, tool, machine,
+					       mmap_data)) {
 			err = -1;
 			break;
 		}
@@ -356,10 +363,10 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 
 			/* if not, generate events for it */
 			if (need_leader &&
-			    __event__synthesize_thread(comm_event,
-						      mmap_event,
-						      comm_event->comm.pid, 0,
-						      process, tool, machine)) {
+			    __event__synthesize_thread(comm_event, mmap_event,
+						       comm_event->comm.pid, 0,
+						       process, tool, machine,
+						       mmap_data)) {
 				err = -1;
 				break;
 			}
@@ -374,7 +381,7 @@ out:
 
 int perf_event__synthesize_threads(struct perf_tool *tool,
 				   perf_event__handler_t process,
-				   struct machine *machine)
+				   struct machine *machine, bool mmap_data)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
@@ -404,7 +411,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
  		 * one thread couldn't be synthesized.
  		 */
 		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
-					   process, tool, machine);
+					   process, tool, machine, mmap_data);
 	}
 
 	err = 0;
@@ -528,19 +535,22 @@ int perf_event__process_lost(struct perf_tool *tool __maybe_unused,
 
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 {
-	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %s\n",
+	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %c %s\n",
 		       event->mmap.pid, event->mmap.tid, event->mmap.start,
-		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
+		       event->mmap.len, event->mmap.pgoff,
+		       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
+		       event->mmap.filename);
 }
 
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
-			   " %02x:%02x %"PRIu64" %"PRIu64"]: %s\n",
+			   " %02x:%02x %"PRIu64" %"PRIu64"]: %c %s\n",
 		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
 		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
 		       event->mmap2.min, event->mmap2.ino,
 		       event->mmap2.ino_generation,
+		       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
 		       event->mmap2.filename);
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index f8d70f3..30fec99 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -208,10 +208,10 @@ typedef int (*perf_event__handler_t)(struct perf_tool *tool,
 int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
-				      struct machine *machine);
+				      struct machine *machine, bool mmap_data);
 int perf_event__synthesize_threads(struct perf_tool *tool,
 				   perf_event__handler_t process,
-				   struct machine *machine);
+				   struct machine *machine, bool mmap_data);
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
 				       struct machine *machine,
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b939221..dc6fa3f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -117,6 +117,8 @@ void perf_evlist__delete(struct perf_evlist *evlist)
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 {
 	list_add_tail(&entry->node, &evlist->entries);
+	entry->idx = evlist->nr_entries;
+
 	if (!evlist->nr_entries++)
 		perf_evlist__set_id_pos(evlist);
 }
@@ -165,7 +167,7 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 
 	event_attr_init(&attr);
 
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__new(&attr);
 	if (evsel == NULL)
 		goto error;
 
@@ -190,7 +192,7 @@ static int perf_evlist__add_attrs(struct perf_evlist *evlist,
 	size_t i;
 
 	for (i = 0; i < nr_attrs; i++) {
-		evsel = perf_evsel__new(attrs + i, evlist->nr_entries + i);
+		evsel = perf_evsel__new_idx(attrs + i, evlist->nr_entries + i);
 		if (evsel == NULL)
 			goto out_delete_partial_list;
 		list_add_tail(&evsel->node, &head);
@@ -249,9 +251,8 @@ perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
 int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel = perf_evsel__newtp(sys, name);
 
-	evsel = perf_evsel__newtp(sys, name, evlist->nr_entries);
 	if (evsel == NULL)
 		return -1;
 
@@ -704,12 +705,10 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 	return (pages + 1) * page_size;
 }
 
-int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
-				  int unset __maybe_unused)
+static long parse_pages_arg(const char *str, unsigned long min,
+			    unsigned long max)
 {
-	unsigned int *mmap_pages = opt->value;
 	unsigned long pages, val;
-	size_t size;
 	static struct parse_tag tags[] = {
 		{ .tag  = 'B', .mult = 1       },
 		{ .tag  = 'K', .mult = 1 << 10 },
@@ -718,33 +717,49 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 		{ .tag  = 0 },
 	};
 
+	if (str == NULL)
+		return -EINVAL;
+
 	val = parse_tag_value(str, tags);
 	if (val != (unsigned long) -1) {
 		/* we got file size value */
 		pages = PERF_ALIGN(val, page_size) / page_size;
-		if (pages < (1UL << 31) && !is_power_of_2(pages)) {
-			pages = next_pow2(pages);
-			pr_info("rounding mmap pages size to %lu (%lu pages)\n",
-				pages * page_size, pages);
-		}
 	} else {
 		/* we got pages count value */
 		char *eptr;
 		pages = strtoul(str, &eptr, 10);
-		if (*eptr != '\0') {
-			pr_err("failed to parse --mmap_pages/-m value\n");
-			return -1;
-		}
+		if (*eptr != '\0')
+			return -EINVAL;
 	}
 
-	if (pages > UINT_MAX || pages > SIZE_MAX / page_size) {
-		pr_err("--mmap_pages/-m value too big\n");
-		return -1;
+	if ((pages == 0) && (min == 0)) {
+		/* leave number of pages at 0 */
+	} else if (pages < (1UL << 31) && !is_power_of_2(pages)) {
+		/* round pages up to next power of 2 */
+		pages = next_pow2(pages);
+		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
+			pages * page_size, pages);
 	}
 
-	size = perf_evlist__mmap_size(pages);
-	if (!size) {
-		pr_err("--mmap_pages/-m value must be a power of two.");
+	if (pages > max)
+		return -EINVAL;
+
+	return pages;
+}
+
+int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
+				  int unset __maybe_unused)
+{
+	unsigned int *mmap_pages = opt->value;
+	unsigned long max = UINT_MAX;
+	long pages;
+
+	if (max < SIZE_MAX / page_size)
+		max = SIZE_MAX / page_size;
+
+	pages = parse_pages_arg(str, 1, max);
+	if (pages < 0) {
+		pr_err("Invalid argument for --mmap_pages/-m\n");
 		return -1;
 	}
 
@@ -796,8 +811,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist,
-			     struct perf_target *target)
+int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 {
 	evlist->threads = thread_map__new_str(target->pid, target->tid,
 					      target->uid);
@@ -805,9 +819,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (perf_target__has_task(target))
+	if (target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
-	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
+	else if (!target__has_cpu(target) && !target->uses_mmap)
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
@@ -1016,8 +1030,7 @@ out_err:
 	return err;
 }
 
-int perf_evlist__prepare_workload(struct perf_evlist *evlist,
-				  struct perf_target *target,
+int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *target,
 				  const char *argv[], bool pipe_output,
 				  bool want_signal)
 {
@@ -1069,7 +1082,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (perf_target__none(target))
+	if (target__none(target))
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ecaa582..649d6ea 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -102,7 +102,7 @@ void perf_evlist__config(struct perf_evlist *evlist,
 int perf_record_opts__config(struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
-				  struct perf_target *target,
+				  struct target *target,
 				  const char *argv[], bool pipe_output,
 				  bool want_signal);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
@@ -134,8 +134,7 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 	evlist->threads	= threads;
 }
 
-int perf_evlist__create_maps(struct perf_evlist *evlist,
-			     struct perf_target *target);
+int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__apply_filters(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5280820..18f7c18 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -168,7 +168,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	perf_evsel__calc_id_pos(evsel);
 }
 
-struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
+struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
@@ -219,7 +219,7 @@ out:
 	return format;
 }
 
-struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name, int idx)
+struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
@@ -645,7 +645,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
-	if (perf_target__has_cpu(&opts->target))
+	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
@@ -653,7 +653,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     perf_target__has_cpu(&opts->target)))
+	     target__has_cpu(&opts->target)))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
@@ -696,7 +696,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	 * Setting enable_on_exec for independent events and
 	 * group leaders for traced executed by perf.
 	 */
-	if (perf_target__none(&opts->target) && perf_evsel__is_group_leader(evsel))
+	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel))
 		attr->enable_on_exec = 1;
 }
 
@@ -2006,8 +2006,7 @@ bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 	return false;
 }
 
-int perf_evsel__open_strerror(struct perf_evsel *evsel,
-			      struct perf_target *target,
+int perf_evsel__open_strerror(struct perf_evsel *evsel, struct target *target,
 			      int err, char *msg, size_t size)
 {
 	switch (err) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 64ec8e1..f502965 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -96,8 +96,19 @@ struct thread_map;
 struct perf_evlist;
 struct perf_record_opts;
 
-struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
-struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name, int idx);
+struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx);
+
+static inline struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr)
+{
+	return perf_evsel__new_idx(attr, 0);
+}
+
+struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx);
+
+static inline struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name)
+{
+	return perf_evsel__newtp_idx(sys, name, 0);
+}
 
 struct event_format *event_format__new(const char *sys, const char *name);
 
@@ -307,8 +318,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 
 bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 			  char *msg, size_t msgsize);
-int perf_evsel__open_strerror(struct perf_evsel *evsel,
-			      struct perf_target *target,
+int perf_evsel__open_strerror(struct perf_evsel *evsel, struct target *target,
 			      int err, char *msg, size_t size);
 
 static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26d9520..369c036 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2797,7 +2797,7 @@ int perf_session__read_header(struct perf_session *session)
 			perf_event__attr_swap(&f_attr.attr);
 
 		tmp = lseek(fd, 0, SEEK_CUR);
-		evsel = perf_evsel__new(&f_attr.attr, i);
+		evsel = perf_evsel__new(&f_attr.attr);
 
 		if (evsel == NULL)
 			goto out_delete_evlist;
@@ -2916,7 +2916,7 @@ int perf_event__process_attr(struct perf_tool *tool __maybe_unused,
 			return -ENOMEM;
 	}
 
-	evsel = perf_evsel__new(&event->attr.attr, evlist->nr_entries);
+	evsel = perf_evsel__new(&event->attr.attr);
 	if (evsel == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ce034c1..0393912 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1394,3 +1394,15 @@ int machine__for_each_thread(struct machine *machine,
 	}
 	return rc;
 }
+
+int __machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
+				  struct target *target, struct thread_map *threads,
+				  perf_event__handler_t process, bool data_mmap)
+{
+	if (target__has_task(target))
+		return perf_event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
+	else if (target__has_cpu(target))
+		return perf_event__synthesize_threads(tool, process, machine, data_mmap);
+	/* command specified */
+	return 0;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 2389ba8..4771330 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -4,6 +4,7 @@
 #include <sys/types.h>
 #include <linux/rbtree.h>
 #include "map.h"
+#include "event.h"
 
 struct addr_location;
 struct branch_stack;
@@ -178,4 +179,15 @@ int machine__for_each_thread(struct machine *machine,
 			     int (*fn)(struct thread *thread, void *p),
 			     void *priv);
 
+int __machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
+				  struct target *target, struct thread_map *threads,
+				  perf_event__handler_t process, bool data_mmap);
+static inline
+int machine__synthesize_threads(struct machine *machine, struct target *target,
+				struct thread_map *threads, bool data_mmap)
+{
+	return __machine__synthesize_threads(machine, NULL, target, threads,
+					     perf_event__process, data_mmap);
+}
+
 #endif /* __PERF_MACHINE_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c90e55c..6de6f89 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -277,7 +277,7 @@ static int __add_event(struct list_head *list, int *idx,
 
 	event_attr_init(attr);
 
-	evsel = perf_evsel__new(attr, (*idx)++);
+	evsel = perf_evsel__new_idx(attr, (*idx)++);
 	if (!evsel)
 		return -ENOMEM;
 
@@ -378,7 +378,7 @@ static int add_tracepoint(struct list_head *list, int *idx,
 {
 	struct perf_evsel *evsel;
 
-	evsel = perf_evsel__newtp(sys_name, evt_name, (*idx)++);
+	evsel = perf_evsel__newtp_idx(sys_name, evt_name, (*idx)++);
 	if (!evsel)
 		return -ENOMEM;
 
@@ -1097,7 +1097,7 @@ static bool is_event_supported(u8 type, unsigned config)
 		.threads = { 0 },
 	};
 
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__new(&attr);
 	if (evsel) {
 		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
 		perf_evsel__delete(evsel);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3c1b75c..8b0bb1f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1137,6 +1137,8 @@ static void sort_entry__setup_elide(struct sort_entry *se,
 
 void sort__setup_elide(FILE *output)
 {
+	struct sort_entry *se;
+
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
 				"dso", output);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
@@ -1172,4 +1174,15 @@ void sort__setup_elide(FILE *output)
 					"snoop", output);
 	}
 
+	/*
+	 * It makes no sense to elide all of sort entries.
+	 * Just revert them to show up again.
+	 */
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (!se->elide)
+			return;
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		se->elide = false;
 }
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 065528b..3c778a0 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -13,9 +13,9 @@
 #include <string.h>
 
 
-enum perf_target_errno perf_target__validate(struct perf_target *target)
+enum target_errno target__validate(struct target *target)
 {
-	enum perf_target_errno ret = PERF_ERRNO_TARGET__SUCCESS;
+	enum target_errno ret = TARGET_ERRNO__SUCCESS;
 
 	if (target->pid)
 		target->tid = target->pid;
@@ -23,42 +23,42 @@ enum perf_target_errno perf_target__validate(struct perf_target *target)
 	/* CPU and PID are mutually exclusive */
 	if (target->tid && target->cpu_list) {
 		target->cpu_list = NULL;
-		if (ret == PERF_ERRNO_TARGET__SUCCESS)
-			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_CPU;
+		if (ret == TARGET_ERRNO__SUCCESS)
+			ret = TARGET_ERRNO__PID_OVERRIDE_CPU;
 	}
 
 	/* UID and PID are mutually exclusive */
 	if (target->tid && target->uid_str) {
 		target->uid_str = NULL;
-		if (ret == PERF_ERRNO_TARGET__SUCCESS)
-			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_UID;
+		if (ret == TARGET_ERRNO__SUCCESS)
+			ret = TARGET_ERRNO__PID_OVERRIDE_UID;
 	}
 
 	/* UID and CPU are mutually exclusive */
 	if (target->uid_str && target->cpu_list) {
 		target->cpu_list = NULL;
-		if (ret == PERF_ERRNO_TARGET__SUCCESS)
-			ret = PERF_ERRNO_TARGET__UID_OVERRIDE_CPU;
+		if (ret == TARGET_ERRNO__SUCCESS)
+			ret = TARGET_ERRNO__UID_OVERRIDE_CPU;
 	}
 
 	/* PID and SYSTEM are mutually exclusive */
 	if (target->tid && target->system_wide) {
 		target->system_wide = false;
-		if (ret == PERF_ERRNO_TARGET__SUCCESS)
-			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM;
+		if (ret == TARGET_ERRNO__SUCCESS)
+			ret = TARGET_ERRNO__PID_OVERRIDE_SYSTEM;
 	}
 
 	/* UID and SYSTEM are mutually exclusive */
 	if (target->uid_str && target->system_wide) {
 		target->system_wide = false;
-		if (ret == PERF_ERRNO_TARGET__SUCCESS)
-			ret = PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM;
+		if (ret == TARGET_ERRNO__SUCCESS)
+			ret = TARGET_ERRNO__UID_OVERRIDE_SYSTEM;
 	}
 
 	return ret;
 }
 
-enum perf_target_errno perf_target__parse_uid(struct perf_target *target)
+enum target_errno target__parse_uid(struct target *target)
 {
 	struct passwd pwd, *result;
 	char buf[1024];
@@ -66,7 +66,7 @@ enum perf_target_errno perf_target__parse_uid(struct perf_target *target)
 
 	target->uid = UINT_MAX;
 	if (str == NULL)
-		return PERF_ERRNO_TARGET__SUCCESS;
+		return TARGET_ERRNO__SUCCESS;
 
 	/* Try user name first */
 	getpwnam_r(str, &pwd, buf, sizeof(buf), &result);
@@ -79,22 +79,22 @@ enum perf_target_errno perf_target__parse_uid(struct perf_target *target)
 		int uid = strtol(str, &endptr, 10);
 
 		if (*endptr != '\0')
-			return PERF_ERRNO_TARGET__INVALID_UID;
+			return TARGET_ERRNO__INVALID_UID;
 
 		getpwuid_r(uid, &pwd, buf, sizeof(buf), &result);
 
 		if (result == NULL)
-			return PERF_ERRNO_TARGET__USER_NOT_FOUND;
+			return TARGET_ERRNO__USER_NOT_FOUND;
 	}
 
 	target->uid = result->pw_uid;
-	return PERF_ERRNO_TARGET__SUCCESS;
+	return TARGET_ERRNO__SUCCESS;
 }
 
 /*
- * This must have a same ordering as the enum perf_target_errno.
+ * This must have a same ordering as the enum target_errno.
  */
-static const char *perf_target__error_str[] = {
+static const char *target__error_str[] = {
 	"PID/TID switch overriding CPU",
 	"PID/TID switch overriding UID",
 	"UID switch overriding CPU",
@@ -104,7 +104,7 @@ static const char *perf_target__error_str[] = {
 	"Problems obtaining information for user %s",
 };
 
-int perf_target__strerror(struct perf_target *target, int errnum,
+int target__strerror(struct target *target, int errnum,
 			  char *buf, size_t buflen)
 {
 	int idx;
@@ -124,21 +124,19 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 		return 0;
 	}
 
-	if (errnum <  __PERF_ERRNO_TARGET__START ||
-	    errnum >= __PERF_ERRNO_TARGET__END)
+	if (errnum <  __TARGET_ERRNO__START || errnum >= __TARGET_ERRNO__END)
 		return -1;
 
-	idx = errnum - __PERF_ERRNO_TARGET__START;
-	msg = perf_target__error_str[idx];
+	idx = errnum - __TARGET_ERRNO__START;
+	msg = target__error_str[idx];
 
 	switch (errnum) {
-	case PERF_ERRNO_TARGET__PID_OVERRIDE_CPU
-	 ... PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM:
+	case TARGET_ERRNO__PID_OVERRIDE_CPU ... TARGET_ERRNO__UID_OVERRIDE_SYSTEM:
 		snprintf(buf, buflen, "%s", msg);
 		break;
 
-	case PERF_ERRNO_TARGET__INVALID_UID:
-	case PERF_ERRNO_TARGET__USER_NOT_FOUND:
+	case TARGET_ERRNO__INVALID_UID:
+	case TARGET_ERRNO__USER_NOT_FOUND:
 		snprintf(buf, buflen, msg, target->uid_str);
 		break;
 
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index a4be857..89bab71 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -4,7 +4,7 @@
 #include <stdbool.h>
 #include <sys/types.h>
 
-struct perf_target {
+struct target {
 	const char   *pid;
 	const char   *tid;
 	const char   *cpu_list;
@@ -14,8 +14,8 @@ struct perf_target {
 	bool	     uses_mmap;
 };
 
-enum perf_target_errno {
-	PERF_ERRNO_TARGET__SUCCESS		= 0,
+enum target_errno {
+	TARGET_ERRNO__SUCCESS		= 0,
 
 	/*
 	 * Choose an arbitrary negative big number not to clash with standard
@@ -24,42 +24,40 @@ enum perf_target_errno {
 	 *
 	 * http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
 	 */
-	__PERF_ERRNO_TARGET__START		= -10000,
+	__TARGET_ERRNO__START		= -10000,
 
+	/* for target__validate() */
+	TARGET_ERRNO__PID_OVERRIDE_CPU	= __TARGET_ERRNO__START,
+	TARGET_ERRNO__PID_OVERRIDE_UID,
+	TARGET_ERRNO__UID_OVERRIDE_CPU,
+	TARGET_ERRNO__PID_OVERRIDE_SYSTEM,
+	TARGET_ERRNO__UID_OVERRIDE_SYSTEM,
 
-	/* for perf_target__validate() */
-	PERF_ERRNO_TARGET__PID_OVERRIDE_CPU	= __PERF_ERRNO_TARGET__START,
-	PERF_ERRNO_TARGET__PID_OVERRIDE_UID,
-	PERF_ERRNO_TARGET__UID_OVERRIDE_CPU,
-	PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM,
-	PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM,
+	/* for target__parse_uid() */
+	TARGET_ERRNO__INVALID_UID,
+	TARGET_ERRNO__USER_NOT_FOUND,
 
-	/* for perf_target__parse_uid() */
-	PERF_ERRNO_TARGET__INVALID_UID,
-	PERF_ERRNO_TARGET__USER_NOT_FOUND,
-
-	__PERF_ERRNO_TARGET__END,
+	__TARGET_ERRNO__END,
 };
 
-enum perf_target_errno perf_target__validate(struct perf_target *target);
-enum perf_target_errno perf_target__parse_uid(struct perf_target *target);
+enum target_errno target__validate(struct target *target);
+enum target_errno target__parse_uid(struct target *target);
 
-int perf_target__strerror(struct perf_target *target, int errnum, char *buf,
-			  size_t buflen);
+int target__strerror(struct target *target, int errnum, char *buf, size_t buflen);
 
-static inline bool perf_target__has_task(struct perf_target *target)
+static inline bool target__has_task(struct target *target)
 {
 	return target->tid || target->pid || target->uid_str;
 }
 
-static inline bool perf_target__has_cpu(struct perf_target *target)
+static inline bool target__has_cpu(struct target *target)
 {
 	return target->system_wide || target->cpu_list;
 }
 
-static inline bool perf_target__none(struct perf_target *target)
+static inline bool target__none(struct target *target)
 {
-	return !perf_target__has_task(target) && !perf_target__has_cpu(target);
+	return !target__has_task(target) && !target__has_cpu(target);
 }
 
 #endif /* _PERF_TARGET_H */
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index f857b51..ce793c7 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -27,7 +27,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	float ksamples_per_sec;
 	float esamples_percent;
 	struct perf_record_opts *opts = &top->record_opts;
-	struct perf_target *target = &opts->target;
+	struct target *target = &opts->target;
 	size_t ret = 0;
 
 	if (top->samples) {
