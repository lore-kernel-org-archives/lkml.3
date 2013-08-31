Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3HaSoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:44:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:30755 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936Ab3HaSoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:44:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,998,1367996400"; 
   d="scan'208";a="289335854"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 2/3] perf tools: add support for PERF_COUNT_SW_DUMMY
Date: Sat, 31 Aug 2013 21:50:52 +0300
Message-Id: <1377975053-3811-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
References: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new dummy software event
PERF_COUNT_SW_DUMMY.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c        | 1 +
 tools/perf/util/parse-events.c | 4 ++++
 tools/perf/util/parse-events.l | 1 +
 tools/perf/util/python.c       | 1 +
 4 files changed, 7 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e8745fb..3612183 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -323,6 +323,7 @@ const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX] = {
 	"major-faults",
 	"alignment-faults",
 	"emulation-faults",
+	"dummy",
 };
 
 static const char *__perf_evsel__sw_name(u64 config)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9cba923..b2dd077 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -108,6 +108,10 @@ static struct event_symbol event_symbols_sw[PERF_COUNT_SW_MAX] = {
 		.symbol = "emulation-faults",
 		.alias  = "",
 	},
+	[PERF_COUNT_SW_DUMMY] = {
+		.symbol = "dummy",
+		.alias  = "",
+	},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 0790452..91346b7 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -145,6 +145,7 @@ context-switches|cs				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW
 cpu-migrations|migrations			{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
 alignment-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
 emulation-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
+dummy						{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_DUMMY); }
 
 L1-dcache|l1-d|l1d|L1-data		|
 L1-icache|l1-i|l1i|L1-instruction	|
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 381f4fd..71b5412 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -987,6 +987,7 @@ static struct {
 	{ "COUNT_SW_PAGE_FAULTS_MAJ",  PERF_COUNT_SW_PAGE_FAULTS_MAJ },
 	{ "COUNT_SW_ALIGNMENT_FAULTS", PERF_COUNT_SW_ALIGNMENT_FAULTS },
 	{ "COUNT_SW_EMULATION_FAULTS", PERF_COUNT_SW_EMULATION_FAULTS },
+	{ "COUNT_SW_DUMMY",            PERF_COUNT_SW_DUMMY },
 
 	{ "SAMPLE_IP",	      PERF_SAMPLE_IP },
 	{ "SAMPLE_TID",	      PERF_SAMPLE_TID },
-- 
1.7.11.7

