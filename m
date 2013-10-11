Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3JKEOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 00:14:47 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48966 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3JKEOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 00:14:46 -0400
Date: Fri, 11 Oct 2013 12:14:28 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH] null_blk: fix a bug in capacity calculation
Message-ID: <20131011041428.GB1692@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the capacity calculation is obvious buggy.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/block/null_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: master/drivers/block/null_blk.c
===================================================================
--- master.orig/drivers/block/null_blk.c	2013-10-11 12:08:49.625163094 +0800
+++ master/drivers/block/null_blk.c	2013-10-11 12:08:49.625163094 +0800
@@ -555,7 +555,7 @@ err:
 	blk_queue_physical_block_size(nullb->q, bs);
 
 	size = gb * 1024 * 1024 * 1024ULL;
-	size = sector_div(size, bs);
+	sector_div(size, bs);
 	set_capacity(disk, size);
 
 	disk->flags |= GENHD_FL_EXT_DEVT;
