Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaEAJ7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:59:15 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:60877 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbaEAJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:39 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 46/47] mtd: nand: stm_nand_bch: finalise setup by calling and_scan_tail()
Date: Thu,  1 May 2014 10:56:53 +0100
Message-Id: <1398938214-17847-47-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index bec7e23..e7a4bed 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -2315,6 +2315,10 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	err = nand_scan_tail(mtd);
+	if (err)
+		return err;
+
 	nandi_dump_bad_blocks(nandi);
 
 	/* Add partitions */
-- 
1.8.3.2

