Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3KANwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:52:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:23727 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3KANwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:52:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="402157078"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 10/11] perf evsel: Add missing PERF_SAMPLE_TRANSACTION
Date: Fri,  1 Nov 2013 15:51:38 +0200
Message-Id: <1383313899-15987-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing PERF_SAMPLE_TRANSACTION to
perf_event__synthesize_sample() and
perf_event__sample_event_size().

This makes the "sample parsing" test pass.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dc2b2dc..7802bde 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1579,6 +1579,9 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	if (type & PERF_SAMPLE_DATA_SRC)
 		result += sizeof(u64);
 
+	if (type & PERF_SAMPLE_TRANSACTION)
+		result += sizeof(u64);
+
 	return result;
 }
 
@@ -1752,6 +1755,11 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_TRANSACTION) {
+		*array = sample->transaction;
+		array++;
+	}
+
 	return 0;
 }
 
-- 
1.7.11.7

