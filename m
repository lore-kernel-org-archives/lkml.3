Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaEORFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:05:32 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:57996 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbaEORFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:05:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMRAEPzdFNXQwiB/2dsb2JhbABZgwaDPqhaBAEBAQEBAQUBmhkCAoERF3SCUxMcIxiBAiQTiEUB0SyFVIh6hEcBA48qiiYBiw2IB4M4Ow
Date: Thu, 15 May 2014 19:05:26 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/hfsplus/wrapper.c: replace min/casting by min_t
Message-Id: <20140515190526.5aa91e3af48a2a558603841c@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add * before function comments (it was not detected by
kernel-doc)

Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hfsplus/wrapper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 3f99964..284c90f 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -24,8 +24,8 @@ struct hfsplus_wd {
 	u16 embed_count;
 };
 
-/*
- * hfsplus_submit_bio - Perfrom block I/O
+/**
+ * hfsplus_submit_bio - Perform block I/O
  * @sb: super block of volume for I/O
  * @sector: block to read or write, for blocks of HFSPLUS_SECTOR_SIZE bytes
  * @buf: buffer for I/O
@@ -234,7 +234,7 @@ reread:
 	sbi->alloc_blksz_shift = 0;
 	while ((blocksize >>= 1) != 0)
 		sbi->alloc_blksz_shift++;
-	blocksize = min(sbi->alloc_blksz, (u32)PAGE_SIZE);
+	blocksize = min_t(u32, sbi->alloc_blksz, PAGE_SIZE);
 
 	/*
 	 * Align block size to block offset.
-- 
1.8.4.5

