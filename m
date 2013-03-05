Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3CEJgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:36:04 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:32317 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3CEJgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:36:01 -0500
Message-ID: <1362476157.2225.51.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2 1/4] ipc: remove bogus lock comment for ipc_checkid
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 05 Mar 2013 01:35:57 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to be holding the ipc lock while
reading ipcp->seq, hence remove misleading comment.

Also simplify the return value for the function.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/util.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

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
1.7.11.7





