Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3KAPY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:24:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab3KAPX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:23:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 3/3] perf tools: Add -L as short option for call-graph for record/top commands
Date: Fri,  1 Nov 2013 16:23:14 +0100
Message-Id: <1383319394-19046-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383319394-19046-1-git-send-email-jolsa@redhat.com>
References: <1383319394-19046-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -L as short option for call-graph for record/top
commands. Plus documentation update.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt | 1 +
 tools/perf/Documentation/perf-top.txt    | 1 +
 tools/perf/builtin-record.c              | 2 +-
 tools/perf/builtin-top.c                 | 2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 22ccd63..fb4956e 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -92,6 +92,7 @@ OPTIONS
 -g::
 	Enables call-graph (stack chain/backtrace) recording.
 
+-L::
 --call-graph::
 	Setup and enable call-graph (stack chain/backtrace) recording,
 	implies -g.
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 456fd65..f92d477 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -143,6 +143,7 @@ Default is to monitor all CPUS.
 -G::
 	Enables call-graph (stack chain/backtrace) recording.
 
+-L::
 --call-graph::
 	Setup and enable call-graph (stack chain/backtrace) recording,
 	implies -G.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 04c5cf9..a20098d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -903,7 +903,7 @@ const struct option record_options[] = {
 	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
 			   NULL, "enables call-graph recording" ,
 			   &record_callchain_opt),
-	OPT_CALLBACK(0, "call-graph", &record.opts,
+	OPT_CALLBACK('L', "call-graph", &record.opts,
 		     "mode[,dump_size]", record_callchain_help,
 		     &record_parse_callchain_opt),
 	OPT_INCR('v', "verbose", &verbose,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e1671b1..938e025 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1121,7 +1121,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
 			   NULL, "enables call-graph recording",
 			   &callchain_opt),
-	OPT_CALLBACK(0, "call-graph", &top.record_opts,
+	OPT_CALLBACK('L', "call-graph", &top.record_opts,
 		     "mode[,dump_size]", record_callchain_help,
 		     &parse_callchain_opt),
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
-- 
1.7.11.7

