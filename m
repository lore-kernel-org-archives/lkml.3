Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaIVSc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:32:28 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:44719 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaIVScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:32:25 -0400
X-Yandex-Uniq: dcf6ebe7-df2b-4c46-9737-912ab4e33f09
Authentication-Results: smtp2h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 4/6] sched: cleanup: Rename out_unlock to
 out_free_new_mask
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Date: Mon, 22 Sep 2014 22:32:22 +0400
Message-ID: <20140922183222.10761.74095.stgit@localhost>
In-Reply-To: <20140922183202.10761.6682.stgit@localhost>
References: <20140922183202.10761.6682.stgit@localhost>
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
index a300fce..3b07710 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4003,14 +4003,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
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
@@ -4028,7 +4028,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 
 		if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
 			retval = -EBUSY;
-			goto out_unlock;
+			goto out_free_new_mask;
 		}
 	}
 #endif
@@ -4047,7 +4047,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 			goto again;
 		}
 	}
-out_unlock:
+out_free_new_mask:
 	free_cpumask_var(new_mask);
 out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);

