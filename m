Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaI2SOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:14:01 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:52965 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaI2SNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:13:16 -0400
Date: Mon, 29 Sep 2014 22:05:06 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v3 PATCH 2/3] vfs: cleanup show_mountinfo
Message-ID: <20140929180506.GB15829@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 17 Oct 2012 20:29:36 +0400

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
index 73ca174..789e8d1 100644
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

