Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaB0Nck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:32:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaB0Nch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:32:37 -0500
Date: Thu, 27 Feb 2014 05:31:45 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-3908ac13b550c93f97d8db136ff572be5495bc06@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <1393343543.4089.5.camel@tkhai>
References: <1393343543.4089.5.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline: Cleanup RT leftovers from {inc
 /dec}_dl_migration
Git-Commit-ID: 3908ac13b550c93f97d8db136ff572be5495bc06
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

Commit-ID:  3908ac13b550c93f97d8db136ff572be5495bc06
Gitweb:     http://git.kernel.org/tip/3908ac13b550c93f97d8db136ff572be5495bc06
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Tue, 25 Feb 2014 19:52:23 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:29:39 +0100

sched/deadline: Cleanup RT leftovers from {inc/dec}_dl_migration

In deadline class we do not have group scheduling.

So, let's remove unnecessary

	X = X;

equations.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Link: http://lkml.kernel.org/r/1393343543.4089.5.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 15cbc17..aecf930 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -135,7 +135,6 @@ static void update_dl_migration(struct dl_rq *dl_rq)
 static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
 	struct task_struct *p = dl_task_of(dl_se);
-	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory++;
@@ -146,7 +145,6 @@ static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
 	struct task_struct *p = dl_task_of(dl_se);
-	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory--;
