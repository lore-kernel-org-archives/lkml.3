Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaI3VEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:04:50 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:47039 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaI3VEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:04:47 -0400
X-Yandex-Uniq: f7825946-1e68-42c6-9dc3-9034351cbef9
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 3/3] sched/fair: Delete resched_cpu() from idle_balance()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Date: Wed, 01 Oct 2014 01:04:44 +0400
Message-ID: <20140930210441.5258.55054.stgit@localhost>
In-Reply-To: <20140930210412.5258.35299.stgit@localhost>
References: <20140930210412.5258.35299.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

We already reschedule env.dst_cpu in attach_tasks()->check_preempt_curr()
if this is necessary.

Furthermore, a higher priority class task may be current on dest rq,
we shouldn't disturb it.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 10a5a28..8265601 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6700,12 +6700,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 		local_irq_restore(flags);
 
-		/*
-		 * some other cpu did the load balance for us.
-		 */
-		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
-			resched_cpu(env.dst_cpu);
-
 		if (env.flags & LBF_NEED_BREAK) {
 			env.flags &= ~LBF_NEED_BREAK;
 			goto more_balance;

