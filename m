Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab3KYOXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:23:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42663 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab3KYOSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:18:03 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/25] perf top: Make -g refer to callchains
Date: Mon, 25 Nov 2013 11:17:33 -0300
Message-Id: <1385389075-7989-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385389075-7989-1-git-send-email-acme@infradead.org>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

In most commands -g is used for callchains. Make perf-top follow suit.
Move group to just --group with no short cut making it similar to
perf-record.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1384487490-6865-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

