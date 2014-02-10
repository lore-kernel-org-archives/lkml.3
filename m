Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaBJNjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:39:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33172 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaBJNan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:30:43 -0500
Date: Mon, 10 Feb 2014 05:29:51 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-390f3258cb2d031f1c17aa32e771ebd336e89073@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <20140128072421.32315.25300.stgit@tkhai>
References: <20140128072421.32315.25300.stgit@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Skip in switched_to_dl()
  if task is current
Git-Commit-ID: 390f3258cb2d031f1c17aa32e771ebd336e89073
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:29:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  390f3258cb2d031f1c17aa32e771ebd336e89073
Gitweb:     http://git.kernel.org/tip/390f3258cb2d031f1c17aa32e771ebd336e89073
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Tue, 28 Jan 2014 11:26:14 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:31:48 +0100

sched/deadline: Skip in switched_to_dl() if task is current

When p is current and it's not of dl class, then there are no other
dl taks in the rq. If we had had pushable tasks in some other rq,
they would have been pushed earlier. So, skip "p == rq->curr" case.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Acked-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140128072421.32315.25300.stgit@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..b5700bc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1560,7 +1560,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (unlikely(p->dl.dl_throttled))
 		return;
 
-	if (p->on_rq || rq->curr != p) {
+	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
