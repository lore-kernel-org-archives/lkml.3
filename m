Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaEBPoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:44:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbaEBPoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Franciosi <felipe@paradoxo.org>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 047/151] mtip32xx: Set queue bounce limit
Date: Fri,  2 May 2014 08:37:15 -0700
Message-Id: <1399045139-4531-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Franciosi <felipe@paradoxo.org>

commit 1044b1bb9278f2e656a1a7b63dc24a59506540aa upstream.

We need to set the queue bounce limit during the device initialization to
prevent excessive bouncing on 32 bit architectures.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 050c712..2730722 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4145,6 +4145,7 @@ skip_create_disk:
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
 	blk_queue_max_segment_size(dd->queue, 0x400000);
 	blk_queue_io_min(dd->queue, 4096);
+	blk_queue_bounce_limit(dd->queue, dd->pdev->dma_mask);
 
 	/*
 	 * write back cache is not supported in the device. FUA depends on
-- 
1.9.1

