Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaIXO6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:58:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaIXO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:58:08 -0400
Date: Wed, 24 Sep 2014 07:57:19 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-16303ab2fe214635240a8f57cad2cd29792d4e3b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140922183630.11015.59500.stgit@localhost>
References: <20140922183630.11015.59500.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: cleanup: Rename 'out_unlock' to '
 out_free_new_mask'
Git-Commit-ID: 16303ab2fe214635240a8f57cad2cd29792d4e3b
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

Commit-ID:  16303ab2fe214635240a8f57cad2cd29792d4e3b
Gitweb:     http://git.kernel.org/tip/16303ab2fe214635240a8f57cad2cd29792d4e3b
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 22 Sep 2014 22:36:30 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:10 +0200

sched: cleanup: Rename 'out_unlock' to 'out_free_new_mask'

Nothing is locked there, so label's name only confuses a reader.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140922183630.11015.59500.stgit@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f0adb03..316127a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4029,14 +4029,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 		rcu_read_lock();
 		if (!ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE)) {
 			rcu_read_unlock();
-			goto out_unlock;
+			goto out_free_new_mask;
 		}
 		rcu_read_unlock();
 	}
 
 	retval = security_task_setscheduler(p);
 	if (retval)
-		goto out_unlock;
+		goto out_free_new_mask;
 
 
 	cpuset_cpus_allowed(p, cpus_allowed);
@@ -4054,7 +4054,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 
 		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
 			retval = -EBUSY;
-			goto out_unlock;
+			goto out_free_new_mask;
 		}
 	}
 #endif
@@ -4073,7 +4073,7 @@ again:
 			goto again;
 		}
 	}
-out_unlock:
+out_free_new_mask:
 	free_cpumask_var(new_mask);
 out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);
