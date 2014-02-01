Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaBAPoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 10:44:07 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:5501 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485AbaBAPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 10:44:05 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIVAPwV7VJbsmYT/2dsb2JhbABZKIJkgkN7E7sbAgKBBhd0glMTHCMYgQI3iAkBzQkXjiVkHYQiAQOJR45iAYpPh1KDOi+BLA
Date: Sat, 1 Feb 2014 15:45:18 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, akpm@linux-foundation.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject: [PATCH 1/1] udf: Add __init macro to init_inodecache
Message-Id: <20140201154518.517605f64016ed42e9786f84@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_udf_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/udf/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3306b9f..6a14649 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -175,7 +175,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
 					     sizeof(struct udf_inode_info),
-- 
1.8.1.4

