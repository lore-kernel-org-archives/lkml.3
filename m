Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaIPK4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:56:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaIPK4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:56:32 -0400
Date: Tue, 16 Sep 2014 03:56:13 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-db0e716a1512179e8374a74c1f3184e9ce15d138@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@stgolabs.net, tglx@linutronix.de, dbueso@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, tglx@linutronix.de, dbueso@suse.de
In-Reply-To: <1410500066-5909-1-git-send-email-dave@stgolabs.net>
References: <1410500066-5909-1-git-send-email-dave@stgolabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/rwsem: Move EXPORT_SYMBOL()
  lines to follow function definition
Git-Commit-ID: db0e716a1512179e8374a74c1f3184e9ce15d138
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db0e716a1512179e8374a74c1f3184e9ce15d138
Gitweb:     http://git.kernel.org/tip/db0e716a1512179e8374a74c1f3184e9ce15d138
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Thu, 11 Sep 2014 22:34:25 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 09:49:01 +0200

locking/rwsem: Move EXPORT_SYMBOL() lines to follow function definition

rw-semaphore is the only type of lock doing this ugliness of
exporting at the end of the file.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: dave@stgolabs.net
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1410500066-5909-1-git-send-email-dave@stgolabs.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
