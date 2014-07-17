Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaGQLB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:01:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGQLBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:01:25 -0400
Date: Thu, 17 Jul 2014 04:00:16 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-586fefe5bbdc931fb0725b850f7002f6d71a1aa3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, scott.norton@hp.com,
        fengguang.wu@intel.com, maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, fengguang.wu@intel.com,
        scott.norton@hp.com, maarten.lankhorst@canonical.com
In-Reply-To: <1403804351-405-3-git-send-email-Waiman.Long@hp.com>
References: <1403804351-405-3-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/selftest: Support queued rwlock
Git-Commit-ID: 586fefe5bbdc931fb0725b850f7002f6d71a1aa3
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

Commit-ID:  586fefe5bbdc931fb0725b850f7002f6d71a1aa3
Gitweb:     http://git.kernel.org/tip/586fefe5bbdc931fb0725b850f7002f6d71a1aa3
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Thu, 26 Jun 2014 13:39:11 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 17 Jul 2014 12:32:53 +0200

locking/selftest: Support queued rwlock

The queued rwlock does not support the use of recursive read-lock in
the process context. With changes in the lockdep code to check and
disallow recursive read-lock when queued rwlock is configured, it
is also necessary for the locking selftest to be updated to change
the process context recursive read locking results from SUCCESS to
FAILURE for queued rwlock.

Cc: Scott J Norton <scott.norton@hp.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403804351-405-3-git-send-email-Waiman.Long@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/locking-selftest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 872a15a..596934d 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1069,7 +1069,7 @@ static inline void print_testname(const char *testname)
 	print_testname(desc);					\
 	dotest(name##_spin, FAILURE, LOCKTYPE_SPIN);		\
 	dotest(name##_wlock, FAILURE, LOCKTYPE_RWLOCK);		\
-	dotest(name##_rlock, SUCCESS, LOCKTYPE_RWLOCK);		\
+	dotest(name##_rlock, FAILURE, LOCKTYPE_RWLOCK);		\
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
@@ -1830,14 +1830,14 @@ void locking_selftest(void)
 	printk("  --------------------------------------------------------------------------\n");
 	print_testname("recursive read-lock");
 	printk("             |");
-	dotest(rlock_AA1, SUCCESS, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1, FAILURE, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
 	print_testname("recursive read-lock #2");
 	printk("             |");
-	dotest(rlock_AA1B, SUCCESS, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1B, FAILURE, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1B, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
