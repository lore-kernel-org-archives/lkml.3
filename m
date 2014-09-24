Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaIXO7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:59:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaIXO7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:59:35 -0400
Date: Wed, 24 Sep 2014 07:58:43 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-802c8a61d4c9c794db863dcabb0006ab001a651b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, jolsa@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <20140910143535.GD2409@krava.brq.redhat.com>
References: <20140910143535.GD2409@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "perf:
  Do not allow optimized switch for non-cloned events"
Git-Commit-ID: 802c8a61d4c9c794db863dcabb0006ab001a651b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  802c8a61d4c9c794db863dcabb0006ab001a651b
Gitweb:     http://git.kernel.org/tip/802c8a61d4c9c794db863dcabb0006ab001a651b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 12 Sep 2014 13:18:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:13 +0200

Revert "perf: Do not allow optimized switch for non-cloned events"

This reverts commit 1f9a7268c67f0290837aada443d28fd953ddca90.

With the fix of the initial state for the cloned event we now correctly
handle the error described in:

  1f9a7268c67f perf: Do not allow optimized switch for non-cloned events

so we can revert it.

I made an automated test for this, but its not suitable for automated
perf tests framework. It needs to be customized for each machine (the
more cpu the higher numbers for GROUPS/WORKERS/BYTES) and it could take
longer time to hit the issue.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140910143535.GD2409@krava.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 132524c..b164cb0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2375,7 +2375,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	next_parent = rcu_dereference(next_ctx->parent_ctx);
 
 	/* If neither context have a parent context; they cannot be clones. */
-	if (!parent || !next_parent)
+	if (!parent && !next_parent)
 		goto unlock;
 
 	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {
