Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3A3BiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:38:00 -0500
Received: from vint.altlinux.org ([194.107.17.35]:56186 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3A3Bh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:37:57 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 20:37:57 EST
Date: Wed, 30 Jan 2013 05:30:38 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] vfs: cleanup show_mountinfo
Message-ID: <20130130013033.GC20174@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with commit v3.2-rc4-1-g02125a8, seq_path_root() no longer
changes the value of its "struct path *root" argument.
Starting with commit v3.2-rc7-104-g8c9379e, the "struct path *root"
argument of seq_path_root() is const.
As result, the temporary variable "root" in show_mountinfo() that
holds a copy of struct path root is no longer needed.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 fs/proc_namespace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5fe34c3..10aa92d 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -125,7 +125,6 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 	struct mount *r = real_mount(mnt);
 	struct super_block *sb = mnt->mnt_sb;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
-	struct path root = p->root;
 	int err = 0;
 
 	seq_printf(m, "%i %i %u:%u ", r->mnt_id, r->mnt_parent->mnt_id,
@@ -139,7 +138,7 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 	seq_putc(m, ' ');
 
 	/* mountpoints outside of chroot jail will give SEQ_SKIP on this */
-	err = seq_path_root(m, &mnt_path, &root, " \t\n\\");
+	err = seq_path_root(m, &mnt_path, &p->root, " \t\n\\");
 	if (err)
 		goto out;
 
-- 
ldv
