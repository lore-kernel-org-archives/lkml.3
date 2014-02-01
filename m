Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaBATIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:08:55 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:52985 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbaBATIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:08:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMUAChF7VJbsmYT/2dsb2JhbABZKIJkgkOBDrsbAgKBBxd0glMTHCMYgQI3iAkBzRiOJWQdhCIBA4lHjmIBik+HUoM6L4Es
Date: Sat, 1 Feb 2014 19:10:07 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH 1/1] ext4: Add __init macro to init_inodecache
Message-Id: <20140201191007.59012c84446860984e6c4a76@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_ext4_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1f7784d..9a387b8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -940,7 +940,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
 					     sizeof(struct ext4_inode_info),
-- 
1.8.1.4
