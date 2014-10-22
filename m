Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbaJVVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:25:27 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40126 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158AbaJVVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:24:58 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v5 4/4] fuse: Allow user namespace mounts
Date: Wed, 22 Oct 2014 16:24:20 -0500
Message-Id: <1414013060-137148-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/fuse/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b88b5a780228..7d0e73e36e7b 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1201,7 +1201,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 	.mount		= fuse_mount,
 	.kill_sb	= fuse_kill_sb_anon,
 };
@@ -1233,7 +1233,7 @@ static struct file_system_type fuseblk_fs_type = {
 	.name		= "fuseblk",
 	.mount		= fuse_mount_blk,
 	.kill_sb	= fuse_kill_sb_blk,
-	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 };
 MODULE_ALIAS_FS("fuseblk");
 
-- 
1.9.1

