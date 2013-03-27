Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3C0O3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:29:30 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:51732 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3C0O33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:29:29 -0400
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 22:29:28 +0800
Message-ID: <CAHgCKdX9_rxEj=MUNQNn9aLCwNaLCwV9WogOYiffRqyuh+TePw@mail.gmail.com>
Subject: [PATCH] mtd: m25p80: add support for Macronix chips
From: Jim-Ting Kuo <jimtingkuo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have changed and added JEDEC id of Macronix SPI flash to "m25p_ids" array.
This is using for the current Macronix's product. And I initialized Macronix
chip's status register to 0 which is need by some of Macronix chips. Thanks!

Signed-off-by: Jim Kuo <jimtingkuo@gmail.com>
---
 drivers/mtd/devices/m25p80.c |   47 ++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 5b6b072..3120062 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -743,16 +743,36 @@ static const struct spi_device_id m25p_ids[] = {
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
@@ -970,13 +990,14 @@ static int m25p_probe(struct spi_device *spi)
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
