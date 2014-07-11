Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaGKHnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:43:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42875 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaGKHnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:43:51 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: "Quadros, Roger" <rogerq@ti.com>, "tony@atomide.com" <tony@atomide.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "javier@dowhile0.org" <javier@dowhile0.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 02/10] mtd: nand: omap: Always use chip->ecc.steps
 for BCH sector count
Thread-Topic: [RFC PATCH 02/10] mtd: nand: omap: Always use chip->ecc.steps
 for BCH sector count
Thread-Index: AQHPm3KVDz8e8zy1kUmTJ61wG/WsCpuafKXQ
Date: Fri, 11 Jul 2014 07:43:13 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EB01DF7@DBDE04.ent.ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
 <1404909450-11970-3-git-send-email-rogerq@ti.com>
In-Reply-To: <1404909450-11970-3-git-send-email-rogerq@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Quadros, Roger
>
>Instead of hardcoding use the pre-calculated chip->ecc.steps for
>configuring number of sectors to process with the BCH algorithm.
>
>This also avoids unnecessary access to the ECC_CONFIG register in
>omap_calculate_ecc_bch().
>
>Signed-off-by: Roger Quadros <rogerq@ti.com>
>---
> drivers/mtd/nand/omap2.c | 9 +++------
> 1 file changed, 3 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
>index 5b8739c..6f3d7cd 100644
>--- a/drivers/mtd/nand/omap2.c
>+++ b/drivers/mtd/nand/omap2.c
>@@ -1066,10 +1066,10 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>*mtd, int mode)
> 	unsigned int ecc_size1, ecc_size0;
>
> 	/* GPMC configurations for calculating ECC */
>+	nsectors = chip->ecc.steps;
> 	switch (ecc_opt) {
> 	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
> 		bch_type = 0;
>-		nsectors = 1;
> 		if (mode == NAND_ECC_READ) {
> 			wr_mode	  = BCH_WRAPMODE_6;
> 			ecc_size0 = BCH_ECC_SIZE0;
>@@ -1082,7 +1082,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>*mtd, int mode)
> 		break;
> 	case OMAP_ECC_BCH4_CODE_HW:
> 		bch_type = 0;
>-		nsectors = chip->ecc.steps;
> 		if (mode == NAND_ECC_READ) {
> 			wr_mode	  = BCH_WRAPMODE_1;
> 			ecc_size0 = BCH4R_ECC_SIZE0;
>@@ -1095,7 +1094,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>*mtd, int mode)
> 		break;
> 	case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
> 		bch_type = 1;
>-		nsectors = 1;
> 		if (mode == NAND_ECC_READ) {
> 			wr_mode	  = BCH_WRAPMODE_6;
> 			ecc_size0 = BCH_ECC_SIZE0;
>@@ -1108,7 +1106,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>*mtd, int mode)
> 		break;
> 	case OMAP_ECC_BCH8_CODE_HW:
> 		bch_type = 1;
>-		nsectors = chip->ecc.steps;
> 		if (mode == NAND_ECC_READ) {
> 			wr_mode	  = BCH_WRAPMODE_1;
> 			ecc_size0 = BCH8R_ECC_SIZE0;
>@@ -1121,7 +1118,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info
>*mtd, int mode)
> 		break;
> 	case OMAP_ECC_BCH16_CODE_HW:
> 		bch_type = 0x2;
>-		nsectors = chip->ecc.steps;
> 		if (mode == NAND_ECC_READ) {
> 			wr_mode	  = 0x01;
> 			ecc_size0 = 52; /* ECC bits in nibbles per sector */
>@@ -1176,6 +1172,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
> {
> 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
> 						   mtd);
>+	struct nand_chip *chip = mtd->priv;
> 	int eccbytes	= info->nand.ecc.bytes;
> 	struct gpmc_nand_regs	*gpmc_regs = &info->reg;
> 	u8 *ecc_code;
>@@ -1183,7 +1180,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
> 	u32 val;
> 	int i, j;
>
>-	nsectors = ((readl(info->reg.gpmc_ecc_config) >> 4) & 0x7) + 1;
>+	nsectors = chip->ecc.steps;

Sorry NAK.. I'm sure you are breaking something here :-)

NAND driver supports multiple ECC schemes like;
OMAP_ECC_CODE_HAM1_HW (support for legacy reasons)
OMAP_ECC_CODE_BCH4_HW_DETECTION_SW (needed for OMAP3 and AM35xx)
OMAP_ECC_CODE_BCH4_HW
OMAP_ECC_CODE_BCH8_HW
OMAP_ECC_CODE_BCH8_HW_DETECTION_SW  (needed for OMAP3 and AM35xx)
OMAP_ECC_CODE_BCH16_HW

IIRC ..
- software based ecc-schemes OMAP_ECC_CODE_BCHx_HW_DETECTION_SW
  Reads/Write in per-sector granularity. (here nsector != chip->ecc.steps)

- hardware based ecc-schemes OMAP_ECC_CODE_BCHx_HW, perform
  Reads/Write in per-page granularity (or something like this).
  Therefore you have custom implementation of 
  chip->ecc.read_page = omap_read_page_bch()
 Also if you change the configurations here, it will break the compatibility with
 u-boot, so images flashed via u-boot will stop to boot in kernel and vice-versa.

I suggest, please refrain from these tweaks for now..
All these optimizations have been tested on multiple scenario so please test
all ecc-schemes before doing anything, otherwise you will end-up in
a bad loop of breaking and fixing NAND driver :-).


with regards, pekon
