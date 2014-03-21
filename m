Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbaCUQOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:14:54 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:64584 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760950AbaCUQOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:14:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkoOAM1kLFNbtAWg/2dsb2JhbABZgwaCSX4TwBMCAoEUF3SCUxMcIxiBAiQTh30B0AmOBmSEPwEDmEgBilmHWIMuPIEs
Date: Fri, 21 Mar 2014 17:16:26 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: reiserfs-devel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/reiserfs/super.c: add __init to init_inodecache
Message-Id: <20140321171626.d835c81af6c795cb3ae2fb6a@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_reiserfs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 2c80335..7035087 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -597,7 +597,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
 						  sizeof(struct
-- 
1.8.4.5

