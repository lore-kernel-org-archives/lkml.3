Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaILFfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 01:35:55 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:33019 "EHLO
	homiemail-a8.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbaILFfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 01:35:54 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dave@stgolabs.net, dbueso@suse.de
Subject: [PATCH 1/2] locking/rwsem: EXPORT_SYMBOL follows function definition
Date: Thu, 11 Sep 2014 22:34:25 -0700
Message-Id: <1410500066-5909-1-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rw-semaphore is the only type of lock doing this ugliness of
exporting at the end of the file.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/rwsem-xadd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index d6203fa..12166ec 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -246,6 +246,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 
 	return sem;
 }
+EXPORT_SYMBOL(rwsem_down_read_failed);
 
 static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 {
@@ -465,6 +466,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 
 	return sem;
 }
+EXPORT_SYMBOL(rwsem_down_write_failed);
 
 /*
  * handle waking up a waiter on the semaphore
@@ -485,6 +487,7 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 
 	return sem;
 }
+EXPORT_SYMBOL(rwsem_wake);
 
 /*
  * downgrade a write lock into a read lock
@@ -506,8 +509,4 @@ struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 
 	return sem;
 }
-
-EXPORT_SYMBOL(rwsem_down_read_failed);
-EXPORT_SYMBOL(rwsem_down_write_failed);
-EXPORT_SYMBOL(rwsem_wake);
 EXPORT_SYMBOL(rwsem_downgrade_wake);
-- 
1.8.4.5

