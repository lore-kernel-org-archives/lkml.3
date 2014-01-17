Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaAQO7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:59:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaAQO5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/19] perf tools: Remove unnecessary callchain cursor state restore on unmatch
Date: Fri, 17 Jan 2014 11:57:25 -0300
Message-Id: <1389970645-12075-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

If a new callchain branch doesn't match a single entry of the node that
it is given against comparison in append_chain(), then the cursor is
expected to be at the same position as it was before the comparison
loop.

As such, there is no need to restore the cursor position on exit in case
of non matching branches.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1389713836-13375-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 662867d5c374..8d9db454f1a9 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -388,7 +388,6 @@ append_chain(struct callchain_node *root,
 	     struct callchain_cursor *cursor,
 	     u64 period)
 {
-	struct callchain_cursor_node *curr_snap = cursor->curr;
 	struct callchain_list *cnode;
 	u64 start = cursor->pos;
 	bool found = false;
@@ -420,8 +419,6 @@ append_chain(struct callchain_node *root,
 	/* matches not, relay no the parent */
 	if (!found) {
 		WARN_ONCE(!cmp, "Chain comparison error\n");
-		cursor->curr = curr_snap;
-		cursor->pos = start;
 		return cmp;
 	}
 
-- 
1.8.1.4

