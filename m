Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3BKMVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:21:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab3BKMVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:21:37 -0500
Date: Mon, 11 Feb 2013 04:21:18 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-62347c63f0646e76a36dc7039d395e0faa880c79@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep:
  Remove the need for liblockdep_init()
Git-Commit-ID: 62347c63f0646e76a36dc7039d395e0faa880c79
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:21:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62347c63f0646e76a36dc7039d395e0faa880c79
Gitweb:     http://git.kernel.org/tip/62347c63f0646e76a36dc7039d395e0faa880c79
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:31 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:36 +0100

liblockdep: Remove the need for liblockdep_init()

Use a constructor in the library instead of making the user
manually call liblockdep_init().

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
Link: http://lkml.kernel.org/r/1360456781-32462-1-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
