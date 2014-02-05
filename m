Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaBER4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:56:25 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:15821 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbaBER4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:56:20 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8TALd68lJbsmUx/2dsb2JhbABZKIJkgkN7E7wGAgKBDxd0glMTHCMYgQI3iAkBzyyOEWQdhCIBA4lHjmMBik+HUoM6L4Es
Date: Wed, 5 Feb 2014 17:57:32 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk,
        dushistov@mail.ru, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] ufs: Add __init macro to init_inodecache
Message-Id: <20140205175732.5ed98d96a96d544e5eac974d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_ufs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 329f2f5..5a7502e 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1453,7 +1453,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
 					     sizeof(struct ufs_inode_info),
-- 
1.8.1.4

