Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaGNKQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:16:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:2366 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbaGNKE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434276"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/41] perf script: Do not print dangling '=>' for BTS
Date: Mon, 14 Jul 2014 13:02:40 +0300
Message-Id: <1405332185-4050-17-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using:

	perf record -e branches:u -c1
	perf script -f ip

lines are displayed like:

	ffffffff813b23d5 =>

Change so that the dangling '=>' does not appear.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 333b15e..582da97 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -446,13 +446,13 @@ static void print_sample_bts(union perf_event *event,
 				     PERF_MAX_STACK_DEPTH);
 	}
 
-	printf(" => ");
-
 	/* print branch_to information */
 	if (PRINT_FIELD(ADDR) ||
 	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
-	     !output[attr->type].user_set))
+	     !output[attr->type].user_set)) {
+		printf(" => ");
 		print_sample_addr(event, sample, al->machine, thread, attr);
+	}
 
 	if (print_srcline_last)
 		map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
-- 
1.8.3.2

