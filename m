Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3EPBI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:27 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9558 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3EPBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:17 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 11/11] ipc: remove unused functions
Date: Wed, 15 May 2013 18:08:10 -0700
Message-Id: <1368666490-29055-12-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can now drop the msg_lock and msg_lock_check functions along
with a bogus comment introduced previously in semctl_down.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/msg.c | 25 -------------------------
 ipc/sem.c |  1 -
 2 files changed, 26 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 1654be4..3b7b4b5 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -141,31 +141,6 @@ void __init msg_init(void)
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
 }
 
-/*
- * msg_lock_(check_) routines are called in the paths where the rw_mutex
- * is not held.
- */
-static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock(&msg_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct msg_queue *)ipcp;
-
-	return container_of(ipcp, struct msg_queue, q_perm);
-}
-
-static inline struct msg_queue *msg_lock_check(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&msg_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct msg_queue *)ipcp;
-
-	return container_of(ipcp, struct msg_queue, q_perm);
-}
-
 static inline struct msg_queue *msq_obtain_object(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_obtain_object(&msg_ids(ns), id);
diff --git a/ipc/sem.c b/ipc/sem.c
index f7d99f9..8223f17 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1281,7 +1281,6 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 				      &semid64.sem_perm, 0);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
-		/* the ipc lock is not held upon failure */
 		goto out_unlock1;
 	}
 
-- 
1.7.11.7

