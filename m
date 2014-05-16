Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaEPPxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:53:35 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:1241 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbaEPPxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:53:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjASAD0zdlNXQB71/2dsb2JhbABZgwaCQqgmBQUFAZoZAgKBFhd0glMTHCMYgQIkE4hFAdIphVWIeoRHAQOPLYoqAZMZgzk7
Date: Fri, 16 May 2014 17:53:31 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: [PATCH 1/1] fs/hfsplus/wrapper.c: replace shift loop by fls
Message-Id: <20140516175331.96c0738a10d583d196c44d6c@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace while blocksize;shift by fls - 1

Suggested-By: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hfsplus/wrapper.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 3f99964..9a7040e 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -8,6 +8,7 @@
  * Handling of HFS wrappers around HFS+ volumes
  */
 
+#include <linux/bitops.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/cdrom.h>
@@ -231,9 +232,7 @@ reread:
 	if (blocksize < HFSPLUS_SECTOR_SIZE || ((blocksize - 1) & blocksize))
 		goto out_free_backup_vhdr;
 	sbi->alloc_blksz = blocksize;
-	sbi->alloc_blksz_shift = 0;
-	while ((blocksize >>= 1) != 0)
-		sbi->alloc_blksz_shift++;
+	sbi->alloc_blksz_shift = fls(blocksize) - 1;
 	blocksize = min(sbi->alloc_blksz, (u32)PAGE_SIZE);
 
 	/*
-- 
1.8.4.5

