Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3LJTVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:21:02 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:44755 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3LJTSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:18:00 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [PATCH v3 3/6] locks: rename locks_remove_flock to locks_remove_file
Date: Tue, 10 Dec 2013 14:17:32 -0500
Message-Id: <1386703055-22308-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function currently removes leases in addition to flock locks, so
the name is misleading. Rename it to locks_remove_file to indicate that
it removes locks that are associated with a particular struct file.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/file_table.c    | 2 +-
 fs/locks.c         | 2 +-
 include/linux/fs.h | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 5fff903..468543c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -234,7 +234,7 @@ static void __fput(struct file *file)
 	 * in the file cleanup chain.
 	 */
 	eventpoll_release(file);
-	locks_remove_flock(file);
+	locks_remove_file(file);
 
 	if (unlikely(file->f_flags & FASYNC)) {
 		if (file->f_op->fasync)
diff --git a/fs/locks.c b/fs/locks.c
index f96c455..fb10d58 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2231,7 +2231,7 @@ EXPORT_SYMBOL(locks_remove_posix);
 /*
  * This function is called on the last close of an open file.
  */
-void locks_remove_flock(struct file *filp)
+void locks_remove_file(struct file *filp)
 {
 	struct inode * inode = file_inode(filp);
 	struct file_lock *fl;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 04be202..51974e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1012,7 +1012,7 @@ extern struct file_lock * locks_alloc_lock(void);
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
 extern void __locks_copy_lock(struct file_lock *, const struct file_lock *);
 extern void locks_remove_posix(struct file *, fl_owner_t);
-extern void locks_remove_flock(struct file *);
+extern void locks_remove_file(struct file *);
 extern void locks_release_private(struct file_lock *);
 extern void posix_test_lock(struct file *, struct file_lock *);
 extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
@@ -1083,7 +1083,7 @@ static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	return;
 }
 
-static inline void locks_remove_flock(struct file *filp)
+static inline void locks_remove_file(struct file *filp)
 {
 	return;
 }
-- 
1.8.4.2

