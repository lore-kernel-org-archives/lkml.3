Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaEBQHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:07:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaEBPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herve Codina <Herve.CODINA@celad.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/151] mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC
Date: Fri,  2 May 2014 08:37:08 -0700
Message-Id: <1399045139-4531-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <Herve.CODINA@celad.com>

commit 90445ff6241e2a13445310803e2efa606c61f276 upstream.

Crash detected on sam5d35 and its pmecc nand ecc controller.

The problem was a call to chip->ecc.hwctl from nand_write_subpage_hwecc
(nand_base.c) when we write a sub page.
chip->ecc.hwctl function is not set when we are using PMECC controller.
As a workaround, set NAND_NO_SUBPAGE_WRITE for PMECC controller in
order to disable sub page access in nand_write_page.

Signed-off-by: Herve Codina <Herve.CODINA@celad.com>
Acked-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/nand/atmel_nand.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 59f08c4..1974009 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1220,6 +1220,7 @@ static int atmel_pmecc_nand_init_params(struct platform_device *pdev,
 		goto err;
 	}
 
+	nand_chip->options |= NAND_NO_SUBPAGE_WRITE;
 	nand_chip->ecc.read_page = atmel_nand_pmecc_read_page;
 	nand_chip->ecc.write_page = atmel_nand_pmecc_write_page;
 
-- 
1.9.1

