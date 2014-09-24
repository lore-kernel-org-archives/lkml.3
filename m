Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaIXPG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:06:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIXO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:56:56 -0400
Date: Wed, 24 Sep 2014 07:55:52 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-8651c65844e93af44554272b7e0d2b142837b244@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, umgwanakikbuti@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20140921193336.GA28618@redhat.com>
References: <20140921193336.GA28618@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Fix the task-group check in tg_has_rt_tasks()
Git-Commit-ID: 8651c65844e93af44554272b7e0d2b142837b244
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

Commit-ID:  8651c65844e93af44554272b7e0d2b142837b244
Gitweb:     http://git.kernel.org/tip/8651c65844e93af44554272b7e0d2b142837b244
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 21 Sep 2014 21:33:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:00 +0200

sched: Fix the task-group check in tg_has_rt_tasks()

tg_has_rt_tasks() wants to find an RT task in this task_group, but
task_rq(p)->rt.tg wrongly checks the root rt_rq.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Link: http://lkml.kernel.org/r/20140921193336.GA28618@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 09bde2a..0abfb7e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7441,7 +7441,7 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 	struct task_struct *g, *p;
 
 	for_each_process_thread(g, p) {
-		if (rt_task(p) && task_rq(p)->rt.tg == tg)
+		if (rt_task(p) && task_group(p) == tg)
 			return 1;
 	}
 
