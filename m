Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaCBSnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 13:43:00 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57471 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaCBSm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 13:42:59 -0500
From: Reiter Wolfgang <wr0112358@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Reiter Wolfgang <wr0112358@gmail.com>
Subject: [PATCH 1/1] sched/deadline: Fix regression in cpudl_find.
Date: Sun,  2 Mar 2014 19:42:53 +0100
Message-Id: <1393785773-24355-1-git-send-email-wr0112358@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using CONFIG_FTRACE_SELFTEST=y and CONFIG_FTRACE_STARTUP_TEST=y
best_cpu is -1 and passed to function cpumask_check which takes
unsigned int.
Fix order of test arguments to avoid oops.
Regression was introduced in commit 82b95800b256205cff2eeab5bbd03430d2d0f20d.

Signed-off-by: Reiter Wolfgang <wr0112358@gmail.com>
---
 kernel/sched/cpudeadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b8838b..a8571e0 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -117,7 +117,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	}
 
 out:
-	WARN_ON(!cpu_present(best_cpu) && best_cpu != -1);
+	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
 
 	return best_cpu;
 }
-- 
1.8.5.3

