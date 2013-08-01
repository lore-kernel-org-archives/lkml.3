Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3HAWVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:21:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39846 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3HAWVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:21:41 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC 47/51] ARM: 7794/1: block: Rename parameter dma_mask to
 max_addr for blk_queue_bounce_limit()
Message-Id: <E1V51FC-0006uT-GG@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:21:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk_queue_bounce_limit() API parameter 'dma_mask' is actually the
maximum address the device can handle rather than a dma_mask. Rename
it accordingly to avoid it being interpreted as dma_mask.

No functional change.

The idea is to fix the bad assumptions about dma_mask wherever it could
be miss-interpreted.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 block/blk-settings.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

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
1.7.4.4

