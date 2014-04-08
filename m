Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbaDHUFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:05:41 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:24884 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757588AbaDHUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:05:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMOAFRVRFNXQwqv/2dsb2JhbABZgwaCSYECE8FrAgKBIRd0glMTHCMYgQIkE4gAAcpqjmyEPwEDmFwBkkCDMjs
Date: Tue, 8 Apr 2014 22:07:09 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/befs/linuxvfs.c: Replace strncpy by strlcpy
Message-Id: <20140408220709.cbe214e1f24ef7a6022741ca@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strncpy + end of string assignment replaced by strlcpy

Cc: Andrew Morton <akpm@linuxfoundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/linuxvfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index d626756..1e27cd3 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -396,9 +396,8 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	if (S_ISLNK(inode->i_mode) && !(befs_ino->i_flags & BEFS_LONG_SYMLINK)){
 		inode->i_size = 0;
 		inode->i_blocks = befs_sb->block_size / VFS_BLOCK_SIZE;
-		strncpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
-			BEFS_SYMLINK_LEN - 1);
-		befs_ino->i_data.symlink[BEFS_SYMLINK_LEN - 1] = '\0';
+		strlcpy(befs_ino->i_data.symlink, raw_inode->data.symlink,
+			BEFS_SYMLINK_LEN);
 	} else {
 		int num_blks;
 
-- 
1.8.4.5

