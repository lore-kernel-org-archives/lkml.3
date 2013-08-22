Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3HVHyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:54:08 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41324 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3HVHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:54:06 -0400
Message-ID: <5215C396.4000400@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:53:58 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/11] sched/cleanup: refine rt_policy()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-9574-0000-0000-000009490927
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine the rt_policy() to save few lines.

CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/sched.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4c1cb80..b557f39 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -82,9 +82,7 @@ extern void update_cpu_load_active(struct rq *this_rq);
 
 static inline int rt_policy(int policy)
 {
-	if (policy == SCHED_FIFO || policy == SCHED_RR)
-		return 1;
-	return 0;
+	return policy == SCHED_FIFO || policy == SCHED_RR;
 }
 
 static inline int task_has_rt_policy(struct task_struct *p)
-- 
1.7.9.5

