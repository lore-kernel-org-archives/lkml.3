Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab3HNM0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:26:25 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:33949 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887Ab3HNMZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:25:58 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/3] locks: remove "inline" qualifier from fl_link manipulation functions
Date: Wed, 14 Aug 2013 08:25:48 -0400
Message-Id: <1376483149-7633-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376483149-7633-1-git-send-email-jlayton@redhat.com>
References: <1376483149-7633-1-git-send-email-jlayton@redhat.com>
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
index 9f28359..b1e5bfe 100644
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
1.8.3.1

