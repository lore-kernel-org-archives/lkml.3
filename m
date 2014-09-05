Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaIEGRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:17:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaIEGRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:17:50 -0400
Date: Thu, 4 Sep 2014 23:16:01 -0700
From: tip-bot for Andreea-Cristina Bernat <tipbot@zytor.com>
Message-ID: <tip-35b123e2f701b28977db2cde7dbbdb3fad28cad1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, bernat.ada@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, bernat.ada@gmail.com
In-Reply-To: <20140822145043.GA580@ada>
References: <20140822145043.GA580@ada>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Replace rcu_assign_pointer()
  with RCU_INIT_POINTER()
Git-Commit-ID: 35b123e2f701b28977db2cde7dbbdb3fad28cad1
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

Commit-ID:  35b123e2f701b28977db2cde7dbbdb3fad28cad1
Gitweb:     http://git.kernel.org/tip/35b123e2f701b28977db2cde7dbbdb3fad28cad1
Author:     Andreea-Cristina Bernat <bernat.ada@gmail.com>
AuthorDate: Fri, 22 Aug 2014 17:50:43 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Sep 2014 08:11:57 +0200

sched/fair: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:

  "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"

it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
 @@
 @@

 - rcu_assign_pointer
 + RCU_INIT_POINTER
   (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140822145043.GA580@ada
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d3427a8..02fc949 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1780,7 +1780,7 @@ void task_numa_free(struct task_struct *p)
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock_irqrestore(&grp->lock, flags);
-		rcu_assign_pointer(p->numa_group, NULL);
+		RCU_INIT_POINTER(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
 
