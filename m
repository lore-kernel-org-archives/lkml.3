Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3JVWbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:31:21 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:56459 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755785Ab3JVWbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 80,6,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3353:3369:3847:3868:3871:4321:4605:5007:6261:9038:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clam95_b1e2c321f12a
X-Filterd-Recvd-Size: 3500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 19/24] fs: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:30:02 -0700
Message-Id: <489178128748e9ffb234aae72be85592bd94ef76.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
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
index 59c06e5..7c2f779 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -181,7 +181,7 @@ static long get_nr_dentry_unused(void)
 	return sum < 0 ? 0 : sum;
 }
 
-int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
+int proc_nr_dentry(struct ctl_table *table, int write, void __user *buffer,
 		   size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 9fd702f..d9fba09 100644
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
index 473e09d..46a221c 100644
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
index abdd15a..bc477d6 100644
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
index b33ba8e..00653a4 100644
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

