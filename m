Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3FDWxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:53:54 -0400
Received: from 1wt.eu ([62.212.114.60]:35798 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab3FDWnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:50 -0400
Message-Id: <20130604172135.490740846@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 125/184] ext4: always set i_op in ext4_mknod()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit 6a08f447facb4f9e29fcc30fb68060bb5a0d21c2 upstream.

ext4_special_inode_operations have their own ifdef CONFIG_EXT4_FS_XATTR
to mask those methods. And ext4_iget also always sets it, so there is
an inconsistency.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 902f69b..828c9c9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1828,9 +1828,7 @@ retry:
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
1.7.12.2.21.g234cd45.dirty



