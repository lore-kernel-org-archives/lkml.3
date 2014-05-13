Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaEMWE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaEMWEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:04:49 -0400
From: Mateusz Guzik <mguzik@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>
Subject: [PATCH V2 1/2] fs: include device name in error messages about freezing
Date: Wed, 14 May 2014 00:04:42 +0200
Message-Id: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While here use pr_err instead of printk(KERN_ERR...)

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Sandeen <esandeen@redhat.com>
---
 fs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 48377f7..017e10a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1323,8 +1323,7 @@ int freeze_super(struct super_block *sb)
 	if (sb->s_op->freeze_fs) {
 		ret = sb->s_op->freeze_fs(sb);
 		if (ret) {
-			printk(KERN_ERR
-				"VFS:Filesystem freeze failed\n");
+			pr_err("VFS:Filesystem %s freeze failed\n", sb->s_id);
 			sb->s_writers.frozen = SB_UNFROZEN;
 			smp_wmb();
 			wake_up(&sb->s_writers.wait_unfrozen);
@@ -1364,8 +1363,7 @@ int thaw_super(struct super_block *sb)
 	if (sb->s_op->unfreeze_fs) {
 		error = sb->s_op->unfreeze_fs(sb);
 		if (error) {
-			printk(KERN_ERR
-				"VFS:Filesystem thaw failed\n");
+			pr_err("VFS:Filesystem %s thaw failed\n", sb->s_id);
 			up_write(&sb->s_umount);
 			return error;
 		}
-- 
1.8.3.1

