Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab3DJGGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:06:04 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31595 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3DJGGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:06:01 -0400
Message-ID: <51650107.9040606@huawei.com>
Date: Wed, 10 Apr 2013 14:04:55 +0800
From: Zhang Hang <bob.zhanghang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Remove redundant code from can_migrate_task()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.174]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no opportunity to return 1 if tsk_cache_hot is true and the expression
(env->sd->nr_balance_failed > env->sd->cache_nice_tries) is false.
Meanwhile, it's unnecessary to judge whether tsk_cache_hot is true or
false after being filtered by previous judgment.

Signed-off-by: Zhang Hang <bob.zhanghang@huawei.com>
---
 kernel/sched/fair.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..4f7e1d0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3929,11 +3929,8 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 		return 1;
 	}

-	if (tsk_cache_hot) {
-		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
-		return 0;
-	}
-	return 1;
+	schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
+	return 0;
 }

 /*
-- 
1.7.8.6

