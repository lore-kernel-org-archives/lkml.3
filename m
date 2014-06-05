Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaFEUts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:49:48 -0400
Received: from mxip3-inbound.gatech.edu ([130.207.182.45]:13942 "EHLO
	mxip3-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaFEUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:49:46 -0400
X-RemoteIP: 130.207.185.162
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 92163964
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.98,983,1392181200"; 
   d="scan'208";a="92163964"
X-GT-Spam-Rating: (0%)
Message-ID: <5390D7E1.7060606@gatech.edu>
Date: Thu, 05 Jun 2014 16:49:37 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com, davidlohr@hp.com,
        mingo@redhat.com
Subject: [RFC PATCH 1/1] cleanup: use bool as return type for rwsem_is_locked
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see that there are functions like this which basically say:

return 1 if true else return 0. Is it worth cleaning them up? Or is there any reason why this convention is followed?

use bool as the return type. No reason for return type to be int.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/rwsem-spinlock.h  |    2 +-
 include/linux/rwsem.h           |    2 +-
 kernel/locking/rwsem-spinlock.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index d5b13bc..9026d2a 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -39,7 +39,7 @@ extern int __down_write_trylock(struct rw_semaphore *sem);
 extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
-extern int rwsem_is_locked(struct rw_semaphore *sem);
+extern bool rwsem_is_locked(struct rw_semaphore *sem);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 091d993..04faf87 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -49,7 +49,7 @@ extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 #include <asm/rwsem.h>
 
 /* In all implementations count != 0 means locked */
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
+static inline bool rwsem_is_locked(struct rw_semaphore *sem)
 {
 	return sem->count != 0;
 }
diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
index 9be8a91..7374139 100644
--- a/kernel/locking/rwsem-spinlock.c
+++ b/kernel/locking/rwsem-spinlock.c
@@ -20,7 +20,7 @@ struct rwsem_waiter {
 	enum rwsem_waiter_type type;
 };
 
-int rwsem_is_locked(struct rw_semaphore *sem)
+bool rwsem_is_locked(struct rw_semaphore *sem)
 {
 	int ret = 1;
 	unsigned long flags;
-- 
1.7.9.5
