Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBKMR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:17:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46541 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBKMR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:17:57 -0500
Date: Tue, 11 Feb 2014 04:17:20 -0800
From: tip-bot for Dietmar Eggemann <tipbot@zytor.com>
Message-ID: <tip-27f17580fd2c7514c8f5cce22ab903c6f3ddf458@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dietmar.eggemann@arm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1391005773-29493-1-git-send-email-dietmar.eggemann@arm.com>
References: <1391005773-29493-1-git-send-email-dietmar.eggemann@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Delete is_same_group()
  outside CONFIG_FAIR_GROUP_SCHED
Git-Commit-ID: 27f17580fd2c7514c8f5cce22ab903c6f3ddf458
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:17:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f17580fd2c7514c8f5cce22ab903c6f3ddf458
Gitweb:     http://git.kernel.org/tip/27f17580fd2c7514c8f5cce22ab903c6f3ddf458
Author:     Dietmar Eggemann <dietmar.eggemann@arm.com>
AuthorDate: Wed, 29 Jan 2014 14:29:33 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:16 +0100

sched: Delete is_same_group() outside CONFIG_FAIR_GROUP_SCHED

Since is_same_group() is only used in the group scheduling code, there is
no need to define it outside CONFIG_FAIR_GROUP_SCHED.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391005773-29493-1-git-send-email-dietmar.eggemann@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43b49fe..235cfa7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -415,12 +415,6 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
-static inline struct cfs_rq *
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
-{
-	return cfs_rq_of(se); /* always the same rq */
-}
-
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
 {
 	return NULL;
