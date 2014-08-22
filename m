Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaHVNGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:06:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331AbaHVNGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:06:05 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/5] perf tools: Allow PERF_FORMAT_GROUP for inherited events
Date: Fri, 22 Aug 2014 15:05:18 +0200
Message-Id: <1408712718-19656-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408712718-19656-1-git-send-email-jolsa@kernel.org>
References: <1408712718-19656-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swithing on leader sampling on inherited events.

Following command will now get data from all children processes:
  $ perf record -e '{cycles,cache-misses}:S' <workload>

Use following command to display the data:
  $ perf report --group

Reported-by: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 507d458ded2c..29e32b59d762 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -584,10 +584,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		 * Apply group format only if we belong to group
 		 * with more than one members.
 		 */
-		if (leader->nr_members > 1) {
+		if (leader->nr_members > 1)
 			attr->read_format |= PERF_FORMAT_GROUP;
-			attr->inherit = 0;
-		}
 	}
 
 	/*
-- 
1.8.3.1

