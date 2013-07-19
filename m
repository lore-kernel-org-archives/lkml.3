Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426Ab3GSFWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:22:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965391Ab3GSFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [ 30/38] ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
Date: Thu, 18 Jul 2013 22:21:46 -0700
Message-Id: <20130719052049.933148744@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit eaf3793728d07d995f1e74250b2d0005f7ae98b5 upstream.

On 32-bit archs when sector_t is defined as 32-bit the logic computing
data offset in ext4_inline_data_fiemap(). Fix that by properly typing
the shifted value.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1702,7 +1702,7 @@ int ext4_inline_data_fiemap(struct inode
 	if (error)
 		goto out;
 
-	physical = iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
+	physical = (__u64)iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
 	physical += (char *)ext4_raw_inode(&iloc) - iloc.bh->b_data;
 	physical += offsetof(struct ext4_inode, i_block);
 	length = i_size_read(inode);


