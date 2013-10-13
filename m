Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3JMQEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:04:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50323 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3JMQEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:04:48 -0400
X-Nat-Received: from [202.181.97.72]:58994 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1381680286.25680
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unused "struct user_struct"->files.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201310140104.JGE34309.OSQOMFOFLFJtHV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 14 Oct 2013 01:04:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13102013 #11236901, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to inspect "struct user_struct"->files , but it seems to me that
the value is always 0... This field is not used?
----------
>From e6f9007c5785d5c9817b8fb798542c44d1eefcc5 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 14 Oct 2013 00:19:19 +0900
Subject: [PATCH] Remove unused "struct user_struct"->files.

Remove no longer used field.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/sched.h |    1 -
 kernel/user.c         |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6682da3..baa18d5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -638,7 +638,6 @@ static inline int signal_group_exit(const struct signal_struct *sig)
 struct user_struct {
 	atomic_t __count;	/* reference count */
 	atomic_t processes;	/* How many processes does this user have? */
-	atomic_t files;		/* How many open files does this user have? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_INOTIFY_USER
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
diff --git a/kernel/user.c b/kernel/user.c
index 5bbb919..3024ab8 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -83,7 +83,6 @@ static DEFINE_SPINLOCK(uidhash_lock);
 struct user_struct root_user = {
 	.__count	= ATOMIC_INIT(1),
 	.processes	= ATOMIC_INIT(1),
-	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
 	.uid		= GLOBAL_ROOT_UID,
-- 
1.7.1
