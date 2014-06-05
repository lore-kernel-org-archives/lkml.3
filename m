Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaFEOd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:33:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48235 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFEOdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:33:54 -0400
Date: Thu, 5 Jun 2014 07:33:12 -0700
From: tip-bot for Andrew Morton <tipbot@zytor.com>
Message-ID: <tip-pn6pslaplw031lykweojsn8c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de, davidlohr@hp.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/rwsem: Fix checkpatch.pl warnings
Git-Commit-ID: 0cc3d01164aba483edd8232aa5c781136843c367
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

Commit-ID:  0cc3d01164aba483edd8232aa5c781136843c367
Gitweb:     http://git.kernel.org/tip/0cc3d01164aba483edd8232aa5c781136843c367
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Wed, 4 Jun 2014 20:19:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 10:39:36 +0200

locking/rwsem: Fix checkpatch.pl warnings

WARNING: line over 80 characters
#205: FILE: kernel/locking/rwsem-xadd.c:275:
+		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);

WARNING: line over 80 characters
#376: FILE: kernel/locking/rwsem-xadd.c:434:
+		 * If there were already threads queued before us and there are no

WARNING: line over 80 characters
#377: FILE: kernel/locking/rwsem-xadd.c:435:
+		 * active writers, the lock must be read owned; so we try to wake

total: 0 errors, 3 warnings, 417 lines checked

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-pn6pslaplw031lykweojsn8c@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/rwsem-xadd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 4a75278..dacc321 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -433,9 +433,9 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 		count = ACCESS_ONCE(sem->count);
 
 		/*
-		 * If there were already threads queued before us and there are no
-		 * active writers, the lock must be read owned; so we try to wake
-		 * any read locks that were queued ahead of us.
+		 * If there were already threads queued before us and there are
+		 * no active writers, the lock must be read owned; so we try to
+		 * wake any read locks that were queued ahead of us.
 		 */
 		if (count > RWSEM_WAITING_BIAS)
 			sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
