Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbbAXVsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:48:42 -0500
Received: from netz39.de ([78.46.22.20]:48027 "EHLO mail.netz39.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbbAXVsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:48:13 -0500
X-Spam-Report: 0.0 URIBL_BLOCKED          ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	See
	http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	for more information.
	[URIs: netz39.de]
	-1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
From: Stefan Haun <tux@netz39.de>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org, Stefan Haun <tux@netz39.de>
Subject: [PATCH 1/2] fs: fix code-formatting issues in inotify
Date: Sat, 24 Jan 2015 22:40:02 +0100
Message-Id: <1422135603-1135-1-git-send-email-tux@netz39.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix code-formatting warnings from script/checkpatch.pl; multiple instances of

WARNING: line over 80 characters
CHECK: No space is necessary after a cast
CHECK: Alignment should match open parenthesis
WARNING: quoted string split across lines
CHECK: Blank lines aren't necessary before a close brace '}'
CHECK: Please don't use multiple blank lines

Signed-off-by: Stefan Haun <tux@netz39.de>
---
 fs/notify/inotify/inotify_fsnotify.c |   11 +++---
 fs/notify/inotify/inotify_user.c     |   68 ++++++++++++++++++----------------
 2 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 2cd900c..0238615 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -54,7 +54,7 @@ static bool event_compare(struct fsnotify_event *old_fsn,
 }
 
 static int inotify_merge(struct list_head *list,
-			  struct fsnotify_event *event)
+			 struct fsnotify_event *event)
 {
 	struct fsnotify_event *last_event;
 
@@ -120,7 +120,8 @@ int inotify_handle_event(struct fsnotify_group *group,
 	return 0;
 }
 
-static void inotify_freeing_mark(struct fsnotify_mark *fsn_mark, struct fsnotify_group *group)
+static void inotify_freeing_mark(struct fsnotify_mark *fsn_mark,
+				 struct fsnotify_group *group)
 {
 	inotify_ignored_and_remove_idr(fsn_mark, group);
 }
@@ -145,8 +146,8 @@ static int idr_callback(int id, void *p, void *data)
 	fsn_mark = p;
 	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
-	WARN(1, "inotify closing but id=%d for fsn_mark=%p in group=%p still in "
-		"idr.  Probably leaking memory\n", id, p, data);
+	WARN(1, "inotify closing but id=%d for fsn_mark=%p in group=%p still in idr. Probably leaking memory\n",
+	     id, p, data);
 
 	/*
 	 * I'm taking the liberty of assuming that the mark in question is a
@@ -156,7 +157,7 @@ static int idr_callback(int id, void *p, void *data)
 	 */
 	if (fsn_mark)
 		printk(KERN_WARNING "fsn_mark->group=%p inode=%p wd=%d\n",
-			fsn_mark->group, fsn_mark->inode, i_mark->wd);
+		       fsn_mark->group, fsn_mark->inode, i_mark->wd);
 	return 0;
 }
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 45064869..3214e2b 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -201,9 +201,9 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	buf += event_size;
 
 	/*
-	 * fsnotify only stores the pathname, so here we have to send the pathname
-	 * and then pad that pathname out to a multiple of sizeof(inotify_event)
-	 * with zeros.
+	 * fsnotify only stores the pathname, so here we have to send the
+	 * pathname and then pad that pathname out to a multiple of
+	 * sizeof(inotify_event) with zeros.
 	 */
 	if (pad_name_len) {
 		/* copy the path name */
@@ -278,7 +278,10 @@ static int inotify_release(struct inode *ignored, struct file *file)
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
-	/* free this group, matching get was inotify_init->fsnotify_obtain_group */
+	/*
+	 * free this group, matching get was
+	 * inotify_init->fsnotify_obtain_group
+	 */
 	fsnotify_destroy_group(group);
 
 	return 0;
@@ -294,7 +297,7 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
 	size_t send_len = 0;
 
 	group = file->private_data;
-	p = (void __user *) arg;
+	p = (void __user *)arg;
 
 	pr_debug("%s: group=%p cmd=%u\n", __func__, group, cmd);
 
@@ -307,7 +310,7 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
 			send_len += round_event_name_len(fsn_event);
 		}
 		mutex_unlock(&group->notification_mutex);
-		ret = put_user(send_len, (int __user *) p);
+		ret = put_user(send_len, (int __user *)p);
 		break;
 	}
 
@@ -325,11 +328,11 @@ static const struct file_operations inotify_fops = {
 	.llseek		= noop_llseek,
 };
 
-
 /*
  * find_inode - resolve a user-given path to a specific inode
  */
-static int inotify_find_inode(const char __user *dirname, struct path *path, unsigned flags)
+static int inotify_find_inode(const char __user *dirname, struct path *path,
+			      unsigned flags)
 {
 	int error;
 
@@ -363,8 +366,9 @@ static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
 	return ret < 0 ? ret : 0;
 }
 
