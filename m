Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaILFgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 01:36:11 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:33026 "EHLO
	homiemail-a8.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbaILFfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 01:35:55 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dave@stgolabs.net, dbueso@suse.de
Subject: [PATCH 2/2] locking/rwsem-spinlock: Cleanup down_read()
Date: Thu, 11 Sep 2014 22:34:26 -0700
Message-Id: <1410500066-5909-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410500066-5909-1-git-send-email-dave@stgolabs.net>
References: <1410500066-5909-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... when returning from a successful lock acquisition. The horror!

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/rwsem-spinlock.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
index 2c93571..07e456c 100644
--- a/kernel/locking/rwsem-spinlock.c
+++ b/kernel/locking/rwsem-spinlock.c
@@ -130,7 +130,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 		/* granted */
 		sem->count++;
 		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-		goto out;
+		return;
 	}
 
 	tsk = current;
@@ -155,8 +155,6 @@ void __sched __down_read(struct rw_semaphore *sem)
 	}
 
 	tsk->state = TASK_RUNNING;
- out:
-	;
 }
 
 /*
-- 
1.8.4.5

