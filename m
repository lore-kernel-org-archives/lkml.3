Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3GIBR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:17:57 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:37990 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3GIBRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:17:51 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v6 11/14] nilfs2: replace direct access of d_count with the d_count() helper
Date: Mon,  8 Jul 2013 21:10:01 -0400
Message-Id: <1373332204-10379-12-git-send-email-Waiman.Long@hp.com>
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
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1427de5..af3ba04 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -996,7 +996,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 
 static int nilfs_tree_was_touched(struct dentry *root_dentry)
 {
-	return root_dentry->d_count > 1;
+	return d_count(root_dentry) > 1;
 }
 
 /**
-- 
1.7.1

