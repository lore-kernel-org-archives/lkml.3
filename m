Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaASM0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:26:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaASM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:26:04 -0500
Date: Sun, 19 Jan 2014 04:25:27 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-2a29190c040c0b11e39197c67abf6f87e0a61f9a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1389713836-13375-4-git-send-email-fweisbec@gmail.com>
References: <1389713836-13375-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove unnecessary callchain cursor state restore on unmatch
Git-Commit-ID: 2a29190c040c0b11e39197c67abf6f87e0a61f9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:25:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a29190c040c0b11e39197c67abf6f87e0a61f9a
Gitweb:     http://git.kernel.org/tip/2a29190c040c0b11e39197c67abf6f87e0a61f9a
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 14 Jan 2014 16:37:16 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Jan 2014 11:25:24 -0300

perf tools: Remove unnecessary callchain cursor state restore on unmatch

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
index 662867d..8d9db45 100644
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
 
