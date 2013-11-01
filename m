Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3KANwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:52:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:23727 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3KANwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:52:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="402157008"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 07/11] perf evsel: Always use perf_evsel__set_sample_bit()
Date: Fri,  1 Nov 2013 15:51:35 +0200
Message-Id: <1383313899-15987-8-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use perf_evsel__set_sample_bit() rather than
just setting the bit.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f1839b0..f0e263c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -663,7 +663,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (opts->sample_address)
-		attr->sample_type	|= PERF_SAMPLE_DATA_SRC;
+		perf_evsel__set_sample_bit(evsel, DATA_SRC);
 
 	if (opts->no_delay) {
 		attr->watermark = 0;
@@ -675,14 +675,14 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (opts->sample_weight)
-		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
 	attr->mmap  = track;
 	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
 
 	if (opts->sample_transaction)
-		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
+		perf_evsel__set_sample_bit(evsel, TRANSACTION);
 
 	/*
 	 * XXX see the function comment above
-- 
1.7.11.7

