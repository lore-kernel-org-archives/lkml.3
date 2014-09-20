Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbaITQvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:51:21 -0400
Received: from forward7l.mail.yandex.net ([84.201.143.140]:41247 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaITQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:51:20 -0400
X-Yandex-Uniq: f9d16d1f-2513-4120-93b9-e0c75f948d6b
Authentication-Results: smtp12.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 1/7] sched/fair: Remove duplicate code from
 can_migrate_task()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Sat, 20 Sep 2014 20:51:16 +0400
Message-ID: <20140920165116.16299.1381.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

Two branches do the same, so we can combine them and get
rid of duplicate code.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 74fa2c2..fa13f94 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5292,24 +5292,12 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
-	if (migrate_improves_locality(p, env)) {
-#ifdef CONFIG_SCHEDSTATS
+	if (migrate_improves_locality(p, env) || !tsk_cache_hot ||
+	    env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 		if (tsk_cache_hot) {
 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
-#endif
-		return 1;
-	}
-
-	if (!tsk_cache_hot ||
-		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
-
-		if (tsk_cache_hot) {
-			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
-			schedstat_inc(p, se.statistics.nr_forced_migrations);
-		}
-
 		return 1;
 	}
 

