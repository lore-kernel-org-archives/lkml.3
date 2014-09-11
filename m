Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaIKAsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:48:16 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51123 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaIKAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:48:15 -0400
From: roy.qing.li@gmail.com
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be,
        jkosina@suse.cz, paulmck@linux.vnet.ibm.com, richard@nod.at,
        oleg@redhat.com, akpm@linux-foundation.org
Subject: [RFC][PATCH] signal: replace !likely with unlikely!
Date: Thu, 11 Sep 2014 08:48:16 +0800
Message-Id: <1410396496-13845-1-git-send-email-roy.qing.li@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li RongQing <roy.qing.li@gmail.com> 

!likely() is hard to be understood, and I do not know if compiler can
optimise this condition, but unlikely(!()) is clear

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f..6156cfa 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1571,7 +1571,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
 	ret = -1;
-	if (!likely(lock_task_sighand(t, &flags)))
+	if (unlikely(!lock_task_sighand(t, &flags)))
 		goto ret;
 
 	ret = 1; /* the signal is ignored */
-- 
1.7.10.4

