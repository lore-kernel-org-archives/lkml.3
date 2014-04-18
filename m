Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaDRNIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:08:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaDRNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:08:01 -0400
Date: Fri, 18 Apr 2014 06:07:14 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-653d07a6989a9a4166dcd1025aa252b3605737fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tkhai@yandex.ru, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tkhai@yandex.ru, tglx@linutronix.de
In-Reply-To: <1394835295.18748.32.camel@HP-250-G1-Notebook-PC>
References: <1394835295.18748.32.camel@HP-250-G1-Notebook-PC>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Add accessors rq_of_rt_se()
Git-Commit-ID: 653d07a6989a9a4166dcd1025aa252b3605737fd
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

Commit-ID:  653d07a6989a9a4166dcd1025aa252b3605737fd
Gitweb:     http://git.kernel.org/tip/653d07a6989a9a4166dcd1025aa252b3605737fd
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Sat, 15 Mar 2014 02:14:55 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:07:27 +0200

sched/rt: Add accessors rq_of_rt_se()

Two accessors for RT_GROUP_SCHED and !RT_GROUP_SCHED cases.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1394835295.18748.32.camel@HP-250-G1-Notebook-PC
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 6892ed7..f6aa3cd 100644
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
