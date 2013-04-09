Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980Ab3DIIGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:06:53 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61841 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889Ab3DIIGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:06:46 -0400
Message-ID: <5163CC0F.2000400@gmail.com>
Date: Tue, 09 Apr 2013 16:06:39 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] vfs: Remove the unnecessary protect.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After allocating a inode,it don't chain in superblock.At this time,it
won't be used by others.So it make no sense to protect there.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
fs/inode.c | 2 --
1 file changed, 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index f5f7c06..1d7b0dd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -906,9 +906,7 @@ struct inode *new_inode_pseudo(struct super_block *sb)
struct inode *inode = alloc_inode(sb);

if (inode) {
- spin_lock(&inode->i_lock);
inode->i_state = 0;
- spin_unlock(&inode->i_lock);
INIT_LIST_HEAD(&inode->i_sb_list);
}
return inode;
-- 
1.8.2.rc2.4.g7799588

