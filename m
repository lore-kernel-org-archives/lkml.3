Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JSV5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:57:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43140 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3JSV5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:57:09 -0400
Message-ID: <52630033.6060407@infradead.org>
Date: Sat, 19 Oct 2013 14:57:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH] vfs: fix new kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Move kernel-doc notation to immediately before its function to eliminate
kernel-doc warnings.  (from commit db14fc3ab: vfs: add d_walk())

Warning(fs/dcache.c:1343): No description found for parameter 'data'
Warning(fs/dcache.c:1343): No description found for parameter 'dentry'
Warning(fs/dcache.c:1343): Excess function parameter 'parent' description in 'check_mount'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- lnx-312-rc6.orig/fs/dcache.c
+++ lnx-312-rc6/fs/dcache.c
@@ -1331,14 +1331,6 @@ rename_retry:
  * list is non-empty and continue searching.
  */
 
-/**
- * have_submounts - check for mounts over a dentry
- * @parent: dentry to check.
- *
- * Return true if the parent or its subdirectories contain
- * a mount point
- */
-
 static enum d_walk_ret check_mount(void *data, struct dentry *dentry)
 {
 	int *ret = data;
@@ -1349,6 +1341,13 @@ static enum d_walk_ret check_mount(void
 	return D_WALK_CONTINUE;
 }
 
+/**
+ * have_submounts - check for mounts over a dentry
+ * @parent: dentry to check.
+ *
+ * Return true if the parent or its subdirectories contain
+ * a mount point
+ */
 int have_submounts(struct dentry *parent)
 {
 	int ret = 0;
