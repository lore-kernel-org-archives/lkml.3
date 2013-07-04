Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab3GDDeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:34:31 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:19297 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599Ab3GDDe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:34:29 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 08/12] ecrypt-fs: rename d_count field of dentry to d_refcount
Date: Wed,  3 Jul 2013 23:34:14 -0400
Message-Id: <1372908854-33447-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the d_count name change made in dcache.h, all references
to d_count have to be changed to d_refcount.  There is no change in
logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/ecryptfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 5eab400..e35d0fa 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -358,7 +358,7 @@ static int ecryptfs_lookup_interpose(struct dentry *dentry,
 
 	lower_mnt = mntget(ecryptfs_dentry_to_lower_mnt(dentry->d_parent));
 	fsstack_copy_attr_atime(dir_inode, lower_dentry->d_parent->d_inode);
-	BUG_ON(!lower_dentry->d_count);
+	BUG_ON(!lower_dentry->d_refcount);
 
 	ecryptfs_set_dentry_private(dentry, dentry_info);
 	ecryptfs_set_dentry_lower(dentry, lower_dentry);
-- 
1.7.1

