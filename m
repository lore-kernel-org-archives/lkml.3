Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaCWTH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:07:29 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38028 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaCWTH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:07:28 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/sched: Use RCU_INIT_POINTER(x, NULL) in fair.c
Date: Mon, 24 Mar 2014 00:36:27 +0530
Message-Id: <1395601588-12178-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b4c4f3..13b66aa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1573,7 +1573,7 @@ void task_numa_free(struct task_struct *p)
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock(&grp->lock);
-		rcu_assign_pointer(p->numa_group, NULL);
+		RCU_INIT_POINTER(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
 
-- 
1.7.9.5

