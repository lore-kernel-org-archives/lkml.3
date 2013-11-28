Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab3K1PFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:05:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36781 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3K1PF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:05:29 -0500
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        computersforpeace@gmail.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mxc_nand: remove redundant stat counting
Date: Thu, 28 Nov 2013 16:04:40 +0100
Message-Id: <1385651080-15562-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.8.4.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stats count variable will already be incremented
in the above framework-layer just after this callback.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/mtd/nand/mxc_nand.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 9dfdb06..a4bad11 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -677,7 +677,6 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
 		ecc_stat >>= 4;
 	} while (--no_subpages);
 
-	mtd->ecc_stats.corrected += ret;
 	pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
 
 	return ret;
-- 
1.8.4.3

