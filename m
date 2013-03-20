Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab3CTUPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:15:52 -0400
Received: from shelob.surriel.com ([74.92.59.67]:38948 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3CTUPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:15:51 -0400
From: Rik van Riel <riel@surriel.com>
To: torvalds@linux-foundation.org
Cc: davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/7] ipc: remove bogus lock comment for ipc_checkid
Date: Wed, 20 Mar 2013 15:55:31 -0400
Message-Id: <1363809337-29718-2-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

There is no reason to be holding the ipc lock while
reading ipcp->seq, hence remove misleading comment.

Also simplify the return value for the function.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/util.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/ipc/util.h b/ipc/util.h
index eeb79a1..ac1480a 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -150,14 +150,9 @@ static inline int ipc_buildid(int id, int seq)
 	return SEQ_MULTIPLIER * seq + id;
 }
 
-/*
- * Must be called with ipcp locked
- */
 static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 {
-	if (uid / SEQ_MULTIPLIER != ipcp->seq)
-		return 1;
-	return 0;
+	return uid / SEQ_MULTIPLIER != ipcp->seq;
 }
 
 static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
-- 
1.7.7.6

