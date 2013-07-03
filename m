Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585Ab3GCUVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:53 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21300 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965569Ab3GCUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:49 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 16/25] vfat: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:21:36 -0400
Message-Id: <1372882896-23045-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that
use the d_lock field of the dentry structure need to be changed
accordingly. All the d_lock's spin_lock() and spin_unlock() calls
are replaced by the corresponding d_lock() and d_unlock() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/fat/namei_vfat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 2da9520..722ca30 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -34,10 +34,10 @@
 static int vfat_revalidate_shortname(struct dentry *dentry)
 {
 	int ret = 1;
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (dentry->d_time != dentry->d_parent->d_inode->i_version)
 		ret = 0;
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 	return ret;
 }
 
-- 
1.7.1

