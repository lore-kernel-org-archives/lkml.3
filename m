Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3BFWMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:12:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37506 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3BFWMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:12:09 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 01/11] liblockdep: remove the need for liblockdep_init
Date: Wed,  6 Feb 2013 17:11:24 -0500
Message-Id: <1360188694-25077-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a constructor in the library instead of making the user manually
call liblockdep_init().

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/common.c                    | 2 +-
 tools/lib/lockdep/include/liblockdep/common.h | 1 -
 tools/lib/lockdep/tests/AA.c                  | 1 -
 tools/lib/lockdep/tests/ABBA.c                | 1 -
 tools/lib/lockdep/tests/ABBCCA.c              | 1 -
 tools/lib/lockdep/tests/ABBCCDDA.c            | 1 -
 tools/lib/lockdep/tests/ABCABC.c              | 1 -
 tools/lib/lockdep/tests/ABCDBCDA.c            | 1 -
 tools/lib/lockdep/tests/ABCDBDDA.c            | 1 -
 tools/lib/lockdep/tests/WW.c                  | 1 -
 tools/lib/lockdep/tests/unlock_balance.c      | 1 -
 tools/lib/lockdep/uinclude/linux/lockdep.h    | 1 -
 12 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
index 99d3b4b..d2946e0 100644
--- a/tools/lib/lockdep/common.c
+++ b/tools/lib/lockdep/common.c
@@ -10,7 +10,7 @@ __thread struct task_struct current_obj;
 bool debug_locks = true;
 bool debug_locks_silent;
 
-void liblockdep_init(void)
+__attribute__((constructor)) static void liblockdep_init(void)
 {
 	lockdep_init();
 }
diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
index b72f9c1..f6f7fec8 100644
--- a/tools/lib/lockdep/include/liblockdep/common.h
+++ b/tools/lib/lockdep/include/liblockdep/common.h
@@ -26,7 +26,6 @@ struct lockdep_map {
 #endif
 };
 
-void liblockdep_init(void);
 void liblockdep_set_thread(void);
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 			struct lock_class_key *key, int subclass);
diff --git a/tools/lib/lockdep/tests/AA.c b/tools/lib/lockdep/tests/AA.c
index 933d32f..3f71333 100644
--- a/tools/lib/lockdep/tests/AA.c
+++ b/tools/lib/lockdep/tests/AA.c
@@ -4,7 +4,6 @@ void main(void)
 {
 	pthread_mutex_t a, b;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/ABBA.c b/tools/lib/lockdep/tests/ABBA.c
index 9f5146b..08d87a7 100644
--- a/tools/lib/lockdep/tests/ABBA.c
+++ b/tools/lib/lockdep/tests/ABBA.c
@@ -5,7 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/ABBCCA.c b/tools/lib/lockdep/tests/ABBCCA.c
index b7435d7..c5d0e5c 100644
--- a/tools/lib/lockdep/tests/ABBCCA.c
+++ b/tools/lib/lockdep/tests/ABBCCA.c
@@ -5,7 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/ABBCCDDA.c b/tools/lib/lockdep/tests/ABBCCDDA.c
index 2425330..e12dc98 100644
--- a/tools/lib/lockdep/tests/ABBCCDDA.c
+++ b/tools/lib/lockdep/tests/ABBCCDDA.c
@@ -5,7 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c, d;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/ABCABC.c b/tools/lib/lockdep/tests/ABCABC.c
index 2ee30fe..70879c95 100644
--- a/tools/lib/lockdep/tests/ABCABC.c
+++ b/tools/lib/lockdep/tests/ABCABC.c
@@ -5,7 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/ABCDBCDA.c b/tools/lib/lockdep/tests/ABCDBCDA.c
index 32d19d6..00cd676 100644
--- a/tools/lib/lockdep/tests/ABCDBCDA.c
+++ b/tools/lib/lockdep/tests/ABCDBCDA.c
@@ -5,7 +5,6 @@ void main(void)
 {
 	liblockdep_pthread_mutex_t a, b, c, d;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	liblockdep_pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/ABCDBDDA.c b/tools/lib/lockdep/tests/ABCDBDDA.c
index 850eaca..19b3ed1 100644
--- a/tools/lib/lockdep/tests/ABCDBDDA.c
+++ b/tools/lib/lockdep/tests/ABCDBDDA.c
@@ -5,7 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c, d;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/WW.c b/tools/lib/lockdep/tests/WW.c
index 4b1be0f..2467b13 100644
--- a/tools/lib/lockdep/tests/WW.c
+++ b/tools/lib/lockdep/tests/WW.c
@@ -4,7 +4,6 @@ void main(void)
 {
 	pthread_rwlock_t a, b;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_rwlock_init(&a, NULL);
diff --git a/tools/lib/lockdep/tests/unlock_balance.c b/tools/lib/lockdep/tests/unlock_balance.c
index 9dfaf97..07a4c21 100644
--- a/tools/lib/lockdep/tests/unlock_balance.c
+++ b/tools/lib/lockdep/tests/unlock_balance.c
@@ -4,7 +4,6 @@ void main(void)
 {
 	pthread_mutex_t a;
 
-	liblockdep_init();
 	liblockdep_set_thread();
 
 	pthread_mutex_init(&a, NULL);
diff --git a/tools/lib/lockdep/uinclude/linux/lockdep.h b/tools/lib/lockdep/uinclude/linux/lockdep.h
index 1ed83a5..611cb28 100644
--- a/tools/lib/lockdep/uinclude/linux/lockdep.h
+++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
@@ -25,7 +25,6 @@ struct task_struct {
 extern __thread struct task_struct current_obj;
 #define current (&current_obj)
 
-void liblockdep_init(void);
 void liblockdep_set_thread(void);
 
 #define debug_locks_off() 1
-- 
1.8.1.2

