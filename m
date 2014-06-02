Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaFBUiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:38:51 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFBUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:38:50 -0400
From: Richard Weinberger <richard@nod.at>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] sched: Fix sched_policy < 0 comparison
Date: Mon,  2 Jun 2014 22:38:34 +0200
Message-Id: <1401741514-7045-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

attr.sched_policy is u32, therefore a comparison against < 0 is never true.
Fix this by casting sched_policy to int.

This issue was reported by coverity CID 1219934.

Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b8cd08f..d579476 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3726,7 +3726,7 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (retval)
 		return retval;
 
-	if (attr.sched_policy < 0)
+	if ((int)attr.sched_policy < 0)
 		return -EINVAL;
 
 	rcu_read_lock();
-- 
1.8.1.4

