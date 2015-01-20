Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbbATQdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:33:43 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47228 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbbATQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:33:40 -0500
Date: Tue, 20 Jan 2015 18:33:35 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: chris@printf.net
Cc: ulf.hansson@linaro.org, kuninori.morimoto.gx@renesas.com,
        ben@decadent.org.uk, joe@perches.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: block: fix format string warning
Message-ID: <20150120163335.GA5016@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warning (reported by cppcheck):
[drivers/mmc/card/block.c:2149]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/mmc/card/block.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 4409d79..8e1a60e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2147,7 +2147,7 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	 */
 
 	snprintf(md->disk->disk_name, sizeof(md->disk->disk_name),
-		 "mmcblk%d%s", md->name_idx, subname ? subname : "");
+		 "mmcblk%u%s", md->name_idx, subname ? subname : "");
 
 	if (mmc_card_mmc(card))
 		blk_queue_logical_block_size(md->queue.queue,
-- 
1.7.0.4

