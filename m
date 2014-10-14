Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbaJNO0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:26:24 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:63690 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaJNO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:26:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Subject: [PATCH v4 5/5] fuse: Allow user namespace mounts
Date: Tue, 14 Oct 2014 16:25:56 +0200
Message-Id: <1413296756-25071-6-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/fuse/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5e00a6a76049..6522926b14e4 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1212,7 +1212,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 	.mount		= fuse_mount,
 	.kill_sb	= fuse_kill_sb_anon,
 };
@@ -1244,7 +1244,7 @@ static struct file_system_type fuseblk_fs_type = {
 	.name		= "fuseblk",
 	.mount		= fuse_mount_blk,
 	.kill_sb	= fuse_kill_sb_blk,
-	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 };
 MODULE_ALIAS_FS("fuseblk");
 
-- 
2.1.0

