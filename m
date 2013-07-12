Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3GLVtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:49:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49636 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3GLVtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:49:19 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <rmk@arm.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
Subject: [RFC/RFT PATCH 1/5] block: Rename parameter dma_mask to max_addr for blk_queue_bounce_limit()
Date: Fri, 12 Jul 2013 17:48:10 -0400
Message-ID: <1373665694-7580-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk_queue_bounce_limit() API parameter 'dma_mask' is actually the
maximum address the device can handle rather than a dma_mask. Rename
it accordingly to avoid it being interpreted as dma_mask.

No functional change.

The idea is to fix the bad assumptions about dma_mask wherever it could
be miss-interpreted.

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 block/blk-settings.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c50ecf0..026c151 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -195,17 +195,17 @@ EXPORT_SYMBOL(blk_queue_make_request);
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
  * @q: the request queue for the device
- * @dma_mask: the maximum address the device can handle
+ * @max_addr: the maximum address the device can handle
  *
  * Description:
  *    Different hardware can have different requirements as to what pages
  *    it can do I/O directly to. A low level driver can call
  *    blk_queue_bounce_limit to have lower memory pages allocated as bounce
- *    buffers for doing I/O to pages residing above @dma_mask.
+ *    buffers for doing I/O to pages residing above @max_addr.
  **/
-void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
+void blk_queue_bounce_limit(struct request_queue *q, u64 max_addr)
 {
-	unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
+	unsigned long b_pfn = max_addr >> PAGE_SHIFT;
 	int dma = 0;
 
 	q->bounce_gfp = GFP_NOIO;
-- 
1.7.9.5

