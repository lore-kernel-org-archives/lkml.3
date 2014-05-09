Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbaEISWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:22:11 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:14277 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700AbaEISWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:22:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0XALEbbVNXQw5R/2dsb2JhbABZgwasSwQBAQEBAQEFAZoUAgKBGRd0glMTHCMYgQIkE4hFAdEzhVaIfIRHAQOPJIoiAYsDh3+DODs
Date: Fri, 9 May 2014 20:22:02 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/1] kernel/user_namespace.c: kernel-doc/checkpatch fixes
Message-Id: <20140509202202.2790dab9965e22b574513d8e@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-uid->gid
-split some function declarations
-if/then/else warning

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/user_namespace.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index bf71b4b..fcc0256 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -286,7 +286,7 @@ EXPORT_SYMBOL(from_kuid_munged);
 /**
  *	make_kgid - Map a user-namespace gid pair into a kgid.
  *	@ns:  User namespace that the gid is in
- *	@uid: group identifier
+ *	@gid: group identifier
  *
  *	Maps a user-namespace gid pair into a kernel internal kgid,
  *	and returns that kgid.
@@ -482,7 +482,8 @@ static int projid_m_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static void *m_start(struct seq_file *seq, loff_t *ppos, struct uid_gid_map *map)
+static void *m_start(struct seq_file *seq, loff_t *ppos,
+		     struct uid_gid_map *map)
 {
 	struct uid_gid_extent *extent = NULL;
 	loff_t pos = *ppos;
@@ -546,7 +547,8 @@ struct seq_operations proc_projid_seq_operations = {
 	.show = projid_m_show,
 };
 
-static bool mappings_overlap(struct uid_gid_map *new_map, struct uid_gid_extent *extent)
+static bool mappings_overlap(struct uid_gid_map *new_map,
+			     struct uid_gid_extent *extent)
 {
 	u32 upper_first, lower_first, upper_last, lower_last;
 	unsigned idx;
@@ -653,7 +655,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	ret = -EINVAL;
 	pos = kbuf;
 	new_map.nr_extents = 0;
-	for (;pos; pos = next_line) {
+	for (; pos; pos = next_line) {
 		extent = &new_map.extent[new_map.nr_extents];
 
 		/* Find the end of line and ensure I don't look past it */
@@ -687,13 +689,16 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 
 		/* Verify we have been given valid starting values */
 		if ((extent->first == (u32) -1) ||
-		    (extent->lower_first == (u32) -1 ))
+		    (extent->lower_first == (u32) -1))
 			goto out;
 
-		/* Verify count is not zero and does not cause the extent to wrap */
+		/* Verify count is not zero and does not cause the
+		 * extent to wrap
+		 */
 		if ((extent->first + extent->count) <= extent->first)
 			goto out;
-		if ((extent->lower_first + extent->count) <= extent->lower_first)
+		if ((extent->lower_first + extent->count) <=
+		     extent->lower_first)
 			goto out;
 
 		/* Do the ranges in extent overlap any previous extents? */
@@ -751,7 +756,8 @@ out:
 	return ret;
 }
 
-ssize_t proc_uid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_uid_map_write(struct file *file, const char __user *buf,
+			   size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -767,7 +773,8 @@ ssize_t proc_uid_map_write(struct file *file, const char __user *buf, size_t siz
 			 &ns->uid_map, &ns->parent->uid_map);
 }
 
-ssize_t proc_gid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_gid_map_write(struct file *file, const char __user *buf,
+			   size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -783,7 +790,8 @@ ssize_t proc_gid_map_write(struct file *file, const char __user *buf, size_t siz
 			 &ns->gid_map, &ns->parent->gid_map);
 }
 
-ssize_t proc_projid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_projid_map_write(struct file *file, const char __user *buf,
+			      size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -800,7 +808,7 @@ ssize_t proc_projid_map_write(struct file *file, const char __user *buf, size_t
 			 &ns->projid_map, &ns->parent->projid_map);
 }
 
-static bool new_idmap_permitted(const struct file *file, 
+static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
@@ -811,8 +819,7 @@ static bool new_idmap_permitted(const struct file *file,
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, file->f_cred->fsuid))
 				return true;
-		}
-		else if (cap_setid == CAP_SETGID) {
+		} else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
 			if (gid_eq(gid, file->f_cred->fsgid))
 				return true;
-- 
1.8.4.5
