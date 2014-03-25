Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaCYXtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:49:16 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41175 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaCYXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:49:12 -0400
From: Gwendal Grignou <gwendal@chromium.org>
To: axboe@kernel.dk, ulf.hansson@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH 1/4] Limit max_discard_sectors to UINT_MAX>>9
Date: Tue, 25 Mar 2014 16:48:23 -0700
Message-Id: <1395791307-23727-2-git-send-email-gwendal@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1395791307-23727-1-git-send-email-gwendal@chromium.org>
References: <1395791307-23727-1-git-send-email-gwendal@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_discard_sectors can not be larger than UINT_MAX>>9,
otherwise, there is a risk that discard requests would be merged
into a request larger than 4GB.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 2dc3b51..f30128b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -859,7 +859,7 @@ static int __init nbd_init(void)
 		 */
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
 		disk->queue->limits.discard_granularity = 512;
-		disk->queue->limits.max_discard_sectors = UINT_MAX;
+		disk->queue->limits.max_discard_sectors = UINT_MAX >> 9;
 		disk->queue->limits.discard_zeroes_data = 0;
 		blk_queue_max_hw_sectors(disk->queue, 65536);
 		disk->queue->limits.max_sectors = 256;
-- 
1.9.1.423.g4596e3a

