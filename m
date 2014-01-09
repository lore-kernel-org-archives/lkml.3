Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaAIOUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:20:22 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:34822 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbaAIOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:04 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 03/14] locks: remove "inline" qualifier from fl_link manipulation functions
Date: Thu,  9 Jan 2014 09:19:36 -0500
Message-Id: <1389277187-18211-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's best to let the compiler decide that.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 5e28612..049a144 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -511,8 +511,7 @@ static int posix_same_owner(struct file_lock *fl1, struct file_lock *fl2)
 }
 
 /* Must be called with the i_lock held! */
-static inline void
-locks_insert_global_locks(struct file_lock *fl)
+static void locks_insert_global_locks(struct file_lock *fl)
 {
 	lg_local_lock(&file_lock_lglock);
 	fl->fl_link_cpu = smp_processor_id();
@@ -521,8 +520,7 @@ locks_insert_global_locks(struct file_lock *fl)
 }
 
 /* Must be called with the i_lock held! */
-static inline void
-locks_delete_global_locks(struct file_lock *fl)
+static void locks_delete_global_locks(struct file_lock *fl)
 {
 	/*
 	 * Avoid taking lock if already unhashed. This is safe since this check
@@ -544,14 +542,12 @@ posix_owner_key(struct file_lock *fl)
 	return (unsigned long)fl->fl_owner;
 }
 
-static inline void
-locks_insert_global_blocked(struct file_lock *waiter)
+static void locks_insert_global_blocked(struct file_lock *waiter)
 {
 	hash_add(blocked_hash, &waiter->fl_link, posix_owner_key(waiter));
 }
 
-static inline void
-locks_delete_global_blocked(struct file_lock *waiter)
+static void locks_delete_global_blocked(struct file_lock *waiter)
 {
 	hash_del(&waiter->fl_link);
 }
-- 
1.8.4.2

