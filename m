Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbaITQv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:51:59 -0400
Received: from forward2l.mail.yandex.net ([84.201.143.145]:35714 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbaITQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:51:56 -0400
X-Yandex-Uniq: a56c8266-a2df-438c-b259-1a697de57453
Authentication-Results: smtp2o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 7/7] sched/rt: Use resched_curr() in task_tick_rt()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Sat, 20 Sep 2014 20:51:52 +0400
Message-ID: <20140920165152.16299.32805.stgit@localhost>
In-Reply-To: <20140920165116.16299.1381.stgit@localhost>
References: <20140920165116.16299.1381.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

Some time ago PREEMPT_NEED_RESCHED was implemented,
so reschedule technics is a little more difficult now.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 828eda0..8c7ba1e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2077,7 +2077,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	for_each_sched_rt_entity(rt_se) {
 		if (rt_se->run_list.prev != rt_se->run_list.next) {
 			requeue_task_rt(rq, p, 0);
-			set_tsk_need_resched(p);
+			resched_curr(rq);
 			return;
 		}
 	}

