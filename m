Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaISLqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:46:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaISLqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:46:34 -0400
Date: Fri, 19 Sep 2014 04:45:45 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f3f1768f89d601ad29f4701deef91caaa82b9f57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1410529321.3569.26.camel@tkhai>
References: <1410529321.3569.26.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Remove useless if from cleanup pick_next_task_rt()
Git-Commit-ID: f3f1768f89d601ad29f4701deef91caaa82b9f57
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

Commit-ID:  f3f1768f89d601ad29f4701deef91caaa82b9f57
Gitweb:     http://git.kernel.org/tip/f3f1768f89d601ad29f4701deef91caaa82b9f57
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Fri, 12 Sep 2014 17:42:01 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:20 +0200

sched/rt: Remove useless if from cleanup pick_next_task_rt()

_pick_next_task_rt() never returns NULL.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1410529321.3569.26.camel@tkhai
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4feac8f..2e6a774 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1468,8 +1468,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
-	if (p)
-		dequeue_pushable_task(rq, p);
+	dequeue_pushable_task(rq, p);
 
 	set_post_schedule(rq);
 
