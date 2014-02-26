Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaBZS67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:58:59 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:55593 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbaBZS66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:58:58 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcGAMs4DlNXQ4FW/2dsb2JhbABagwbCA4EZF3SCaBwjGIECJBOHfQHJUo5UhD4EmDUBilKHVoMuOw
Date: Wed, 26 Feb 2014 19:58:55 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/befs/linuxvfs.c: add __init to
 befs_init_inodecache()
Message-Id: <20140226195855.d644665bae2b6dc7a61ca9bd@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_befs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/linuxvfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 845d2d6..ab4c61f 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -39,7 +39,6 @@ static struct dentry *befs_lookup(struct inode *, struct dentry *, unsigned int)
 static struct inode *befs_iget(struct super_block *, unsigned long);
 static struct inode *befs_alloc_inode(struct super_block *sb);
 static void befs_destroy_inode(struct inode *inode);
-static int befs_init_inodecache(void);
 static void befs_destroy_inodecache(void);
 static void *befs_follow_link(struct dentry *, struct nameidata *);
 static void *befs_fast_follow_link(struct dentry *, struct nameidata *);
@@ -445,7 +444,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
  *
  * Taken from NFS implementation by Al Viro.
  */
-static int
+static int __init
 befs_init_inodecache(void)
 {
 	befs_inode_cachep = kmem_cache_create("befs_inode_cache",
-- 
1.8.1.4
