Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3HTRPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:15:53 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47097 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3HTRPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:15:52 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf trace: Make command line arguments consistent with perf-record - v3
Date: Tue, 20 Aug 2013 11:15:45 -0600
Message-Id: <1377018945-21940-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common arguments like thread id, CPU list, mmap pages, etc should be
consistent across perf commands.

v3: Updated man page
v2: rebased to latest core branch

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-trace.txt |    6 ++++++
 tools/perf/builtin-trace.c              |   12 ++++++------
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
1.7.10.1

