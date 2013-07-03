Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656Ab3GCUWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:22:16 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21430 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965518Ab3GCUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:22:10 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 20/25] nilfs2: Change how dentry's d_count field is accessed
Date: Wed,  3 Jul 2013 16:21:55 -0400
Message-Id: <1372882915-23173-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that use the
d_count field of the dentry structure need to be changed accordingly.
References to d_count are replaced by the d_ret_count() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/nilfs2/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c7d1f9f..b159761 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -973,7 +973,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 
 static int nilfs_tree_was_touched(struct dentry *root_dentry)
 {
-	return root_dentry->d_count > 1;
+	return d_ret_count(root_dentry) > 1;
 }
 
 /**
-- 
1.7.1

