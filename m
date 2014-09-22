Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaIVScl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:32:41 -0400
Received: from forward6l.mail.yandex.net ([84.201.143.139]:40500 "EHLO
	forward6l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaIVSci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:32:38 -0400
X-Yandex-Uniq: db1e7b87-c6d4-4088-aae7-36837f2ae7c9
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 6/6] sched/rt: Use resched_curr() in task_tick_rt()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Mon, 22 Sep 2014 22:32:35 +0400
Message-ID: <20140922183235.10761.49644.stgit@localhost>
In-Reply-To: <20140922183202.10761.6682.stgit@localhost>
References: <20140922183202.10761.6682.stgit@localhost>
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
index de356b0..c322071 100644
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

