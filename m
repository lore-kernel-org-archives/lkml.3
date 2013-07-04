Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab3GDDek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:34:40 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:37419 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576Ab3GDDeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:34:37 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 09/12] file locking: rename d_count field of dentry to d_refcount
Date: Wed,  3 Jul 2013 23:34:23 -0400
Message-Id: <1372908863-33480-1-git-send-email-Waiman.Long@hp.com>
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
 fs/locks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index cb424a4..85ac6b7 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1351,7 +1351,7 @@ int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
 	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 		goto out;
 	if ((arg == F_WRLCK)
-	    && ((dentry->d_count > 1)
+	    && ((dentry->d_refcount > 1)
 		|| (atomic_read(&inode->i_count) > 1)))
 		goto out;
 
-- 
1.7.1

