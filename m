Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab3GQWz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892Ab3GQWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 088/145] ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
Date: Wed, 17 Jul 2013 15:47:00 -0700
Message-Id: <1374101277-7915-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit eaf3793728d07d995f1e74250b2d0005f7ae98b5 upstream.

On 32-bit archs when sector_t is defined as 32-bit the logic computing
data offset in ext4_inline_data_fiemap(). Fix that by properly typing
the shifted value.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 93a3408..f33fcb6 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1702,7 +1702,7 @@ int ext4_inline_data_fiemap(struct inode *inode,
 	if (error)
 		goto out;
 
-	physical = iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
+	physical = (__u64)iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
 	physical += (char *)ext4_raw_inode(&iloc) - iloc.bh->b_data;
 	physical += offsetof(struct ext4_inode, i_block);
 	length = i_size_read(inode);
-- 
1.8.1.2

