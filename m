Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161018Ab3BFWMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:12:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37541 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3BFWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:12 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 08/11] liblockdep: keep headers declarations even if lib is disabled
Date: Wed,  6 Feb 2013 17:11:31 -0500
Message-Id: <1360188694-25077-9-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need the public headers in the core module code for the preload thing.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
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
-- 
1.8.1.2

