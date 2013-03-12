Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab3CLTMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:12:50 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33923 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3CLTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:12:49 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] kernel:sched: renamed max_vruntime parameter
Date: Tue, 12 Mar 2013 21:12:24 +0200
Message-Id: <1363115544-1964-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min_vruntime variable actually stores the maximum value.
The added comment was taken from place_entity function.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 kernel/sched/fair.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..ff4cffb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -431,13 +431,13 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
  * Scheduling class tree data structure manipulation methods:
  */
 
-static inline u64 max_vruntime(u64 min_vruntime, u64 vruntime)
+static inline u64 max_vruntime(u64 max_vruntime, u64 vruntime)
 {
-	s64 delta = (s64)(vruntime - min_vruntime);
+	s64 delta = (s64)(vruntime - max_vruntime);
 	if (delta > 0)
-		min_vruntime = vruntime;
+		max_vruntime = vruntime;
 
-	return min_vruntime;
+	return max_vruntime;
 }
 
 static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
@@ -473,6 +473,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
+	/* ensure we never gain time by being placed backwards. */
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
 #ifndef CONFIG_64BIT
 	smp_wmb();
-- 
1.7.9.5

