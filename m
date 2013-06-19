Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab3FSSlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:41:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3FSSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:41:44 -0400
Date: Wed, 19 Jun 2013 11:39:42 -0700
From: tip-bot for Michael Wang <tipbot@zytor.com>
Message-ID: <tip-22b958d8cc5127d22d2ad2141277d312d93fad6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <51AD87EB.1070605@linux.vnet.ibm.com>
References: <51AD87EB.1070605@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Refine the code in unthrottle_cfs_rq()
Git-Commit-ID: 22b958d8cc5127d22d2ad2141277d312d93fad6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:39:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22b958d8cc5127d22d2ad2141277d312d93fad6c
Gitweb:     http://git.kernel.org/tip/22b958d8cc5127d22d2ad2141277d312d93fad6c
Author:     Michael Wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Tue, 4 Jun 2013 14:23:39 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:41 +0200

sched: Refine the code in unthrottle_cfs_rq()

Directly use rq to save some code.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51AD87EB.1070605@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 143dcdb..47a30be 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2315,7 +2315,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	int enqueue = 1;
 	long task_delta;
 
-	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+	se = cfs_rq->tg->se[cpu_of(rq)];
 
 	cfs_rq->throttled = 0;
 
