Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab3HTOsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:48:06 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45481 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3HTOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:48:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf trace: Make command line arguments consistent with perf-record
Date: Tue, 20 Aug 2013 08:47:56 -0600
Message-Id: <1377010076-21509-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common arguments like thread id, CPU list, mmap pages, etc should be
consistent across perf commands.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-trace.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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

