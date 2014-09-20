Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaITQvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:51:52 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:56301 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbaITQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:51:50 -0400
X-Yandex-Uniq: 3655ec06-0805-48bb-851a-9f5a665d28a7
Authentication-Results: smtp13.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 6/7] sched: Delete rq::skip_clock_update == -1
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Sat, 20 Sep 2014 20:51:46 +0400
Message-ID: <20140920165146.16299.20907.stgit@localhost>
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

Idle class task is always queued, so we can safely remove "-1" case here.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |    2 +-
 kernel/sched/rt.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a40d6e1..7d0d023 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2812,7 +2812,7 @@ static void __sched __schedule(void)
 		switch_count = &prev->nvcsw;
 	}
 
-	if (task_on_rq_queued(prev) || rq->skip_clock_update < 0)
+	if (task_on_rq_queued(prev))
 		update_rq_clock(rq);
 
 	next = pick_next_task(rq, prev);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index de356b0..828eda0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -835,7 +835,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 				 * lest wakeup -> unthrottle time accumulate.
 				 */
 				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
-					rq->skip_clock_update = -1;
+					rq->skip_clock_update = 0;
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;

