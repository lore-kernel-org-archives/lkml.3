Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3FNCmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:42:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48472 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759632Ab3FNCmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:42:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 26/33] fs: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:51 -0700
Message-Id: <e7d3be68420ae93d8848a17b1e38e8b64ddb2d3d.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/dcache.c      | 2 +-
 fs/drop_caches.c | 2 +-
 fs/eventpoll.c   | 2 +-
 fs/file_table.c  | 4 ++--
 fs/inode.c       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index d3feea1..c9fa3bd 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -152,7 +152,7 @@ static long get_nr_dentry_unused(void)
 	return sum < 0 ? 0 : sum;
 }
 
-int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
+int proc_nr_dentry(struct ctl_table *table, int write, void __user *buffer,
 		   size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index c3f44e7..6c8e90d 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -50,7 +50,7 @@ static void drop_slab(void)
 	} while (nr_objects > 10);
 }
 
-int drop_caches_sysctl_handler(ctl_table *table, int write,
+int drop_caches_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int ret;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 0cff4434..4d2dfb5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -289,7 +289,7 @@ static LIST_HEAD(tfile_check_list);
 static long zero;
 static long long_max = LONG_MAX;
 
-ctl_table epoll_table[] = {
+struct ctl_table epoll_table[] = {
 	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
diff --git a/fs/file_table.c b/fs/file_table.c
index cd4d87a..7cc4cdf 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -79,14 +79,14 @@ EXPORT_SYMBOL_GPL(get_max_files);
  * Handle nr_files sysctl
  */
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
-int proc_nr_files(ctl_table *table, int write,
+int proc_nr_files(struct ctl_table *table, int write,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	files_stat.nr_files = get_nr_files();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #else
-int proc_nr_files(ctl_table *table, int write,
+int proc_nr_files(struct ctl_table *table, int write,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
diff --git a/fs/inode.c b/fs/inode.c
index 00b804e..8bd0abc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -105,7 +105,7 @@ long get_nr_dirty_inodes(void)
  * Handle nr_inode sysctl
  */
 #ifdef CONFIG_SYSCTL
-int proc_nr_inodes(ctl_table *table, int write,
+int proc_nr_inodes(struct ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	inodes_stat.nr_inodes = get_nr_inodes();
-- 
1.8.1.2.459.gbcd45b4.dirty

