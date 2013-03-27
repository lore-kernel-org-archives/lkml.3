Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3C0Ksp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:48:45 -0400
Received: from multi.imgtec.com ([194.200.65.239]:5693 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab3C0Ksn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:48:43 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Jeff Dike <jdike@addtoit.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        "Richard Weinberger" <richard@nod.at>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 1/3] hostfs: remove "will unlock" comment
Date: Wed, 27 Mar 2013 10:47:12 +0000
Message-ID: <1364381234-22960-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364381234-22960-1-git-send-email-james.hogan@imgtec.com>
References: <1364381234-22960-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_10_48_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A "will unlock" comment was added to hostfs in the following commit,
along with a spinlock:

Commit e9193059b1b3733695d5b80e667778311695aa73 ("hostfs: fix races in
dentry_name() and inode_name()").

But the spinlock was subsequently removed in the following commit:

Commit ec2447c278ee973d35f38e53ca16ba7f965ae33d ("hostfs: simplify
locking").

Since the comment is no longer applicable, remove it.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Nick Piggin <npiggin@kernel.dk>
---
 fs/hostfs/hostfs_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 0f6e52d..95b9c87 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -121,7 +121,7 @@ static char *dentry_name(struct dentry *dentry)
 	if (!name)
 		return NULL;
 
-	return __dentry_name(dentry, name); /* will unlock */
+	return __dentry_name(dentry, name);
 }
 
 static char *inode_name(struct inode *ino)
-- 
1.8.1.2


