Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaEHKpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:45:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaEHKpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:45:40 -0400
Date: Thu, 8 May 2014 03:44:57 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-426egt8zmsm12d2q8k2xz4tt@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Always destroy groups on exit
Git-Commit-ID: 15a2d4de0eab533a76bee9e68d7e1063dd25401c
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

Commit-ID:  15a2d4de0eab533a76bee9e68d7e1063dd25401c
Gitweb:     http://git.kernel.org/tip/15a2d4de0eab533a76bee9e68d7e1063dd25401c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 May 2014 11:41:02 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:44:18 +0200

perf: Always destroy groups on exit

Commit 38b435b16c36 ("perf: Fix tear-down of inherited group events")
states that we need to destroy groups for inherited events, but it
doesn't make any sense to not also destroy groups for normal events.

And while it usually makes no difference (the normal events won't
leak, and its very likely all the group events will die in quick
succession) it does make the code more consistent and closes a
potential hole for trouble.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-426egt8zmsm12d2q8k2xz4tt@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1de0d70..819ffc0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7400,7 +7400,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	perf_remove_from_context(child_event, !!child_event->parent);
+	perf_remove_from_context(child_event, true);
 
 	/*
 	 * It can happen that the parent exits first, and has events
