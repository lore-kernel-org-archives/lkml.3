Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaBEUVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:21:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:55521 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbaBEUHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 176/213] ext4: always set i_op in ext4_mknod()
Date: Wed, 5 Feb 2014 15:02:11 -0500
Message-ID: <1391630568-49251-177-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6a08f447facb4f9e29fcc30fb68060bb5a0d21c2 upstream.

ext4_special_inode_operations have their own ifdef CONFIG_EXT4_FS_XATTR
to mask those methods. And ext4_iget also always sets it, so there is
an inconsistency.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 41198b355a26..683c0f9d8a83 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1825,9 +1825,7 @@ retry:
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
-#ifdef CONFIG_EXT4_FS_XATTR
 		inode->i_op = &ext4_special_inode_operations;
-#endif
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);
-- 
1.8.5.2

