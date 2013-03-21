Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab3CUQ2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:28:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57302 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab3CUQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:28:09 -0400
MIME-Version: 1.0
Date: Fri, 22 Mar 2013 00:28:07 +0800
Message-ID: <CAHgCKdWcvHyG2qYPx=2mTfRxH2J+3eh8ROK=+Jk2R2CNWBkhwg@mail.gmail.com>
Subject: [PATCH] mtd: m25p80: update flash id list of Macronix chips
From: Jim-Ting Kuo <jimtingkuo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Lavender <mike@steroidmicros.com>

I have changed and added Macronix's JEDEC id to "m25p_ids" array.
And initialized status register to 0 for using some Macronix devices.
Thank you!
Signed-off-by: Jim Kuo <jimtingkuo@gmail.com>
---
diff -uprN a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c	2013-03-22 00:11:50.554729702 +0800
+++ b/drivers/mtd/devices/m25p80.c	2013-03-22 00:23:25.502754241 +0800
@@ -743,16 +743,36 @@ static const struct spi_device_id m25p_i
 	{ "n25q064",  INFO(0x20ba17, 0, 64 * 1024, 128, 0) },

 	/* Macronix */
-	{ "mx25l2005a",  INFO(0xc22012, 0, 64 * 1024,   4, SECT_4K) },
-	{ "mx25l4005a",  INFO(0xc22013, 0, 64 * 1024,   8, SECT_4K) },
-	{ "mx25l8005",   INFO(0xc22014, 0, 64 * 1024,  16, 0) },
-	{ "mx25l1606e",  INFO(0xc22015, 0, 64 * 1024,  32, SECT_4K) },
-	{ "mx25l3205d",  INFO(0xc22016, 0, 64 * 1024,  64, 0) },
-	{ "mx25l6405d",  INFO(0xc22017, 0, 64 * 1024, 128, 0) },
-	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 0) },
-	{ "mx25l12855e", INFO(0xc22618, 0, 64 * 1024, 256, 0) },
-	{ "mx25l25635e", INFO(0xc22019, 0, 64 * 1024, 512, 0) },
-	{ "mx25l25655e", INFO(0xc22619, 0, 64 * 1024, 512, 0) },
+	{ "mx25l512e",   INFO(0xc22010, 0, 64 * 1024,    1, SECT_4K) },
+	{ "mx25l5121e",  INFO(0xc22210, 0, 64 * 1024,    1, SECT_4K) },
+	{ "mx25l1006e",  INFO(0xc22011, 0, 64 * 1024,    2, SECT_4K) },
+	{ "mx25l1021e",  INFO(0xc22211, 0, 64 * 1024,    2, SECT_4K) },
+	{ "mx25l2006e",  INFO(0xc22012, 0, 64 * 1024,    4, SECT_4K) },
+	{ "mx25l4006e",  INFO(0xc22013, 0, 64 * 1024,    8, SECT_4K) },
+	{ "mx25u4035",   INFO(0xc22533, 0, 64 * 1024,    8, SECT_4K) },
+	{ "mx25v4035",   INFO(0xc22553, 0, 64 * 1024,    8, SECT_4K) },
+	{ "mx25l8006e",  INFO(0xc22014, 0, 64 * 1024,   16, 0) },
+	{ "mx25u8035",   INFO(0xc22534, 0, 64 * 1024,   16, 0) },
+	{ "mx25v8035",   INFO(0xc22554, 0, 64 * 1024,   16, 0) },
+	{ "mx25l1606e",  INFO(0xc22015, 0, 64 * 1024,   32, 0) },
+	{ "mx25l1633e",  INFO(0xc22415, 0, 64 * 1024,   32, 0) },
+	{ "mx25l1635e",  INFO(0xc22515, 0, 64 * 1024,   32, 0) },
+	{ "mx25u1635e",  INFO(0xc22535, 0, 64 * 1024,   32, 0) },
+	{ "mx25l1655d",  INFO(0xc22615, 0, 64 * 1024,   32, 0) },
+	{ "mx25l3206e",  INFO(0xc22016, 0, 64 * 1024,   64, 0) },
+	{ "mx25l3239e",  INFO(0xc22536, 0, 64 * 1024,   64, 0) },
+	{ "mx25l3225d",  INFO(0xc25e16, 0, 64 * 1024,   64, 0) },
+	{ "mx25l3255d",  INFO(0xc29e16, 0, 64 * 1024,   64, 0) },
+	{ "mx25l6406e",  INFO(0xc22017, 0, 64 * 1024,  128, 0) },
+	{ "mx25l6439e",  INFO(0xc22537, 0, 64 * 1024,  128, 0) },
+	{ "mx25l6455e",  INFO(0xc22617, 0, 64 * 1024,  128, 0) },
+	{ "mx25l12806e", INFO(0xc22018, 0, 64 * 1024,  256, 0) },
+	{ "mx25u12835f", INFO(0xc22538, 0, 64 * 1024,  256, 0) },
+	{ "mx25l12855e", INFO(0xc22618, 0, 64 * 1024,  256, 0) },
+	{ "mx25l25635e", INFO(0xc22019, 0, 64 * 1024,  512, 0) },
+	{ "mx25u25635f", INFO(0xc22539, 0, 64 * 1024,  512, 0) },
+	{ "mx25l25655e", INFO(0xc22619, 0, 64 * 1024,  512, 0) },
+	{ "mx66l51235f", INFO(0xc2201a, 0, 64 * 1024, 1024, 0) },

 	/* Micron */
 	{ "n25q128a11",  INFO(0x20bb18, 0, 64 * 1024, 256, 0) },
@@ -970,13 +990,14 @@ static int m25p_probe(struct spi_device
 	dev_set_drvdata(&spi->dev, flash);

 	/*
-	 * Atmel, SST and Intel/Numonyx serial flash tend to power
-	 * up with the software protection bits set
+	 * Atmel, SST, Intel/Numonyx and Macronix serial flash tend
+	 * to power up with the software protection bits set
 	 */

 	if (JEDEC_MFR(info->jedec_id) == CFI_MFR_ATMEL ||
 	    JEDEC_MFR(info->jedec_id) == CFI_MFR_INTEL ||
-	    JEDEC_MFR(info->jedec_id) == CFI_MFR_SST) {
+	    JEDEC_MFR(info->jedec_id) == CFI_MFR_SST   ||
+	    JEDEC_MFR(info->jedec_id) == CFI_MFR_MACRONIX) {
 		write_enable(flash);
 		write_sr(flash, 0);
 	}
