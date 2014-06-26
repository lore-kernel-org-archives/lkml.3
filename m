Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaFZUnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:43:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51452 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaFZUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:43:04 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, kernel@pengutronix.de
Subject: [PATCH 1/2] mxc_nand: fix err_limit and err_mask
Date: Thu, 26 Jun 2014 22:42:47 +0200
Message-Id: <1403815368-29469-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the error detection limits for the used
eccsize of the 1, 4 and 8 bit eccmode.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/mtd/nand/mxc_nand.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index cb6c845..7fd495e 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -657,10 +657,14 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
 	u32 ecc_stat, err;
 	int no_subpages = 1;
 	int ret = 0;
-	u8 ecc_bit_mask, err_limit;
+	u8 ecc_bit_mask, err_limit = 0x1;
 
-	ecc_bit_mask = (host->eccsize == 4) ? 0x7 : 0xf;
-	err_limit = (host->eccsize == 4) ? 0x4 : 0x8;
+	ecc_bit_mask = 0xf;
+
+	if (host->eccsize == 4)
+		err_limit = 0x2;
+	else if (host->eccsize == 8)
+		err_limit = 0x4;
 
 	no_subpages = mtd->writesize >> 9;
 
-- 
2.0.0

