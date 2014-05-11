Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbaEKTZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:25:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbaEKTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herve Codina <Herve.CODINA@celad.com>, Josh Wu <josh.wu@atmel.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.10 39/48] mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC
Date: Sun, 11 May 2014 21:20:13 +0200
Message-Id: <20140511191953.392069907@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/atmel_nand.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1096,6 +1096,7 @@ static int __init atmel_pmecc_nand_init_
 		goto err_pmecc_data_alloc;
 	}
 
+	nand_chip->options |= NAND_NO_SUBPAGE_WRITE;
 	nand_chip->ecc.read_page = atmel_nand_pmecc_read_page;
 	nand_chip->ecc.write_page = atmel_nand_pmecc_write_page;
 


