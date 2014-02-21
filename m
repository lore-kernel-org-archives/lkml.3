Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaBVHfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 02:35:47 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:48522 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbaBVHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 02:35:45 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQUAHlSCFNXQDo9/2dsb2JhbABaKIJegkd8E74CAgKBCxd0glMTHCMYgQIkE4gJAcsZF44AZIQ/AQOJRo5tAYpRh1aDOi+BLA
Date: Sat, 22 Feb 2014 07:37:09 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] affs: Add __init to init_inodecache ()
Message-Id: <20140222073709.55a4e35084de3c68fde79776@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_affs_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index d098731..41a7557 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -128,7 +128,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	affs_inode_cachep = kmem_cache_create("affs_inode_cache",
 					     sizeof(struct affs_inode_info),
-- 
1.8.1.4

