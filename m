Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3LKMr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:47:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:46009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab3LKMmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448281303"
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
Subject: [PATCH v0 54/71] perf script: Always allow fields 'addr' and 'cpu' for itrace
Date: Wed, 11 Dec 2013 14:37:06 +0200
Message-Id: <1386765443-26966-55-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

If a file contains Instruction Tracing data then always allow
fields 'addr' and 'cpu' to be selected as options for perf
script.  This is necessary because Instruction Trace decoding
may synthesize events with that information.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 96cdcd8..15f4941 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -190,6 +190,7 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 	}
 
 	if (PRINT_FIELD(ADDR) &&
+		!perf_header__has_feat(&session->header, HEADER_ITRACE) &&
 		perf_evsel__check_stype(evsel, PERF_SAMPLE_ADDR, "ADDR",
 					PERF_OUTPUT_ADDR))
 		return -EINVAL;
@@ -223,6 +224,7 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		return -EINVAL;
 
 	if (PRINT_FIELD(CPU) &&
+		!perf_header__has_feat(&session->header, HEADER_ITRACE) &&
 		perf_evsel__check_stype(evsel, PERF_SAMPLE_CPU, "CPU",
 					PERF_OUTPUT_CPU))
 		return -EINVAL;
-- 
1.8.5.1

