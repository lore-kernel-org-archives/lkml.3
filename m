Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaGKVAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:00:17 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:49646 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaGKVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:00:15 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH peterz-queue:locking/core 1/2] locking/rwsem: Fix building with opt spinning and new osq_lock header
Date: Fri, 11 Jul 2014 14:00:05 -0700
Message-Id: <1405112406-13052-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 'rwsem: Reduce the size of struct rw_semaphore' broke all
DECLARE_RWSEM users, ie:

init/init_task.c:14:44: error: ‘OSQ_UNLOCKED_VA’ undeclared here (not in a function)

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/rwsem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 0eff99c..5d40884 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 #endif
 
 #if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
-#define __RWSEM_OPT_INIT(lockname)	, .owner = NULL, .osq = { ATOMIC_INIT(OQS_UNLOCKED_VAL) }
+#define __RWSEM_OPT_INIT(lockname)	, .owner = NULL, .osq = { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }
 #else
 #define __RWSEM_OPT_INIT(lockname)
 #endif
-- 
1.8.1.4

