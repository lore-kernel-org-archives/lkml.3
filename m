Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaEMU2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:28:09 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:49076 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaEMU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:27:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: manfred@colorfullife.com, akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ipc,msg: use current->state helpers
Date: Tue, 13 May 2014 13:27:33 -0700
Message-Id: <1400012857-11733-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __set_current_state() instead of assigning
the new state directly.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 7ed1ef3..5a8489b 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -227,7 +227,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 static inline void ss_add(struct msg_queue *msq, struct msg_sender *mss)
 {
 	mss->tsk = current;
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	list_add_tail(&mss->list, &msq->q_senders);
 }
 
@@ -976,7 +976,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 		else
 			msr_d.r_maxsize = bufsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 
 		ipc_unlock_object(&msq->q_perm);
 		rcu_read_unlock();
-- 
1.8.1.4

