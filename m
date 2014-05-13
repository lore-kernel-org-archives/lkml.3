Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbaEMK2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:28:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933404AbaEMKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Herve Codina <Herve.CODINA@celad.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 167/182] mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC
Date: Tue, 13 May 2014 11:28:39 +0200
Message-Id: <819dc664597b64ee562e4ae15faadf542b4eae8c.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herve Codina <Herve.CODINA@celad.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/nand/atmel_nand.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 9be079224761..1de054a0775d 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1249,6 +1249,7 @@ static int __init atmel_pmecc_nand_init_params(struct platform_device *pdev,
 		goto err;
 	}
 
+	nand_chip->options |= NAND_NO_SUBPAGE_WRITE;
 	nand_chip->ecc.read_page = atmel_nand_pmecc_read_page;
 	nand_chip->ecc.write_page = atmel_nand_pmecc_write_page;
 
-- 
1.9.3

