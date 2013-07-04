Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab3GDDeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:34:23 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17832 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab3GDDeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:34:21 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Joel Becker <jlbec@evilplan.org>, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 07/12] config-fs: rename d_count field of dentry to d_refcount
Date: Wed,  3 Jul 2013 23:34:05 -0400
Message-Id: <1372908845-33414-1-git-send-email-Waiman.Long@hp.com>
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
 fs/configfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7aabc6a..b70c8f0 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -387,7 +387,7 @@ static void remove_dir(struct dentry * d)
 	if (d->d_inode)
 		simple_rmdir(parent->d_inode,d);
 
-	pr_debug(" o %s removing done (%d)\n",d->d_name.name, d->d_count);
+	pr_debug(" o %s removing done (%d)\n", d->d_name.name, d->d_refcount);
 
 	dput(parent);
 }
-- 
1.7.1

