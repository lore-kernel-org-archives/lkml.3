Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbaLPD7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:59:22 -0500
Received: from pegasus3.altlinux.org ([194.107.17.103]:39969 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLPD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:59:21 -0500
Date: Tue, 16 Dec 2014 06:59:19 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v4 PATCH 1/2] vfs: cleanup show_mountinfo
Message-ID: <20141216035919.GB2461@altlinux.org>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140929180523.GC15829@altlinux.org>
 <20140929183222.GJ7996@ZenIV.linux.org.uk>
 <20140929184333.GD15829@altlinux.org>
 <20140929193329.GL7996@ZenIV.linux.org.uk>
 <20140929202659.GA16292@altlinux.org>
 <20140929212057.GN7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929212057.GN7996@ZenIV.linux.org.uk>
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
