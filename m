Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbaGYPhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:34918 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:37 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/27] perf script: Do not print dangling '=>' for BTS
Date: Fri, 25 Jul 2014 12:36:46 -0300
Message-Id: <1406302629-11790-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

When using:

	perf record -e branches:u -c1 usleep 1
	perf script -f ip

lines are displayed like:

	ffffffff813b23d5 =>

Change so that the dangling '=>' does not appear.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 333b15ebe72b..582da97872e5 100644
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
1.9.3

