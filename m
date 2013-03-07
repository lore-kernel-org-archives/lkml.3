Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3CGKwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:52:25 -0500
Received: from [65.55.88.12] ([65.55.88.12]:21361 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932599Ab3CGKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:52:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH V4 2/3] mtd: add 4 Toshiba nand chips for the full-id case
Date: Thu, 7 Mar 2013 18:49:23 +0800
Message-ID: <1362653364-29993-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1362653364-29993-1-git-send-email-b32955@freescale.com>
References: <1362653364-29993-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have 4 Toshiba nand chips which can not be parsed out by the
id data. We can not get the oob size from the id data. So add them
as the full-id nand chips in the first of nand_flash_ids.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_ids.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index 625bc89..7805271 100644
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@ -10,6 +10,7 @@
  */
 #include <linux/module.h>
 #include <linux/mtd/nand.h>
+#include <linux/sizes.h>
 
 #define LP_OPTIONS NAND_SAMSUNG_LP_OPTIONS
 #define LP_OPTIONS16 (LP_OPTIONS | NAND_BUSWIDTH_16)
@@ -22,6 +23,20 @@
  * extended chip ID.
  */
 struct nand_flash_dev nand_flash_ids[] = {
+	/* TOSHIBA */
+	{"TC58NVG2S0F 4G 3.3V 8-bit",
+		{ .id = {0x98, 0xdc, 0x90, 0x26, 0x76, 0x15, 0x01, 0x08}},
+			SZ_4K, SZ_512, SZ_256K, 0, 8, 224},
+	{"TC58NVG3S0F 8G 3.3V 8-bit",
+		{ .id = {0x98, 0xd3, 0x90, 0x26, 0x76, 0x15, 0x02, 0x08}},
+			SZ_4K, SZ_1K, SZ_256K, 0, 8, 232},
+	{"TC58NVG5D2 32G 3.3V 8-bit",
+		{ .id = {0x98, 0xd7, 0x94, 0x32, 0x76, 0x56, 0x09, 0x00}},
+			SZ_8K, SZ_4K, SZ_1M, 0, 8, 640},
+	{"TC58NVG6D2 64G 3.3V 8-bit",
+		{ .id = {0x98, 0xde, 0x94, 0x82, 0x76, 0x56, 0x04, 0x20}},
+			SZ_8K, SZ_8K, SZ_2M, 0, 8, 640},
+
 	LEGACY_ID_NAND("NAND 4MiB 5V 8-bit",   0x6B, 512, 4, 0x2000, 0),
 	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE3, 512, 4, 0x2000, 0),
 	LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE5, 512, 4, 0x2000, 0),
-- 
1.7.1


