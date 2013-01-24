Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3AXHI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:08:57 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:25749
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189Ab3AXHIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:08:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <shmulik.ladkani@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 2/3] mtd: add a new table for the unparsable nand chips
Date: Thu, 24 Jan 2013 14:11:40 +0800
Message-ID: <1359007901-26464-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359007901-26464-1-git-send-email-b32955@freescale.com>
References: <1359007901-26464-1-git-send-email-b32955@freescale.com>
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
 drivers/mtd/nand/nand_ids.c |   22 ++++++++++++++++++++++
 include/linux/mtd/nand.h    |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index 9dc2e54..c1e32d2 100644
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@ -11,6 +11,28 @@
 #include <linux/module.h>
 #include <linux/mtd/nand.h>
 #include <linux/sizes.h>
+#include <linux/sizes.h>
+
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
 
 /*
 *	Chip ID list
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 5293447..346a389 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -620,6 +620,7 @@ struct nand_manufacturers {
 };
 
 extern struct nand_flash_dev nand_flash_ids[];
+extern struct nand_flash_dev nand_flash_full_ids[];
 extern struct nand_manufacturers nand_manuf_ids[];
 
 extern int nand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd);
-- 
1.7.0.4


