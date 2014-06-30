Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaF3Cxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:53:35 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34913 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaF3Cxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:53:34 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 1/2] zram: use size_t instead of u16
Date: Mon, 30 Jun 2014 11:54:38 +0900
Message-Id: <1404096879-24529-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of arch(ex, hexagon and PowerPC) could use PAGE_SHIFT
as 16 above. In the case, u16 is is lack of representing
compressed page's size so use size_t.

Reported-by: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 089e72cd37be..3233bccd6361 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -337,7 +337,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle;
-	u16 size;
+	size_t size;
 
 	read_lock(&meta->tb_lock);
 	handle = meta->table[index].handle;
-- 
2.0.0

