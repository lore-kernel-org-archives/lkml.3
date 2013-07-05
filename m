Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049Ab3GEOs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:48:28 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:22017 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964905Ab3GEOsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:48:22 -0400
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
Subject: [PATCH v5 06/12] coda-fs: replace direct access of d_count with the d_count() helper
Date: Fri,  5 Jul 2013 10:48:09 -0400
Message-Id: <1373035689-40716-1-git-send-email-Waiman.Long@hp.com>
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
 fs/coda/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index b7d3a05..c424e27 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -560,7 +560,7 @@ static int coda_dentry_revalidate(struct dentry *de, unsigned int flags)
 	if (cii->c_flags & C_FLUSH) 
 		coda_flag_inode_children(inode, C_FLUSH);
 
-	if (de->d_count > 1)
+	if (d_count(de) > 1)
 		/* pretend it's valid, but don't change the flags */
 		goto out;
 
-- 
1.7.1

