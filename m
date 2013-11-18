Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3KRUeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:34:19 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38137 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3KRUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:15 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 8/8] perf sched : Add documentation for timehist options
Date: Mon, 18 Nov 2013 13:32:51 -0700
Message-Id: <1384806771-2945-9-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry to perf-sched documentation for timehist command and its
options.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/Documentation/perf-sched.txt | 60 ++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 8ff4df956951..83fac8b86f52 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -8,7 +8,7 @@ perf-sched - Tool to trace/measure scheduler properties (latencies)
 SYNOPSIS
 --------
 [verse]
-'perf sched' {record|latency|map|replay|script}
+'perf sched' {record|latency|map|replay|script|timehist}
 
 DESCRIPTION
 -----------
@@ -36,6 +36,11 @@ There are five variants of perf sched:
   are running on a CPU. A '*' denotes the CPU that had the event, and
   a dot signals an idle CPU.
 
+  'perf sched timehist' to show context-switching analysis with times
+  between schedule-in, schedule delay, and run time. If callchains are
+  present stack trace is dumped at the end of the line. A summary of
+  run times can be shown as well.
+
 OPTIONS
 -------
 -i::
@@ -50,6 +55,59 @@ OPTIONS
 --dump-raw-trace=::
         Display verbose dump of the sched data.
 
+TIMEHIST OPTIONS
+----------------
+-k::
+--vmlinux=<file>::
+    vmlinux pathname
+
+--kallsyms=<file>::
+    kallsyms pathname
+
+-s::
+--summary::
+    Show only a summary of scheduling by thread with min, max, and average
+    run times (in sec) and relative stddev.
+
+-S::
+--with-summary::
+    Show all scheduling events followed by a summary by thread with min,
+    max, and average run times (in sec) and relative stddev.
+
+-w::
+--wakeups::
+    Show wakeup events.
+
+-c::
+--comms=::
+    Only show events for given comms (comma separated list)
+
+-p::
+--pid=::
+    Only show events for given process ID (comma separated list).
+
+-t::
+--tid=::
+    Only show events for given thread ID (comma separated list).
+
+--call-graph::
+        Display call chains. Default is on. Use --no-call-graph to suppress
+
+--max-stack::
+    Set the stack depth limit when showing the callchains. Default: 127
+
+-x::
+--excl::
+    Symbols to skip in backtrace. Useful to compact repetitive or
+    uninteresting frames to pull more useful frames into view.
+
+--symfs=<directory>::
+    Look for files with symbols relative to this directory.
+
+-V::
+--cpu-visual::
+    Add a visual for following events by cpu
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
-- 
1.8.3.4 (Apple Git-47)

