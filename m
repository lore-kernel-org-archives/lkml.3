Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaHTIV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:21:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47002 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaHTIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:21:24 -0400
Date: Wed, 20 Aug 2014 01:19:33 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-5aface53d1a0ef7823215c4078fca8445995d006@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, seto.hidetoshi@jp.fujitsu.com,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        fmayhar@google.com, akpm@linux-foundation.org, srao@redhat.com,
        fweisbec@redhat.com, tglx@linutronix.de, oleg@redhat.com,
        lwoodman@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, torvalds@linux-foundation.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com, riel@redhat.com,
        fmayhar@google.com, akpm@linux-foundation.org, fweisbec@redhat.com,
        srao@redhat.com, oleg@redhat.com, tglx@linutronix.de,
        lwoodman@redhat.com
In-Reply-To: <20140813192003.GA19334@redhat.com>
References: <20140813192003.GA19334@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Change autogroup_move_group()
  to use for_each_thread()
Git-Commit-ID: 5aface53d1a0ef7823215c4078fca8445995d006
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

Commit-ID:  5aface53d1a0ef7823215c4078fca8445995d006
Gitweb:     http://git.kernel.org/tip/5aface53d1a0ef7823215c4078fca8445995d006
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 13 Aug 2014 21:20:03 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 09:47:18 +0200

sched: Change autogroup_move_group() to use for_each_thread()

Change autogroup_move_group() to use for_each_thread() instead of
buggy while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Frank Mayhar <fmayhar@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sanjay Rao <srao@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140813192003.GA19334@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/auto_group.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index e73efba..8a2e230 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -148,11 +148,8 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
 		goto out;
 
-	t = p;
-	do {
+	for_each_thread(p, t)
 		sched_move_task(t);
-	} while_each_thread(p, t);
-
 out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
