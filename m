Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbaITQvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:51:41 -0400
Received: from forward3l.mail.yandex.net ([84.201.143.136]:37558 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaITQvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:51:38 -0400
X-Yandex-Uniq: 1d0ea976-f515-466f-b625-bf59916ac962
Authentication-Results: smtp3h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 4/7] sched: cleanup: Rename out_unlock to out_free_new_mask
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Sat, 20 Sep 2014 20:51:34 +0400
Message-ID: <20140920165134.16299.28148.stgit@localhost>
In-Reply-To: <20140920165116.16299.1381.stgit@localhost>
References: <20140920165116.16299.1381.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

Nothing is locked there, so label's name only confuses a reader.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 00a024c..65655a887 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3995,14 +3995,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
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
@@ -4020,7 +4020,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 
 		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
 			retval = -EBUSY;
-			goto out_unlock;
+			goto out_free_new_mask;
 		}
 	}
 #endif
@@ -4039,7 +4039,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 			goto again;
 		}
 	}
-out_unlock:
+out_free_new_mask:
 	free_cpumask_var(new_mask);
 out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);

