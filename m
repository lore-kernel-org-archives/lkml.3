Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaANPiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:38:03 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:54581 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaANPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:37:34 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf tools: Remove unnecessary callchain cursor state restore on unmatch
Date: Tue, 14 Jan 2014 16:37:16 +0100
Message-Id: <1389713836-13375-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a new callchain branch doesn't match a single entry of the node that
it is given against comparison in append_chain(), then the cursor is
expected to be at the same position as it was before the comparison loop.

As such, there is no need to restore the cursor position on exit in case
of non matching branches.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/callchain.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index e5ed16d..85a54ad 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -386,7 +386,6 @@ append_chain(struct callchain_node *root,
 	     struct callchain_cursor *cursor,
 	     u64 period)
 {
-	struct callchain_cursor_node *curr_snap = cursor->curr;
 	struct callchain_list *cnode;
 	u64 start = cursor->pos;
 	bool found = false;
@@ -418,8 +417,6 @@ append_chain(struct callchain_node *root,
 	/* matches not, relay no the parent */
 	if (!found) {
 		WARN_ONCE(!cmp, "Chain comparison error\n");
-		cursor->curr = curr_snap;
-		cursor->pos = start;
 		return cmp;
 	}
 
-- 
1.8.3.1

