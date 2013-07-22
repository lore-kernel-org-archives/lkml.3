Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3GVBV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:21:58 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:18771 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3GVBV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:21:56 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 4/4] ipc: drop ipc_lock_check
Date: Sun, 21 Jul 2013 18:21:43 -0700
Message-Id: <1374456103-25353-5-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
References: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No remaining users, we now use ipc_obtain_object_check().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/util.c | 16 ----------------
 ipc/util.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 9f6aa30..e829da9 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -686,22 +686,6 @@ out:
 	return out;
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-
-	out = ipc_lock(ids, id);
-	if (IS_ERR(out))
-		return out;
-
-	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
-		return ERR_PTR(-EIDRM);
-	}
-
-	return out;
-}
-
 /**
  * ipcget - Common sys_*get() code
  * @ns : namsepace
diff --git a/ipc/util.h b/ipc/util.h
index 14b0a2a..c5f3338b 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -177,7 +177,6 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
 	rcu_read_unlock();
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
-- 
1.7.11.7

