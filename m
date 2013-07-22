Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3GVBWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:22:39 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:15993 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3GVBVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:21:55 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 3/4] ipc, shm: drop shm_lock_check
Date: Sun, 21 Jul 2013 18:21:42 -0700
Message-Id: <1374456103-25353-4-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
References: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was replaced by a the lockless shm_obtain_object_check(),
and no longer has any users.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/shm.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index c7ee2f6..9ffc563 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -167,17 +167,6 @@ static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
 	ipc_lock_object(&ipcp->shm_perm);
 }
 
-static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct shmid_kernel *)ipcp;
-
-	return container_of(ipcp, struct shmid_kernel, shm_perm);
-}
-
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
-- 
1.7.11.7

