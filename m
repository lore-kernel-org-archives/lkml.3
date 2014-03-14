Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaCNWRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:17:52 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:52988 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaCNWRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:17:51 -0400
X-Yandex-Uniq: 026d6364-69de-42e5-926a-8ed2dbd9061a
Authentication-Results: smtp14.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1394835295.18748.32.camel@HP-250-G1-Notebook-PC>
Subject: [PATCH 2/4] sched/rt: Add accessors rq_of_rt_se()
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Mar 2014 02:14:55 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two accessors for RT_GROUP_SCHED and !RT_GROUP_SCHED cases.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e4def13..93810d2 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -112,6 +112,13 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	return rt_se->rt_rq;
 }
 
+static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = rt_se->rt_rq;
+
+	return rt_rq->rq;
+}
+
 void free_rt_sched_group(struct task_group *tg)
 {
 	int i;
@@ -211,10 +218,16 @@ static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 	return container_of(rt_rq, struct rq, rt);
 }
 
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
 {
 	struct task_struct *p = rt_task_of(rt_se);
-	struct rq *rq = task_rq(p);
+
+	return task_rq(p);
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	struct rq *rq = rq_of_rt_se(rt_se);
 
 	return &rq->rt;
 }




