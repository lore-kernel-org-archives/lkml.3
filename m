Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3FZHPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:15:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57313 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3FZHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:33 -0400
X-AuditID: 9c930179-b7cafae000004567-9c-51ca94d39b63
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/19] perf tools: Add document for perf-ftrace command
Date: Wed, 26 Jun 2013 16:14:18 +0900
Message-Id: <1372230862-15861-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-ftrace.txt | 114 +++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-ftrace.txt

diff --git a/tools/perf/Documentation/perf-ftrace.txt b/tools/perf/Documentation/perf-ftrace.txt
new file mode 100644
index 000000000000..e102ccc6daa7
--- /dev/null
+++ b/tools/perf/Documentation/perf-ftrace.txt
@@ -0,0 +1,114 @@
+perf-ftrace(1)
+==============
+
+NAME
+----
+perf-ftrace - A front end for kernel's ftrace
+
+SYNOPSIS
+--------
+[verse]
+'perf ftrace' {live|record} [<options>] [<command>]
+'perf ftrace' {show|report} [<options>]
+
+DESCRIPTION
+-----------
+This command reads the ftrace buffer and displays the trace recorded.
+
+There are several variants of perf ftrace:
+
+  'perf ftrace live <command>' to see a live trace of kernel functions
+  via trace_pipe during executing the <command>.  If <command> is not
+  specified, one of the target options (-p, -a or -C) should be given.
+  It just prints out the result to stdout and doesn't save any files.
+
+  'perf ftrace record <command>' to record trace entries of kernel
+  functions during the execution of the <command>.  Like 'perf ftrace
+  live', at least one of <command> and/or target options should be
+  given in order to start recording.  The recorded results are saved
+  under a directory ('perf.data.dir' by default) and will be used by
+  other perf-ftrace tools like 'show' and 'report'.
+
+  'perf ftrace show' to see the trace of recorded functions.  It shows
+  functions sorted by time so the end result might be interspersed if
+  there's a concurrent execution.
+
+  'perf ftrace report' to display the result in an usual perf-report
+  style - entries are sorted by given sort keys and output is resorted
+  by its overhead.
+
+OPTIONS
+-------
+<command>...::
+	Any command you can specify in a shell.
+
+-t::
+--tracer=::
+        The ftrace tracer to be used (default: function_graph).
+	Currently only 'function' and 'function_graph' are supported.
+        Used by 'live' and 'record' subcommands only.
+
+-p::
+--pid=::
+	Record events on existing process ID (comma separated list).
+        Used by 'live' and 'record' subcommands only.
+
+-a::
+        Force system-wide collection.  Scripts run without a <command>
+        normally use -a by default, while scripts run with a <command>
+        normally don't - this option allows the latter to be run in
+        system-wide mode.  Used by 'live' and 'record' subcommands only.
+
+-C::
+--cpu:: Only process samples for the list of CPUs provided.
+        Multiple CPUs can be provided as a comma-separated list with
+        no space: 0,1. Ranges of CPUs are specified with -: 0-2.
+	Default is to report samples on all online CPUs.
+
+-s::
+--sort=::
+	Sort histogram entries by given key(s) - multiple keys can be
+        specified in CSV format.  Following sort keys are available:
+	pid, comm, dso, symbol, cpu.
+
+	Each key has following meaning:
+
+	- comm: command (name) of the task
+	- pid: command and tid of the task
+	- dso: name of library or module executed at the time of sample
+	- symbol: name of function executed at the time of sample
+	- cpu: cpu number the task ran at the time of sample
+
+	By default, comm, dso and symbol keys are used.
+	(i.e. --sort comm,dso,symbol)
+	Used by 'report' subcommands only.
+
+-i::
+--input=::
+        Input directory name excluding '.dir' at the end.
+        (default: perf.data)
+
+-o::
+--output=::
+        Output directory name excluding '.dir' at the end.
+	(default: perf.data)
+
+-v::
+--verbose::
+	Be more verbose (show counter open errors, etc).
+
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.  Used by 'report' subcommands only.
+
+-I::
+--show-info::
+	Display extended information about the record.  This adds
+	information which may be very large and thus may clutter the
+        display.  It currently includes: cpu and numa topology of the
+        host system.  It can only be used with the 'report' subcommand.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1],
+linkperf:perf-script[1]
-- 
1.7.11.7

