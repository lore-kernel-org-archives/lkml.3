Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaBATLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:11:53 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:14221 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbaBATLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:11:51 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMUAMJG7VJbsmYT/2dsb2JhbABZKIJkgkOBDrsbAgKBBxd0glMTHCMYgQI3iAkBzQ6OJWQdhCIBA4lHjmIBik+HUoM6L4Es
Date: Sat, 1 Feb 2014 19:13:00 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH 1/1] ext3: Add __init macro to init_inodecache
Message-Id: <20140201191300.bf1332562e81082e8d7cfa53@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_ext3_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 37fd31e..94608d4 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -527,7 +527,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ext3_inode_cachep = kmem_cache_create("ext3_inode_cache",
 					     sizeof(struct ext3_inode_info),
-- 
1.8.1.4

