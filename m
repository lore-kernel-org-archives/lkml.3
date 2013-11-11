Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3KKRwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:52:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3KKRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:52:37 -0500
Date: Mon, 11 Nov 2013 09:51:57 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-34pikw1tlsskj65rrt5iusrq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/doc: Update references to kernel/
 mutex.c
Git-Commit-ID: 67a6de49bf545c34eb8dee99abbb92d9ea268200
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 09:52:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67a6de49bf545c34eb8dee99abbb92d9ea268200
Gitweb:     http://git.kernel.org/tip/67a6de49bf545c34eb8dee99abbb92d9ea268200
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 8 Nov 2013 08:26:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Nov 2013 12:41:33 +0100

locking/doc: Update references to kernel/mutex.c

Fix this docbook error:

  >> docproc: kernel/mutex.c: No such file or directory

by updating the stale references to kernel/mutex.c.

Reported-by: fengguang.wu@intel.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-34pikw1tlsskj65rrt5iusrq@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/DocBook/kernel-locking.tmpl |  2 +-
 Documentation/mutex-design.txt            | 10 +++++-----
 include/linux/mutex.h                     |  2 +-
 kernel/locking/mutex.c                    |  2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 09e884e..19f2a5a 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1958,7 +1958,7 @@ machines due to caching.
   <chapter id="apiref-mutex">
    <title>Mutex API reference</title>
 !Iinclude/linux/mutex.h
-!Ekernel/mutex.c
+!Ekernel/locking/mutex.c
   </chapter>
 
   <chapter id="apiref-futex">
diff --git a/Documentation/mutex-design.txt b/Documentation/mutex-design.txt
index 38c10fd..1dfe62c 100644
--- a/Documentation/mutex-design.txt
+++ b/Documentation/mutex-design.txt
@@ -116,11 +116,11 @@ using mutexes at the moment, please let me know if you find any. ]
 Implementation of mutexes
 -------------------------
 
-'struct mutex' is the new mutex type, defined in include/linux/mutex.h
-and implemented in kernel/mutex.c. It is a counter-based mutex with a
-spinlock and a wait-list. The counter has 3 states: 1 for "unlocked",
-0 for "locked" and negative numbers (usually -1) for "locked, potential
-waiters queued".
+'struct mutex' is the new mutex type, defined in include/linux/mutex.h and
+implemented in kernel/locking/mutex.c. It is a counter-based mutex with a
+spinlock and a wait-list. The counter has 3 states: 1 for "unlocked", 0 for
+"locked" and negative numbers (usually -1) for "locked, potential waiters
+queued".
 
 the APIs of 'struct mutex' have been streamlined:
 
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index bab49da..d318193 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -131,7 +131,7 @@ static inline int mutex_is_locked(struct mutex *lock)
 }
 
 /*
- * See kernel/mutex.c for detailed documentation of these APIs.
+ * See kernel/locking/mutex.c for detailed documentation of these APIs.
  * Also see Documentation/mutex-design.txt.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index d24105b..4dd6e4c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -1,5 +1,5 @@
 /*
- * kernel/mutex.c
+ * kernel/locking/mutex.c
  *
  * Mutexes: blocking mutual exclusion locks
  *
