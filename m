Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3LKMut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:50:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:50540 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab3LKMk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369197"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 39/71] perf header: Add Instruction Tracing feature
Date: Wed, 11 Dec 2013 14:36:51 +0200
Message-Id: <1386765443-26966-40-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a feature to indicate that a perf.data file
contains Instruction Tracing data.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/header.c | 14 ++++++++++++++
 tools/perf/util/header.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0114f0a..72bcca9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1188,6 +1188,13 @@ static int write_branch_stack(int fd __maybe_unused,
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
@@ -1485,6 +1492,12 @@ static void print_branch_stack(struct perf_header *ph __maybe_unused,
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
@@ -2195,6 +2208,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
 	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
+	FEAT_OPA(HEADER_ITRACE,		itrace),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index e8c45fa..be60483 100644
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
1.8.5.1

