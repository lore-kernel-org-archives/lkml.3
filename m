Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3A1FzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:55:20 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:7528 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790Ab3A1FzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:55:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH V3 2/3] mtd: add a new table for the unparsable nand chips
Date: Mon, 28 Jan 2013 12:57:18 +0800
Message-ID: <1359349039-11510-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359349039-11510-1-git-send-email-b32955@freescale.com>
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have 4 Toshiba nand chips which can not be parsed out by the
id data.  Add a new table for the unparsable nand chips.

It makes mess if we add these entries to the nand_flash_ids table.
The entries in the nand_flash_ids stands for a class of nand chips.
But the unparsable nand chips are just some singular chips.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_ids.c |   21 +++++++++++++++++++++
 include/linux/mtd/nand.h    |    1 +
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index 99949f6..4147c78 100644
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@ -12,6 +12,27 @@
 #include <linux/mtd/nand.h>
 #include <linux/sizes.h>
 
+/* This table uses the full ID data as the keyword. */
+struct nand_flash_dev nand_flash_full_ids[] = {
+	/* TOSHIBA */
+	{"TC58NVG2S0F 4G 3.3V 8-bit ",
+		{0x98, 0xdc, 0x90, 0x26, 0x76, 0x15, 0x01, 0x08},
+			SZ_4K, SZ_512, SZ_256K, 0, 8, 224},
+	{"TC58NVG3S0F 8G 3.3V 8-bit ",
+		{0x98, 0xd3, 0x90, 0x26, 0x76, 0x15, 0x02, 0x08},
+			SZ_4K, SZ_1K, SZ_256K, 0, 8, 232},
+	{"TC58NVG5D2 32G 3.3V 8-bit ",
+		{0x98, 0xd7, 0x94, 0x32, 0x76, 0x56, 0x09, 0x00},
+			SZ_8K, SZ_4K, SZ_1M, 0, 8, 640},
+	{"TC58NVG6D2 64G 3.3V 8-bit ",
+		{0x98, 0xde, 0x94, 0x82, 0x76, 0x56, 0x04, 0x20},
+			SZ_8K, SZ_8K, SZ_2M, 0, 8, 640},
+
+	/* end here */
+	{NULL,}
+};
+
+
 /*
 *	Chip ID list
 *
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index d8fd638..119c8e0 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -618,6 +618,7 @@ struct nand_manufacturers {
 };
 
 extern struct nand_flash_dev nand_flash_ids[];
+extern struct nand_flash_dev nand_flash_full_ids[];
 extern struct nand_manufacturers nand_manuf_ids[];
 
 extern int nand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd);
-- 
1.7.0.4


