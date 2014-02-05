Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaBFGDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 01:03:00 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:2438 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbaBFGCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 01:02:45 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApERADkl81JXQyV0/2dsb2JhbABZKIJkgkN7E7whAgKBBhd0glMTHCMYgQI3iAkBzmyOEWQdhCIBA4lHjmMBik+HUoM6L4Es
Date: Thu, 6 Feb 2014 06:03:40 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] minix: Add __init macro to init_inodecache
Message-Id: <20140206060340.7569075d89572c359e2569bf@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_minix_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/minix/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 0332109..d10aeee 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -86,7 +86,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	minix_inode_cachep = kmem_cache_create("minix_inode_cache",
 					     sizeof(struct minix_inode_info),
-- 
1.8.1.4

