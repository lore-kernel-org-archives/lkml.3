Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbaGYPjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:39:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:35265 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934710AbaGYPjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:39:07 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/27] perf inject: Add --kallsyms parameter
Date: Fri, 25 Jul 2014 12:37:07 -0300
Message-Id: <1406302629-11790-26-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Let perf inject take --kallsyms parameter the same as perf script and
perf report do.

That is needed for decoding Instruction Trace data using a copy of
/proc/kcore for the kernel object because the kallsyms path is used to
locate that copy.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-30-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-inject.txt | 3 +++
 tools/perf/builtin-inject.c              | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index a00a34276c54..dc7442cf3d7f 100644
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
index cf6a605a13e8..9a02807387d6 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -439,6 +439,8 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "where and how long tasks slept"),
 		OPT_INCR('v', "verbose", &verbose,
 			 "be more verbose (show build ids, etc)"),
+		OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name, "file",
+			   "kallsyms pathname"),
 		OPT_END()
 	};
 	const char * const inject_usage[] = {
-- 
1.9.3

