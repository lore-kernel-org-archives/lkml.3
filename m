Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaAPNiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:38:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPNiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:05 -0500
Date: Thu, 16 Jan 2014 05:37:04 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-f8hd2010uhjl2zzb34hepbmi@git.kernel.org>
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
Subject: [tip:perf/core] perf record: Rename --no-delay to --no-buffering
Git-Commit-ID: 509051ea8427b2f73f065a1b0a1ef871727c9cb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:37:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  509051ea8427b2f73f065a1b0a1ef871727c9cb2
Gitweb:     http://git.kernel.org/tip/509051ea8427b2f73f065a1b0a1ef871727c9cb2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 14 Jan 2014 17:52:14 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Jan 2014 17:57:04 -0300

perf record: Rename --no-delay to --no-buffering

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
index 82bffac..3a35a85 100644
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
index 07d4cf8..78e790f 100644
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
index 4bd44ab..896f270 100644
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
index af1ce6e..3c2f213 100644
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
index 5a016f6..c505ef2 100644
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
index 39cc7c3..aca1a83 100644
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
index cd4630a..22e18a2 100644
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
