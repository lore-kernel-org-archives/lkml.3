Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060Ab3GEOsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:48:43 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:32812 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab3GEOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:48:33 -0400
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
Subject: [PATCH v5 09/12] file locking: replace direct access of d_count with the d_count() helper
Date: Fri,  5 Jul 2013 10:48:22 -0400
Message-Id: <1373035702-40812-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the d_count change made in dcache.h, all readonly references
to d_count have to be changed to use the new d_count() helper as they
shouldn't access its value directly.  There is no change in logic
and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/locks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index cb424a4..755dd33 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1351,7 +1351,7 @@ int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
 	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 		goto out;
 	if ((arg == F_WRLCK)
-	    && ((dentry->d_count > 1)
+	    && ((d_count(dentry) > 1)
 		|| (atomic_read(&inode->i_count) > 1)))
 		goto out;
 
-- 
1.7.1

