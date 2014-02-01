Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaBAQAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 11:00:50 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:40622 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbaBAQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 11:00:49 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIVAIIZ7VJbsmYT/2dsb2JhbABZKIJkgkN7E7sbAgKBBxd0glMTHCMYgQI3iAkBzSKOJWQdhCIBA4lHjmIBik+HUoM6L4Es
Date: Sat, 1 Feb 2014 16:02:02 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
Subject: [PATCH 1/1] ext2: Add __init macro to init_inodecache
Message-Id: <20140201160202.a3ac96c613754013300b462d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_ext2_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 20d6697..73d80da 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -192,7 +192,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
 					     sizeof(struct ext2_inode_info),
-- 
1.8.1.4

