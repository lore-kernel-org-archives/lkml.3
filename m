Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaEPUiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:38:21 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:33535 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbaEPUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:38:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgESAAl2dlNXQB71/2dsb2JhbABZgwaCQqgrCgUBmiYCAoEXF3SCUxMcIxiBAiQTiEUB0iiFVYh6hEcBA48tiioBkxmDOTs
Date: Fri, 16 May 2014 22:38:15 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: [PATCH V2 mmots] fs/hfsplus/wrapper.c: replace shift loop by fls
Message-Id: <20140516223815.88ffae2289f969381f176fdc@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace while blocksize;shift by fls -1

Suggested-By: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v2: rebased on top of mmots
    compiles without including bitops

 fs/hfsplus/wrapper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 284c90f..8e8cf50d 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -231,9 +231,7 @@ reread:
 	if (blocksize < HFSPLUS_SECTOR_SIZE || ((blocksize - 1) & blocksize))
 		goto out_free_backup_vhdr;
 	sbi->alloc_blksz = blocksize;
-	sbi->alloc_blksz_shift = 0;
-	while ((blocksize >>= 1) != 0)
-		sbi->alloc_blksz_shift++;
+	sbi->alloc_blksz_shift = fls(blocksize) - 1;
 	blocksize = min_t(u32, sbi->alloc_blksz, PAGE_SIZE);
 
 	/*
-- 
1.8.4.5

