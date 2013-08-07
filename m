Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab3HGNYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:24:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:37973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932921Ab3HGNYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,833,1367996400"; 
   d="scan'208";a="377485403"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf tools: add support for PERF_COUNT_SW_DUMMY
Date: Wed,  7 Aug 2013 16:30:30 +0300
Message-Id: <1375882231-18339-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
References: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new dummy software event
PERF_COUNT_SW_DUMMY.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/parse-events.c | 4 ++++
 tools/perf/util/parse-events.l | 1 +
 tools/perf/util/python.c       | 1 +
 3 files changed, 6 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index dba877d..1ef81ea 100644
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
index b36115f..29c5d24 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -144,6 +144,7 @@ context-switches|cs				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW
 cpu-migrations|migrations			{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS); }
 alignment-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_ALIGNMENT_FAULTS); }
 emulation-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
+dummy						{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_DUMMY); }
 
 L1-dcache|l1-d|l1d|L1-data		|
 L1-icache|l1-i|l1i|L1-instruction	|
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 925e0c3..2fa83c0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -967,6 +967,7 @@ static struct {
 	{ "COUNT_SW_PAGE_FAULTS_MAJ",  PERF_COUNT_SW_PAGE_FAULTS_MAJ },
 	{ "COUNT_SW_ALIGNMENT_FAULTS", PERF_COUNT_SW_ALIGNMENT_FAULTS },
 	{ "COUNT_SW_EMULATION_FAULTS", PERF_COUNT_SW_EMULATION_FAULTS },
+	{ "COUNT_SW_DUMMY",            PERF_COUNT_SW_DUMMY },
 
 	{ "SAMPLE_IP",	      PERF_SAMPLE_IP },
 	{ "SAMPLE_TID",	      PERF_SAMPLE_TID },
-- 
1.7.11.7

