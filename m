Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3DALfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:35:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44674 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab3DALfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:30 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-8f-515970fe8510
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 8/9] perf sort: Update documentation for sort keys
Date: Mon,  1 Apr 2013 20:35:24 +0900
Message-Id: <1364816125-12212-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Update and add missing description of new sort keys.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-diff.txt   | 2 +-
 tools/perf/Documentation/perf-report.txt | 5 ++++-
 tools/perf/Documentation/perf-top.txt    | 2 +-
 tools/perf/builtin-diff.c                | 2 +-
 tools/perf/builtin-report.c              | 6 +++---
 tools/perf/builtin-top.c                 | 3 ++-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 5b3123d5721f..f74ec064db0e 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -47,7 +47,7 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol.
+	Sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, addr.
 
 -t::
 --field-separator=::
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 7d5f4f38aa52..54acc51995fc 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -59,7 +59,7 @@ OPTIONS
 --sort=::
 	Sort histogram entries by given key(s) - multiple keys can be specified
 	in CSV format.  Following sort keys are available:
-	pid, comm, dso, symbol, parent, cpu, srcline, weight, local_weight.
+	pid, comm, dso, symbol, parent, cpu, srcline, addr.
 
 	Each key has following meaning:
 
@@ -72,6 +72,7 @@ OPTIONS
 	- cpu: cpu number the task ran at the time of sample
 	- srcline: filename and line number executed at the time of sample.  The
 	DWARF debuggin info must be provided.
+	- addr: address of function executed at the time of sample
 
 	By default, comm, dso and symbol keys are used.
 	(i.e. --sort comm,dso,symbol)
@@ -84,6 +85,8 @@ OPTIONS
 	- dso_to: name of library or module branched to
 	- symbol_from: name of function branched from
 	- symbol_to: name of function branched to
+	- addr_from: address of function branched from
+	- addr_to: address of function branched to
 	- mispredict: "N" for predicted branch, "Y" for mispredicted branch
 
 	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 9f1a2fe54757..2b45e799c4be 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -112,7 +112,7 @@ Default is to monitor all CPUS.
 
 -s::
 --sort::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight, local_weight.
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline, cpu, addr.
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2d0462d89a97..03b56c542bb6 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -542,7 +542,7 @@ static const struct option options[] = {
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, addr"),
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 669405c9b8a2..c95fd92fbd44 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -756,9 +756,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
-		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
-		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
-		   "snoop, locked"),
+		   " addr, dso_to, dso_from, symbol_to, symbol_from, addr_to,"
+		   " addr_from, mispredict, weight, local_weight, mem,"
+		   " symbol_daddr, dso_daddr, tlb, snoop, locked"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 67bdb9f14ad6..9aae3f518f39 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1089,7 +1089,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu,"
+		   " srcline, addr"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
-- 
1.7.11.7

