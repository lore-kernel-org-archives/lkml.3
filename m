Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3KODvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:51:39 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61552 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3KODvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:51:33 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] perf top: Make -g refer to callchains
Date: Thu, 14 Nov 2013 20:51:30 -0700
Message-Id: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In most commands -g is used for callchains. Make perf-top follow suit.
Move group to just --group with no short cut making it similar to
perf-record.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt | 5 ++---
 tools/perf/builtin-top.c              | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 7de01dd79688..cdd8d4946dba 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -50,7 +50,6 @@ Default is to monitor all CPUS.
 --count-filter=<count>::
 	Only display functions with more events than this.
 
--g::
 --group::
         Put the counters into a counter group.
 
@@ -143,12 +142,12 @@ Default is to monitor all CPUS.
 --asm-raw::
 	Show raw instruction encoding of assembly instructions.
 
--G::
+-g::
 	Enables call-graph (stack chain/backtrace) recording.
 
 --call-graph::
 	Setup and enable call-graph (stack chain/backtrace) recording,
-	implies -G.
+	implies -g.
 
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 71e6402729a8..531522d3d97b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1084,7 +1084,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "dump the symbol table used for profiling"),
 	OPT_INTEGER('f', "count-filter", &top.count_filter,
 		    "only display functions with more events than this"),
-	OPT_BOOLEAN('g', "group", &opts->group,
+	OPT_BOOLEAN(0, "group", &opts->group,
 			    "put the counters into a counter group"),
 	OPT_BOOLEAN('i', "no-inherit", &opts->no_inherit,
 		    "child tasks do not inherit counters"),
@@ -1105,7 +1105,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
+	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
 			   NULL, "enables call-graph recording",
 			   &callchain_opt),
 	OPT_CALLBACK(0, "call-graph", &top.record_opts,
-- 
1.8.3.4 (Apple Git-47)

