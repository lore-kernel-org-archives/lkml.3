Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3K2NPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:15:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3K2NPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:15:03 -0500
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        computersforpeace@gmail.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] mxc_nand: remove duplicated ecc_stats counting
Date: Fri, 29 Nov 2013 14:14:29 +0100
Message-Id: <1385730869-2322-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.8.4.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ecc_stats.corrected count variable will already be incremented in
the above framework-layer just after this callback.

Cc: stable@vger.kernel.org
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

