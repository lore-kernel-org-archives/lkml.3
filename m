Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab3BTIWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:22:03 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63515 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652Ab3BTIWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:22:01 -0500
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH V2] sched/core: remove obsolete nr_uninterruptible()
Date: Wed, 20 Feb 2013 16:21:23 +0800
Message-Id: <1361348483-7352-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361345873-6440-1-git-send-email-handai.szj@taobao.com>
References: <1361345873-6440-1-git-send-email-handai.szj@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 kernel/sched/core.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 03d7784..b7b03cd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1969,11 +1969,10 @@ context_switch(struct rq *rq, struct task_struct *prev,
 }
 
 /*
- * nr_running, nr_uninterruptible and nr_context_switches:
+ * nr_running and nr_context_switches:
  *
  * externally visible scheduler statistics: current number of runnable
- * threads, current number of uninterruptible-sleeping threads, total
- * number of context switches performed since bootup.
+ * threads, total number of context switches performed since bootup.
  */
 unsigned long nr_running(void)
 {
@@ -1985,23 +1984,6 @@ unsigned long nr_running(void)
 	return sum;
 }
 
-unsigned long nr_uninterruptible(void)
-{
-	unsigned long i, sum = 0;
-
-	for_each_possible_cpu(i)
-		sum += cpu_rq(i)->nr_uninterruptible;
-
-	/*
-	 * Since we read the counters lockless, it might be slightly
-	 * inaccurate. Do not allow it to go below zero though:
-	 */
-	if (unlikely((long)sum < 0))
-		sum = 0;
-
-	return sum;
-}
-
 unsigned long long nr_context_switches(void)
 {
 	int i;
-- 
1.7.9.5

