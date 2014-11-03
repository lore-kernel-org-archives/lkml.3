Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaKCIMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:12:35 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36337 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbaKCIM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:12:27 -0500
X-Sasl-enc: Acuv7yjyFymrzhmfKaURDczcHuQNKSK7QTX/gcI/OALL 1415002346
Subject: [PATCH 02/13] autofs4 - fix some white space errors
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 03 Nov 2014 16:12:24 +0800
Message-ID: <20141103081224.6215.69417.stgit@perseus.themaw.net>
In-Reply-To: <20141103081218.6215.85903.stgit@perseus.themaw.net>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some white space format errors.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/inode.c            |    2 +-
 fs/autofs4/root.c             |    8 ++++----
 fs/autofs4/waitq.c            |    2 +-
 include/uapi/linux/auto_fs.h  |    2 +-
 include/uapi/linux/auto_fs4.h |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index e855334..80389af 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -323,7 +323,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	 */
 	s->s_root = root;
 	return 0;
-	
+
 	/*
 	 * Failure ... clean up.
 	 */
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 373be98..7f3e182 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -624,7 +624,7 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
-	
+
 	/* This allows root to remove symlinks */
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -704,7 +704,7 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
-	
+
 	DPRINTK("dentry %p, removing %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
@@ -874,10 +874,10 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
 		return -ENOTTY;
-	
+
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	
+
 	switch (cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
 		return autofs4_wait_release(sbi, (autofs_wqt_t) arg, 0);
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index a0b6a97..b7f2deb 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -86,7 +86,7 @@ static int autofs4_write(struct autofs_sb_info *sbi,
 
 	return (bytes > 0);
 }
-	
+
 static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 				 struct autofs_wait_queue *wq,
 				 int type)
diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
index 5fe176a..9175a1b 100644
--- a/include/uapi/linux/auto_fs.h
+++ b/include/uapi/linux/auto_fs.h
@@ -48,7 +48,7 @@ struct autofs_packet_hdr {
 
 struct autofs_packet_missing {
 	struct autofs_packet_hdr hdr;
-        autofs_wqt_t wait_queue_token;
+	autofs_wqt_t wait_queue_token;
 	int len;
 	char name[NAME_MAX+1];
 };	
diff --git a/include/uapi/linux/auto_fs4.h b/include/uapi/linux/auto_fs4.h
index 924fb1a..8f8f1bd 100644
--- a/include/uapi/linux/auto_fs4.h
+++ b/include/uapi/linux/auto_fs4.h
@@ -108,7 +108,7 @@ enum autofs_notify {
 /* v4 multi expire (via pipe) */
 struct autofs_packet_expire_multi {
 	struct autofs_packet_hdr hdr;
-        autofs_wqt_t wait_queue_token;
+	autofs_wqt_t wait_queue_token;
 	int len;
 	char name[NAME_MAX+1];
 };

