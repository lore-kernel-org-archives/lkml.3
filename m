Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaBIN3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:29:49 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34375 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaBIN3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:29:46 -0500
Date: Sun, 9 Feb 2014 18:59:42 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Elder <alex.elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, Jeff Mahoney <jeffm@suse.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ionut-Gabriel Radu <ihonius@gmail.com>, reiserfs-devel@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 20/21] fs: Move prototype declaration to header file
 reiserfs.h from super.c
Message-ID: <764a2eddc09cb8670d757cd4170d44d41b3971e0.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration to header file reiserfs/reiserfs.h from
reiserfs/super.c because they are used by more than one file.

This eliminates the following warning in reiserfs/bitmap.c:
fs/reiserfs/bitmap.c:647:6: warning: no previous prototype for ‘show_alloc_options’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/reiserfs/reiserfs.h |    1 +
 fs/reiserfs/super.c    |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 8d06adf..83d4eac 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -2831,6 +2831,7 @@ void reiserfs_init_alloc_options(struct super_block *s);
  */
 __le32 reiserfs_choose_packing(struct inode *dir);
 
+void show_alloc_options(struct seq_file *seq, struct super_block *s);
 int reiserfs_init_bitmap_cache(struct super_block *sb);
 void reiserfs_free_bitmap_cache(struct super_block *sb);
 void reiserfs_cache_bitmap_metadata(struct super_block *sb, struct buffer_head *bh, struct reiserfs_bitmap_info *info);
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 2c80335..16d5335 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -62,7 +62,6 @@ static int is_any_reiserfs_magic_string(struct reiserfs_super_block *rs)
 
 static int reiserfs_remount(struct super_block *s, int *flags, char *data);
 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf);
-void show_alloc_options(struct seq_file *seq, struct super_block *s);
 
 static int reiserfs_sync_fs(struct super_block *s, int wait)
 {
-- 
1.7.9.5

