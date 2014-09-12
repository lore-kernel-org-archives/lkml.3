Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaILLSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbaILLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:18:46 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/3] Revert "perf: Do not allow optimized switch for non-cloned events"
Date: Fri, 12 Sep 2014 13:18:28 +0200
Message-Id: <1410520708-19275-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
References: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

This reverts commit 1f9a7268c67f0290837aada443d28fd953ddca90.

With the fix of the initial state for the cloned event we now correctly
handle the error described in:
  1f9a7268c67f perf: Do not allow optimized switch for non-cloned events
so we can revert it.

I made an automated test for this, but its not suitable for automated
perf tests framework. It needs to be customized for each machine (the
more cpu the higher numbers for GROUPS/WORKERS/BYTES) and it could take
longer time to hit the issue. Adding at least a lkml link with test patch.

Link: http://lkml.kernel.org/r/20140910143535.GD2409@krava.brq.redhat.com
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5a09a09b2983..532670fbfe12 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2374,7 +2374,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	next_parent = rcu_dereference(next_ctx->parent_ctx);
 
 	/* If neither context have a parent context; they cannot be clones. */
-	if (!parent || !next_parent)
+	if (!parent && !next_parent)
 		goto unlock;
 
 	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {
-- 
1.8.3.1

