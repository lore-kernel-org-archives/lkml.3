Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3LKMvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:51:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:25557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3LKMku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369121"
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
Subject: [PATCH v0 35/71] perf tools: Add itrace members of struct perf_event_attr
Date: Wed, 11 Dec 2013 14:36:47 +0200
Message-Id: <1386765443-26966-36-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add new Instruction Tracing members of struct perf_event_attr
to debug prints and byte swapping.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c   | 4 ++++
 tools/perf/util/session.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 4e92a22..da2116c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -981,6 +981,10 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR_X64(branch_sample_type);
 	ret += PRINT_ATTR_X64(sample_regs_user);
 	ret += PRINT_ATTR_U32(sample_stack_user);
+	ret += PRINT_ATTR_X64(itrace_config);
+	ret += PRINT_ATTR_U32(itrace_watermark);
+	ret += PRINT_ATTR_U32(itrace_sample_type);
+	ret += PRINT_ATTR_U64(itrace_sample_size);
 
 	ret += fprintf(fp, "%.60s\n", graph_dotted_line);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f2ac351..7847096 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -407,6 +407,10 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 	attr->branch_sample_type = bswap_64(attr->branch_sample_type);
 	attr->sample_regs_user	 = bswap_64(attr->sample_regs_user);
 	attr->sample_stack_user  = bswap_32(attr->sample_stack_user);
+	attr->itrace_config	 = bswap_64(attr->itrace_config);
+	attr->itrace_watermark	 = bswap_32(attr->itrace_watermark);
+	attr->itrace_sample_type = bswap_32(attr->itrace_sample_type);
+	attr->itrace_sample_size = bswap_64(attr->itrace_sample_size);
 
 	swap_bitfield((u8 *) (&attr->read_format + 1), sizeof(u64));
 }
-- 
1.8.5.1

