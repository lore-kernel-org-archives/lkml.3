Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbaEMKXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:23:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933463AbaEMKL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Franciosi <felipe@paradoxo.org>,
        Jens Axboe <axboe@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 103/182] mtip32xx: Set queue bounce limit
Date: Tue, 13 May 2014 11:27:35 +0200
Message-Id: <b217cdeb5dbb797e4bdabd3a7271005d238eca8f.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Franciosi <felipe@paradoxo.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1044b1bb9278f2e656a1a7b63dc24a59506540aa upstream.

We need to set the queue bounce limit during the device initialization to
prevent excessive bouncing on 32 bit architectures.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/mtip32xx/mtip32xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 952dbfe22126..bd3d20741958 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4040,6 +4040,7 @@ skip_create_disk:
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
 	blk_queue_max_segment_size(dd->queue, 0x400000);
 	blk_queue_io_min(dd->queue, 4096);
+	blk_queue_bounce_limit(dd->queue, dd->pdev->dma_mask);
 
 	/*
 	 * write back cache is not supported in the device. FUA depends on
-- 
1.9.3

