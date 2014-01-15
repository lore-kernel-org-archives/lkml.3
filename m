Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaAOUiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:38:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48491 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAOUdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:38 -0500
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
Subject: [PATCH 01/13] perf record: Rename --no-delay to --no-buffering
Date: Wed, 15 Jan 2014 17:32:59 -0300
Message-Id: <1389817991-8145-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That is how the option summary describes it and so that we can free
--delay to replace --initial-delay and then be consistent with stat's
--delay equivalent option.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-f8hd2010uhjl2zzb34hepbmi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt  | 3 +--
 tools/perf/builtin-record.c               | 2 +-
 tools/perf/builtin-trace.c                | 2 +-
 tools/perf/perf.h                         | 2 +-
 tools/perf/tests/open-syscall-tp-fields.c | 8 ++++----
 tools/perf/tests/perf-record.c            | 6 +++---
 tools/perf/util/evsel.c                   | 2 +-
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 82bffac036e1..3a35a8523e6d 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -68,8 +68,7 @@ OPTIONS
 --realtime=::
 	Collect data with this RT SCHED_FIFO priority.
 
--D::
---no-delay::
+--no-buffering::
 	Collect data without buffering.
 
 -c::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 07d4cf8d3fd3..78e790f4c54f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -838,7 +838,7 @@ const struct option record_options[] = {
 		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &record.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
-	OPT_BOOLEAN('D', "no-delay", &record.opts.no_delay,
+	OPT_BOOLEAN(0, "no-buffering", &record.opts.no_buffering,
 		    "collect data without buffering"),
 	OPT_BOOLEAN('R', "raw-samples", &record.opts.raw_samples,
 		    "collect raw sample records from all opened counters"),
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 4bd44aba343e..896f27047ed6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2258,7 +2258,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			},
 			.user_freq     = UINT_MAX,
 			.user_interval = ULLONG_MAX,
-			.no_delay      = true,
+			.no_buffering  = true,
 			.mmap_pages    = 1024,
 		},
 		.output = stdout,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index af1ce6e14a93..3c2f213e979d 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -252,7 +252,7 @@ struct record_opts {
 	int	     call_graph;
 	bool	     group;
 	bool	     inherit_stat;
-	bool	     no_delay;
+	bool	     no_buffering;
 	bool	     no_inherit;
 	bool	     no_inherit_set;
 	bool	     no_samples;
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 5a016f66f5d2..c505ef2af245 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -11,10 +11,10 @@ int test__syscall_open_tp_fields(void)
 			.uid = UINT_MAX,
 			.uses_mmap = true,
 		},
-		.no_delay   = true,
-		.freq	    = 1,
-		.mmap_pages = 256,
-		.raw_samples = true,
+		.no_buffering = true,
+		.freq	      = 1,
+		.mmap_pages   = 256,
+		.raw_samples  = true,
 	};
 	const char *filename = "/etc/passwd";
 	int flags = O_RDONLY | O_DIRECTORY;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 39cc7c3c0d0c..aca1a83dd13a 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -39,9 +39,9 @@ int test__PERF_RECORD(void)
 			.uid = UINT_MAX,
 			.uses_mmap = true,
 		},
-		.no_delay   = true,
-		.freq	    = 10,
-		.mmap_pages = 256,
+		.no_buffering = true,
+		.freq	      = 10,
+		.mmap_pages   = 256,
 	};
 	cpu_set_t cpu_mask;
 	size_t cpu_mask_size = sizeof(cpu_mask);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index cd4630abfa43..22e18a26b7e6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -627,7 +627,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (opts->sample_address)
 		perf_evsel__set_sample_bit(evsel, DATA_SRC);
 
-	if (opts->no_delay) {
+	if (opts->no_buffering) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
 	}
-- 
1.8.1.4

