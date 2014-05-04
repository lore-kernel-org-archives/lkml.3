Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaEDQBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:01:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbaEDPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Franciosi <felipe@paradoxo.org>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 76/86] mtip32xx: Set queue bounce limit
Date: Sun,  4 May 2014 11:41:51 -0400
Message-Id: <20140504154150.778609839@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Franciosi <felipe@paradoxo.org>

commit 1044b1bb9278f2e656a1a7b63dc24a59506540aa upstream.

We need to set the queue bounce limit during the device initialization to
prevent excessive bouncing on 32 bit architectures.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/mtip32xx/mtip32xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4040,6 +4040,7 @@ skip_create_disk:
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
 	blk_queue_max_segment_size(dd->queue, 0x400000);
 	blk_queue_io_min(dd->queue, 4096);
+	blk_queue_bounce_limit(dd->queue, dd->pdev->dma_mask);
 
 	/*
 	 * write back cache is not supported in the device. FUA depends on


