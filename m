Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3G3PRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:17:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59890 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3G3PRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:17:45 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Josh Wu <josh.wu@atmel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH resend] MTD: atmel_nand: using a stronger ECC is not dangerous
Date: Tue, 30 Jul 2013 17:17:29 +0200
Message-Id: <1375197449-32370-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to issue a warning when a stronger error correting
capability is chosen.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Acked-by: Josh Wu <josh.wu@atmel.com>
---
It seems that this patch has been forgotten (even by me)
for some months. (was already acked by Josh then)
Reference of the discussion leading to this patch:
http://comments.gmane.org/gmane.linux.drivers.mtd/46342

 drivers/mtd/nand/atmel_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 2d23d29..2415cdc 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1002,7 +1002,7 @@ static int __init atmel_pmecc_nand_init_params(struct platform_device *pdev,
 		return err_no;
 	}
 
-	if (cap != host->pmecc_corr_cap ||
+	if (cap > host->pmecc_corr_cap ||
 			sector_size != host->pmecc_sector_size)
 		dev_info(host->dev, "WARNING: Be Caution! Using different PMECC parameters from Nand ONFI ECC reqirement.\n");
 
-- 
1.7.10.4

