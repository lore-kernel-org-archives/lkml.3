Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaETQnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:43:37 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:60322 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbaETQng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:43:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYWAPOEe1NbsnsG/2dsb2JhbABZgwaCRKhEBAEBAQEBAQUBgzqWbgICgRwXdIJTEz8YgQIkE4hFAdQbhVWIeYRHAQOPPIorAZMggzo7
Date: Tue, 20 May 2014 18:43:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: [PATCH V3 mmots] fs/hfsplus/wrapper.c: replace shift loop by ilog2
Message-Id: <20140520184334.9e903b4965a5776eb0e771e2@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace while blocksize;shift by ilog2

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v3: replace fls by ilog2 to avoid headaches :)
v2: rebased on top of mmots

 fs/hfsplus/wrapper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 284c90f..cc62356 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -231,9 +231,7 @@ reread:
 	if (blocksize < HFSPLUS_SECTOR_SIZE || ((blocksize - 1) & blocksize))
 		goto out_free_backup_vhdr;
 	sbi->alloc_blksz = blocksize;
-	sbi->alloc_blksz_shift = 0;
-	while ((blocksize >>= 1) != 0)
-		sbi->alloc_blksz_shift++;
+	sbi->alloc_blksz_shift = ilog2(blocksize);
 	blocksize = min_t(u32, sbi->alloc_blksz, PAGE_SIZE);
 
 	/*
-- 
1.8.4.5
