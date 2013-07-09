Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3GIBUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:20:24 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:37953 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3GIBRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:17:45 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v6 06/14] coda-fs: replace direct access of d_count with the d_count() helper
Date: Mon,  8 Jul 2013 21:09:56 -0400
Message-Id: <1373332204-10379-7-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All readonly references to d_count outside of the core dcache code
should be changed to use the new d_count() helper as they shouldn't
access its value directly.  There is no change in logic and everything
should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/coda/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 14a1480..190effc 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -526,7 +526,7 @@ static int coda_dentry_revalidate(struct dentry *de, unsigned int flags)
 	if (cii->c_flags & C_FLUSH) 
 		coda_flag_inode_children(inode, C_FLUSH);
 
-	if (de->d_count > 1)
+	if (d_count(de) > 1)
 		/* pretend it's valid, but don't change the flags */
 		goto out;
 
-- 
1.7.1