-static struct inotify_inode_mark *inotify_idr_find_locked(struct fsnotify_group *group,
-								int wd)
+static struct inotify_inode_mark *inotify_idr_find_locked(
+					struct fsnotify_group *group,
+					int wd)
 {
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
@@ -385,7 +389,7 @@ static struct inotify_inode_mark *inotify_idr_find_locked(struct fsnotify_group
 }
 
 static struct inotify_inode_mark *inotify_idr_find(struct fsnotify_group *group,
-							 int wd)
+						   int wd)
 {
 	struct inotify_inode_mark *i_mark;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
@@ -431,18 +435,18 @@ static void inotify_remove_from_idr(struct fsnotify_group *group,
 	 * if it wasn't....
 	 */
 	if (wd == -1) {
-		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
-			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
-			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
+		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p i_mark->inode=%p\n",
+			  __func__, i_mark, i_mark->wd, i_mark->fsn_mark.group,
+			  i_mark->fsn_mark.inode);
 		goto out;
 	}
 
 	/* Lets look in the idr to see if we find it */
 	found_i_mark = inotify_idr_find_locked(group, wd);
 	if (unlikely(!found_i_mark)) {
-		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
-			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
-			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
+		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p i_mark->inode=%p\n",
+			  __func__, i_mark, i_mark->wd,	i_mark->fsn_mark.group,
+			  i_mark->fsn_mark.inode);
 		goto out;
 	}
 
@@ -452,13 +456,11 @@ static void inotify_remove_from_idr(struct fsnotify_group *group,
 	 * fucked up somewhere.
 	 */
 	if (unlikely(found_i_mark != i_mark)) {
-		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p "
-			"mark->inode=%p found_i_mark=%p found_i_mark->wd=%d "
-			"found_i_mark->group=%p found_i_mark->inode=%p\n",
-			__func__, i_mark, i_mark->wd, i_mark->fsn_mark.group,
-			i_mark->fsn_mark.inode, found_i_mark, found_i_mark->wd,
-			found_i_mark->fsn_mark.group,
-			found_i_mark->fsn_mark.inode);
+		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p mark->inode=%p found_i_mark=%p found_i_mark->wd=%d found_i_mark->group=%p found_i_mark->inode=%p\n",
+			  __func__, i_mark, i_mark->wd, i_mark->fsn_mark.group,
+			  i_mark->fsn_mark.inode, found_i_mark,
+			  found_i_mark->wd, found_i_mark->fsn_mark.group,
+			  found_i_mark->fsn_mark.inode);
 		goto out;
 	}
 
@@ -536,7 +538,8 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 
 	old_mask = fsn_mark->mask;
 	if (add)
-		fsnotify_set_mark_mask_locked(fsn_mark, (fsn_mark->mask | mask));
+		fsnotify_set_mark_mask_locked(fsn_mark,
+					      (fsn_mark->mask | mask));
 	else
 		fsnotify_set_mark_mask_locked(fsn_mark, mask);
 	new_mask = fsn_mark->mask;
@@ -552,7 +555,6 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 		/* update the inode with this new fsn_mark */
 		if (dropped || do_inode)
 			fsnotify_recalc_inode_mask(inode);
-
 	}
 
 	/* return the wd */
@@ -585,7 +587,8 @@ static int inotify_new_watch(struct fsnotify_group *group,
 	tmp_i_mark->wd = -1;
 
 	ret = -ENOSPC;
-	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
+	if (atomic_read(&group->inotify_data.user->inotify_watches)
+	    >= inotify_max_user_watches)
 		goto out_err;
 
 	ret = inotify_add_to_idr(idr, idr_lock, tmp_i_mark);
@@ -614,7 +617,8 @@ out_err:
 	return ret;
 }
 
-static int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
+static int inotify_update_watch(struct fsnotify_group *group,
+				struct inode *inode, u32 arg)
 {
 	int ret = 0;
 
@@ -664,7 +668,6 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 	return group;
 }
 
-
 /* inotify syscalls */
 SYSCALL_DEFINE1(inotify_init1, int, flags)
 {
@@ -678,13 +681,16 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
 	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
 		return -EINVAL;
 
-	/* fsnotify_obtain_group took a reference to group, we put this when we kill the file in the end */
+	/*
+	 * fsnotify_obtain_group took a reference to group, we put this when
+	 * we kill the file in the end
+	 */
 	group = inotify_new_group(inotify_max_queued_events);
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
 	ret = anon_inode_getfd("inotify", &inotify_fops, group,
-				  O_RDONLY | flags);
+			       O_RDONLY | flags);
 	if (ret < 0)
 		fsnotify_destroy_group(group);
 
-- 
1.7.10.4
