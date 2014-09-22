Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaIVSgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:36:17 -0400
Received: from forward2l.mail.yandex.net ([84.201.143.145]:38953 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaIVSgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:36:16 -0400
X-Yandex-Uniq: e2f82151-9789-4917-8047-fda6ec6a32d0
Authentication-Results: smtp4o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v3 1/6] sched/fair: Remove duplicate code from
 can_migrate_task()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Mon, 22 Sep 2014 22:36:12 +0400
Message-ID: <20140922183612.11015.64200.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

Combine two branches which do the same.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a1e6ac..420bc98 100644
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
 

