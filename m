Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaKKOSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:18:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaKKOSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:18:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151567"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/25] perf header: Add Instruction Tracing feature
Date: Tue, 11 Nov 2014 16:16:42 +0200
Message-Id: <1415715423-15563-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a feature to indicate that a perf.data file
contains Instruction Tracing data.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/header.c | 14 ++++++++++++++
 tools/perf/util/header.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e86fffd..27f8fb5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -869,6 +869,13 @@ static int write_branch_stack(int fd __maybe_unused,
 	return 0;
 }
 
+static int write_itrace(int fd __maybe_unused,
+			struct perf_header *h __maybe_unused,
+			struct perf_evlist *evlist __maybe_unused)
+{
+	return 0;
+}
+
 static void print_hostname(struct perf_header *ph, int fd __maybe_unused,
 			   FILE *fp)
 {
@@ -1163,6 +1170,12 @@ static void print_branch_stack(struct perf_header *ph __maybe_unused,
 	fprintf(fp, "# contains samples with branch stack\n");
 }
 
+static void print_itrace(struct perf_header *ph __maybe_unused,
+			 int fd __maybe_unused, FILE *fp)
+{
+	fprintf(fp, "# contains Instruction Traces\n");
+}
+
 static void print_pmu_mappings(struct perf_header *ph, int fd __maybe_unused,
 			       FILE *fp)
 {
@@ -1873,6 +1886,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
 	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
+	FEAT_OPA(HEADER_ITRACE,		itrace),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 3bb90ac..990edcf 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -30,6 +30,7 @@ enum {
 	HEADER_BRANCH_STACK,
 	HEADER_PMU_MAPPINGS,
 	HEADER_GROUP_DESC,
+	HEADER_ITRACE,
 	HEADER_LAST_FEATURE,
 	HEADER_FEAT_BITS	= 256,
 };
-- 
1.9.1

