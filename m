Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965264Ab3GCUVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:02 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11592 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964882Ab3GCUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:20:58 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 07/25] afs-fs: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:20:44 -0400
Message-Id: <1372882844-22747-1-git-send-email-Waiman.Long@hp.com>
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
 fs/afs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 7a465ed..fa235e0 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -705,9 +705,9 @@ out_skip:
 
 	/* the dirent, if it exists, now points to a different vnode */
 not_found:
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	dentry->d_flags |= DCACHE_NFSFS_RENAMED;
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 
 out_bad:
 	if (dentry->d_inode) {
-- 
1.7.1

