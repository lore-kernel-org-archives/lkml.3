Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaBESAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:00:34 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:54396 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbaBESAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:00:33 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8TANp78lJbsmUx/2dsb2JhbABZKIJkgkN7E7wGAgKBDxd0glMTHCMYgQI3iAkBzy6OEWQdhCIBA4lHjmMBik+HUoM6L4Es
Date: Wed, 5 Feb 2014 18:01:48 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] adfs: Add __init macro to init_inodecache
Message-Id: <20140205180148.2e66a2e873cf76f6355a7454@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_adfs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/adfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 7b3003c..15796f8 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -265,7 +265,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	adfs_inode_cachep = kmem_cache_create("adfs_inode_cache",
 					     sizeof(struct adfs_inode_info),
-- 
1.8.1.4

