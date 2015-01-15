Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbbAOHDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:03:46 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:45456 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbbAOHDp (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 02:03:45 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/3] ipc,sem: use current->state helpers
Date: Wed, 14 Jan 2015 22:59:12 -0800
Message-Id: <1421305154-14788-1-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __set_current_state() instead of assigning the new state directly.
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 ipc/sem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 6115146..9284211 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1941,7 +1941,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	queue.sleeper = current;
 
 sleep_again:
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	sem_unlock(sma, locknum);
 	rcu_read_unlock();
 
-- 
2.1.2

