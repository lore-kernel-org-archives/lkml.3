Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3LKMnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:43:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:4721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab3LKMnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422887588"
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
Subject: [PATCH v0 65/71] perf itrace: Add Intel PT as an Instruction Tracing type
Date: Wed, 11 Dec 2013 14:37:17 +0200
Message-Id: <1386765443-26966-66-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add the Intel Processor Trace type
constant PERF_ITRACE_INTEL_PT.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 1 +
 tools/perf/util/itrace.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index 28455f8..8ecbfb1 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -977,6 +977,7 @@ int perf_event__process_itrace_info(struct perf_tool *tool __maybe_unused,
 		return 0;
 
 	switch (type) {
+	case PERF_ITRACE_INTEL_PT:
 	case PERF_ITRACE_UNKNOWN:
 	default:
 		return -EINVAL;
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 1005715..de4b7a0 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -40,6 +40,7 @@ struct itrace_info_event;
 
 enum itrace_type {
 	PERF_ITRACE_UNKNOWN,
+	PERF_ITRACE_INTEL_PT,
 };
 
 enum itrace_error_type {
-- 
1.8.5.1

