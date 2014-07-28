Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaG1I23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:28:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaG1I2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:28:25 -0400
Date: Mon, 28 Jul 2014 01:27:31 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a7a2b8b4ce9e0bfd085c5797d535487594a71882@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-30-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-30-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject: Add --kallsyms parameter
Git-Commit-ID: a7a2b8b4ce9e0bfd085c5797d535487594a71882
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

Commit-ID:  a7a2b8b4ce9e0bfd085c5797d535487594a71882
Gitweb:     http://git.kernel.org/tip/a7a2b8b4ce9e0bfd085c5797d535487594a71882
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:38 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jul 2014 12:08:34 -0300

perf inject: Add --kallsyms parameter

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
index cf6a605..9a02807 100644
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
