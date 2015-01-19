Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbbASUs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:48:26 -0500
Received: from mailrelay109.isp.belgacom.be ([195.238.20.136]:63769 "EHLO
	mailrelay109.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbbASUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:48:25 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=hkFBDakPHWYIOok4y3pcivnmCJQbEK2MeX2RAJ8hs1E= c=1 sm=2
 a=Zf25LCYKITnOQeVSTvgA:9
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEPABJtvVTD7gau/2dsb2JhbABbgwaBKrNuBQEBAQEBAQUBd5dCgSZDAQEBAQF9hQyBUYgwAb9/jmCGBYl0HYQTBZdwihqIECKBRYIqboJDAQEB
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [RFC 2/2] fs/affs/super.c: let vfs do mount_bdev
Date: Mon, 19 Jan 2015 21:48:18 +0100
Message-Id: <1421700498-15179-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

share fill_super with vfs and remove local mount function.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/super.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index ee8eca7..9f7bba9 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -588,12 +588,6 @@ affs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static struct dentry *affs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
-{
-	return mount_bdev(fs_type, flags, dev_name, data, affs_fill_super);
-}
-
 static void affs_kill_sb(struct super_block *sb)
 {
 	struct affs_sb_info *sbi = AFFS_SB(sb);
@@ -610,7 +604,7 @@ static void affs_kill_sb(struct super_block *sb)
 static struct file_system_type affs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "affs",
-	.mount		= affs_mount,
+	.fill_super	= affs_fill_super,
 	.kill_sb	= affs_kill_sb,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
-- 
1.9.3

