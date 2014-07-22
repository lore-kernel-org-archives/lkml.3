Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaGVN2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:28:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:45490 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbaGVNUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985931"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/52] perf inject: Add --kallsyms parameter
Date: Tue, 22 Jul 2014 16:17:38 +0300
Message-Id: <1406035081-14301-30-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let perf inject take --kallsyms parameter the same as
perf script and perf report do.  That is needed for
decoding Instruction Trace data using a copy of
/proc/kcore for the kernel object because the kallsyms
path is used to locate that copy.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-inject.txt | 3 +++
 tools/perf/builtin-inject.c              | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index a00a342..dc7442c 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -41,6 +41,9 @@ OPTIONS
 	tasks slept. sched_switch contains a callchain where a task slept and
 	sched_stat contains a timeslice how long a task slept.
 
+--kallsyms=<file>::
+	kallsyms pathname
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-archive[1]
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ce691c4..af17800 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -440,6 +440,8 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "where and how long tasks slept"),
 		OPT_INCR('v', "verbose", &verbose,
 			 "be more verbose (show build ids, etc)"),
+		OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name, "file",
+			   "kallsyms pathname"),
 		OPT_END()
 	};
 	const char * const inject_usage[] = {
-- 
1.8.3.2

