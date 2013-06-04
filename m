Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab3FDGXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:23:49 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33722 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3FDGXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:23:47 -0400
Message-ID: <51AD87EB.1070605@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 14:23:39 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/3] sched: code refine in unthrottle_cfs_rq()
References: <51AD87A8.6080608@linux.vnet.ibm.com>
In-Reply-To: <51AD87A8.6080608@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060406-9574-0000-0000-000008256399
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly use rq to save some code.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..1e10911 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2298,7 +2298,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	int enqueue = 1;
 	long task_delta;
 
-	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+	se = cfs_rq->tg->se[cpu_of(rq)];
 
 	cfs_rq->throttled = 0;
 	raw_spin_lock(&cfs_b->lock);
-- 
1.7.4.1

