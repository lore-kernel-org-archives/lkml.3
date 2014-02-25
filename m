Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaBYPwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:52:34 -0500
Received: from relay.parallels.com ([195.214.232.42]:37645 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaBYPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:52:30 -0500
Message-ID: <1393343543.4089.5.camel@tkhai>
Subject: [PATCH] sched/deadline: Cleanup RT leftovers from
 {inc/dec}_dl_migration
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <juri.lelli@gmail.com>, <peterz@infradead.org>, <mingo@redhat.com>
Date: Tue, 25 Feb 2014 19:52:23 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In deadline class we do not have group scheduling.

So, let's remove unnecessary

	X = X;

equations.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/sched/deadline.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ef96edc..2c28437 100644
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



