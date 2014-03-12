Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaCLQI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:08:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8564 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbaCLQIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:08:25 -0400
X-IronPort-AV: E=Sophos;i="4.97,639,1389744000"; 
   d="scan'208";a="109219600"
From: Felipe Franciosi <felipe@paradoxo.org>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        Felipe Franciosi <felipe@paradoxo.org>
Subject: [PATCH 1/2] mtip32xx: Don't bounce IO requests
Date: Wed, 12 Mar 2014 16:05:47 +0000
Message-ID: <1394640348-9109-2-git-send-email-felipe@paradoxo.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394640348-9109-1-git-send-email-felipe@paradoxo.org>
References: <1394640348-9109-1-git-send-email-felipe@paradoxo.org>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device support 64-bit DMA and therefore no IO requests needs bouncing.
On 32-bit systems, blk_queue_bounce() will bounce all IO requests with high
mem pages. This makes performance really really bad.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5160269..24c87fdb 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4082,8 +4082,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
 	if (likely(sg != NULL)) {
-		blk_queue_bounce(queue, &bio);
-
 		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
 			dev_warn(&dd->pdev->dev,
 				"Maximum number of SGL entries exceeded\n");
-- 
1.7.10.4

