Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaIXO5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:57:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59677 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaIXO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:57:47 -0400
Date: Wed, 24 Sep 2014 07:56:51 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-7a96c231ca23f0f5622852307df4209afc502ec3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140922183612.11015.64200.stgit@localhost>
References: <20140922183612.11015.64200.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Remove duplicate code from can_migrate_task()
Git-Commit-ID: 7a96c231ca23f0f5622852307df4209afc502ec3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a96c231ca23f0f5622852307df4209afc502ec3
Gitweb:     http://git.kernel.org/tip/7a96c231ca23f0f5622852307df4209afc502ec3
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 22 Sep 2014 22:36:12 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:07 +0200

sched/fair: Remove duplicate code from can_migrate_task()

Combine two branches which do the same.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140922183612.11015.64200.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8cb32f8..10a5a28 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5315,24 +5315,12 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
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
 
