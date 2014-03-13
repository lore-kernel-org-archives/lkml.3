Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaCMOeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:34:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54864 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaCMOem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:34:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,647,1389744000"; 
   d="scan'208";a="111026182"
From: Felipe Franciosi <felipe@paradoxo.org>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Felipe Franciosi <felipe@paradoxo.org>
Subject: [PATCH 1/2] mtip32xx: Set queue bounce limit
Date: Thu, 13 Mar 2014 14:34:20 +0000
Message-ID: <1394721261-2764-2-git-send-email-felipe@paradoxo.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394721261-2764-1-git-send-email-felipe@paradoxo.org>
References: <1394721261-2764-1-git-send-email-felipe@paradoxo.org>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to set the queue bounce limit during the device initialization to
prevent excessive bouncing on 32 bit architectures.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
---
 drivers/block/mtip32xx/mtip32xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5160269..787c9d3 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4213,6 +4213,7 @@ skip_create_disk:
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
 	blk_queue_max_segment_size(dd->queue, 0x400000);
 	blk_queue_io_min(dd->queue, 4096);
+	blk_queue_bounce_limit(dd->queue, dd->pdev->dma_mask);
 
 	/*
 	 * write back cache is not supported in the device. FUA depends on
-- 
1.7.10.4

