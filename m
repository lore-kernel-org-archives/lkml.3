Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630Ab3JPSH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:07:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572Ab3JPRqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 62/69] ipc: drop ipc_lock_check
Date: Wed, 16 Oct 2013 10:45:11 -0700
Message-Id: <20131016174320.480469131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 20b8875abcf2daa1dda5cf70bd6369df5e85d4c1 upstream.

No remaining users, we now use ipc_obtain_object_check().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/util.c |   16 ----------------
 ipc/util.h |    1 -
 2 files changed, 17 deletions(-)

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
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -177,7 +177,6 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);


