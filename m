Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaGNKFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:05:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:40395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbaGNKEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434224"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/41] perf tools: Fix appending a callchain from a previous sample
Date: Mon, 14 Jul 2014 13:02:35 +0300
Message-Id: <1405332185-4050-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hist_entry__append_callchain() must check if the sample
has a callcahin or it will append the callchain from
a previous sample.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/callchain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 48b6d3f..437ee09 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -626,7 +626,7 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample)
 {
-	if (!symbol_conf.use_callchain)
+	if (!symbol_conf.use_callchain || sample->callchain == NULL)
 		return 0;
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
-- 
1.8.3.2

