Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaG2N0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:26:51 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60005 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaG2N0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:26:50 -0400
From: Raphael Poggi <poggi.raph@gmail.com>
To: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Raphael Poggi <poggi.raph@gmail.com>
Subject: [PATCH] mtd: atmel_nand: increase chip_delay
Date: Tue, 29 Jul 2014 15:27:27 +0200
Message-Id: <1406640447-9080-1-git-send-email-poggi.raph@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some nand with 8k page size like Micron MT29F32G08ABAAAWP need more than 20us.

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/mtd/nand/atmel_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index e321c56..77bd877 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -2099,7 +2099,7 @@ static int atmel_nand_probe(struct platform_device *pdev)
 	}
 
 	nand_chip->ecc.mode = host->board.ecc_mode;
-	nand_chip->chip_delay = 20;		/* 20us command delay time */
+	nand_chip->chip_delay = 40;		/* 40us command delay time */
 
 	if (host->board.bus_width_16)	/* 16-bit bus width */
 		nand_chip->options |= NAND_BUSWIDTH_16;
-- 
1.7.9.5

