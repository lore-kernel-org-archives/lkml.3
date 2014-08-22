Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbaHVOux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:50:53 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55018 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbaHVOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:50:52 -0400
Date: Fri, 22 Aug 2014 17:50:43 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [RESEND PATCH] kernel: sched: fair: Replace rcu_assign_pointer()
 with RCU_INIT_POINTER()
Message-ID: <20140822145043.GA580@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..7d4f743 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1759,7 +1759,7 @@ void task_numa_free(struct task_struct *p)
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock_irqrestore(&grp->lock, flags);
-		rcu_assign_pointer(p->numa_group, NULL);
+		RCU_INIT_POINTER(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
 
-- 
1.9.1

