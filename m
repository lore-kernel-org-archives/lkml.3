Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3C0Ksi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:48:38 -0400
Received: from multi.imgtec.com ([194.200.65.239]:5684 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab3C0Ksh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:48:37 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Jeff Dike <jdike@addtoit.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        "Richard Weinberger" <richard@nod.at>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/3] hostfs: use kmalloc instead of kzalloc
Date: Wed, 27 Mar 2013 10:47:14 +0000
Message-ID: <1364381234-22960-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364381234-22960-1-git-send-email-james.hogan@imgtec.com>
References: <1364381234-22960-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_10_48_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode info structure is zeroed at allocation with kzalloc, and then
all but one of the fields (including the largest, vfs_inode) are
initialised explicitly. Switch to using kmalloc and initialise the
remaining field too.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 fs/hostfs/hostfs_kern.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index f2372ef..32f35f1 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -228,10 +228,11 @@ static struct inode *hostfs_alloc_inode(struct super_block *sb)
 {
 	struct hostfs_inode_info *hi;
 
-	hi = kzalloc(sizeof(*hi), GFP_KERNEL);
+	hi = kmalloc(sizeof(*hi), GFP_KERNEL);
 	if (hi == NULL)
 		return NULL;
 	hi->fd = -1;
+	hi->mode = 0;
 	inode_init_once(&hi->vfs_inode);
 	return &hi->vfs_inode;
 }
-- 
1.8.1.2


