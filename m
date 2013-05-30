Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab3E3JEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:04:50 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51283 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967252Ab3E3JEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:04:43 -0400
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org
Subject: [PATCH -tip] sched/fair: Remove unused variable from expire_cfs_rq_runtime()
Date: Thu, 30 May 2013 14:34:20 +0530
Message-Id: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053008-7014-0000-0000-000003182149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

78becc2709 "sched: Use an accessor to read the rq clock"
introduces rq_clock(), which obsoletes use of "rq" in
expire_cfs_rq_runtime() and triggers build warning:

kernel/sched/fair.c: In function 'expire_cfs_rq_runtime':
kernel/sched/fair.c:2159:13: warning: unused variable 'rq' [-Wunused-variable]

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3ee1c2e..143dcdb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2156,7 +2156,6 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-	struct rq *rq = rq_of(cfs_rq);
 
 	/* if the deadline is ahead of our clock, nothing to do */
 	if (likely((s64)(rq_clock(rq_of(cfs_rq)) - cfs_rq->runtime_expires) < 0))
-- 
1.7.11.6

