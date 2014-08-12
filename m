Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaHLPHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:07:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:20192 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbaHLPG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:06:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,849,1400050800"; 
   d="scan'208";a="575603078"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf tools: Fix one of the probe events to exclude kernel
Date: Tue, 12 Aug 2014 18:04:29 +0300
Message-Id: <1407855871-15024-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When probing the kernel API the kernel should be excluded
otherwise the probe will fail for users with insufficient
privilege to profile the kernel.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 787b882..68ad2d0 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -47,7 +47,7 @@ out_delete:
 
 static bool perf_probe_api(setup_probe_fn_t fn)
 {
-	const char *try[] = {"cycles:u", "instructions:u", "cpu-clock", NULL};
+	const char *try[] = {"cycles:u", "instructions:u", "cpu-clock:u", NULL};
 	struct cpu_map *cpus;
 	int cpu, ret, i = 0;
 
-- 
1.8.3.2

