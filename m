Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3H1O7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:59:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40476 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3H1O7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/21] perf trace: Make command line arguments consistent with perf-record
Date: Wed, 28 Aug 2013 11:59:22 -0300
Message-Id: <1377701977-2085-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Common arguments like thread id, CPU list, mmap pages, etc should be
consistent across perf commands.

v3: Updated man page
v2: rebased to latest core branch

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1377018945-21940-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  6 ++++++
 tools/perf/builtin-trace.c              | 12 ++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 2794efc..cb3371e 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -23,6 +23,7 @@ analysis phases.
 OPTIONS
 -------
 
+-a::
 --all-cpus::
         System-wide collection from all CPUs.
 
@@ -38,18 +39,23 @@ OPTIONS
 --pid=::
 	Record events on existing process ID (comma separated list).
 
+-t::
 --tid=::
         Record events on existing thread ID (comma separated list).
 
+-u::
 --uid=::
         Record events in threads owned by uid. Name or number.
 
+-i::
 --no-inherit::
 	Child tasks do not inherit counters.
 
+-m::
 --mmap-pages=::
 	Number of mmap data pages. Must be a power of two.
 
+-C::
 --cpu::
 Collect samples only on the list of CPUs provided. Multiple CPUs can be provided as a
 comma-separated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 4235316..9891d8c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -693,17 +693,17 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
 	OPT_STRING('p', "pid", &trace.opts.target.pid, "pid",
 		    "trace events on existing process id"),
-	OPT_STRING(0, "tid", &trace.opts.target.tid, "tid",
+	OPT_STRING('t', "tid", &trace.opts.target.tid, "tid",
 		    "trace events on existing thread id"),
-	OPT_BOOLEAN(0, "all-cpus", &trace.opts.target.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &trace.opts.target.system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_STRING(0, "cpu", &trace.opts.target.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &trace.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
-	OPT_BOOLEAN(0, "no-inherit", &trace.opts.no_inherit,
+	OPT_BOOLEAN('i', "no-inherit", &trace.opts.no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_UINTEGER(0, "mmap-pages", &trace.opts.mmap_pages,
+	OPT_UINTEGER('m', "mmap-pages", &trace.opts.mmap_pages,
 		     "number of mmap data pages"),
-	OPT_STRING(0, "uid", &trace.opts.target.uid_str, "user",
+	OPT_STRING('u', "uid", &trace.opts.target.uid_str, "user",
 		   "user to profile"),
 	OPT_CALLBACK(0, "duration", &trace, "float",
 		     "show only events with duration > N.M ms",
-- 
1.8.1.4

