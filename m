Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab3GDDeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:34:16 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17771 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab3GDDeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:34:13 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 06/12] coda-fs: rename d_count field of dentry to d_refcount
Date: Wed,  3 Jul 2013 23:33:50 -0400
Message-Id: <1372908830-33381-1-git-send-email-Waiman.Long@hp.com>
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
 fs/coda/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index b7d3a05..4bf9574 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -560,7 +560,7 @@ static int coda_dentry_revalidate(struct dentry *de, unsigned int flags)
 	if (cii->c_flags & C_FLUSH) 
 		coda_flag_inode_children(inode, C_FLUSH);
 
-	if (de->d_count > 1)
+	if (de->d_refcount > 1)
 		/* pretend it's valid, but don't change the flags */
 		goto out;
 
@@ -575,7 +575,7 @@ out:
 }
 
 /*
- * This is the callback from dput() when d_count is going to 0.
+ * This is the callback from dput() when d_refcount is going to 0.
  * We use this to unhash dentries with bad inodes.
  */
 static int coda_dentry_delete(const struct dentry * dentry)
-- 
1.7.1

