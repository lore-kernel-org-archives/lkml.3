Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3FFCju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:39:50 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38902 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3FFCjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:39:49 -0400
Message-ID: <51AFF66E.1070602@linux.vnet.ibm.com>
Date: Thu, 06 Jun 2013 10:39:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 2/3] sched: code refine in unthrottle_cfs_rq()
References: <51AD87A8.6080608@linux.vnet.ibm.com> <51AD87EB.1070605@linux.vnet.ibm.com>
In-Reply-To: <51AD87EB.1070605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060602-5140-0000-0000-00000352D0CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
	re-based on latest tip/master

Directly use rq to save some code.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 143dcdb..0cea941 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2275,7 +2275,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct sched_entity *se;
 	long task_delta, dequeue = 1;
 
-	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+	se = cfs_rq->tg->se[cpu_of(rq)];
 
 	/* freeze hierarchy runnable averages while throttled */
 	rcu_read_lock();
-- 
1.7.4.1

