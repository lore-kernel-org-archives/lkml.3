Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3BKMaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:30:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3BKMaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:30:20 -0500
Date: Mon, 11 Feb 2013 04:30:05 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-fab0398231a1fff5a3d0ded5f7416c9d2e3d48d1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-8-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-8-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep:
  Keep header declarations even if the library is disabled
Git-Commit-ID: fab0398231a1fff5a3d0ded5f7416c9d2e3d48d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:30:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fab0398231a1fff5a3d0ded5f7416c9d2e3d48d1
Gitweb:     http://git.kernel.org/tip/fab0398231a1fff5a3d0ded5f7416c9d2e3d48d1
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:38 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:40 +0100

liblockdep: Keep header declarations even if the library is disabled

We need the public headers in the core module code for the
preload thing.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-8-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/include/liblockdep/mutex.h  | 4 ++--
 tools/lib/lockdep/include/liblockdep/rwlock.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/lockdep/include/liblockdep/mutex.h b/tools/lib/lockdep/include/liblockdep/mutex.h
index 5154a9d..6ebe733 100644
--- a/tools/lib/lockdep/include/liblockdep/mutex.h
+++ b/tools/lib/lockdep/include/liblockdep/mutex.h
@@ -1,8 +1,6 @@
 #ifndef _LIBLOCKDEP_MUTEX_H
 #define _LIBLOCKDEP_MUTEX_H
 
-#ifdef __USE_LIBLOCKDEP
-
 #include <pthread.h>
 #include "common.h"
 
@@ -61,6 +59,8 @@ static inline int liblockdep_pthread_mutex_destroy(liblockdep_pthread_mutex_t *l
 	return pthread_mutex_destroy(&lock->mutex);
 }
 
+#ifdef __USE_LIBLOCKDEP
+
 #define pthread_mutex_t         liblockdep_pthread_mutex_t
 #define pthread_mutex_init      liblockdep_pthread_mutex_init
 #define pthread_mutex_lock      liblockdep_pthread_mutex_lock
diff --git a/tools/lib/lockdep/include/liblockdep/rwlock.h b/tools/lib/lockdep/include/liblockdep/rwlock.h
index 26f9a68..a1d820b 100644
--- a/tools/lib/lockdep/include/liblockdep/rwlock.h
+++ b/tools/lib/lockdep/include/liblockdep/rwlock.h
@@ -1,8 +1,6 @@
 #ifndef _LIBLOCKDEP_RWLOCK_H
 #define _LIBLOCKDEP_RWLOCK_H
 
-#ifdef __USE_LIBLOCKDEP
-
 #include <pthread.h>
 #include "common.h"
 
@@ -77,6 +75,8 @@ static inline int liblockdep_rwlock_destroy(liblockdep_pthread_rwlock_t *lock)
 	return pthread_rwlock_destroy(&lock->rwlock);
 }
 
+#ifdef __USE_LIBLOCKDEP
+
 #define pthread_rwlock_t		liblockdep_pthread_rwlock_t
 #define pthread_rwlock_init		liblockdep_pthread_rwlock_init
 #define pthread_rwlock_rdlock		liblockdep_pthread_rwlock_rdlock
