Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LYMma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 07:42:30 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:15932 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3LYMm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 07:42:29 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Huang Shijie <b32955@freescale.com>,
        "David Woodhouse" <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH] mtd: nand: remove unused function input parameter
Thread-Topic: [PATCH] mtd: nand: remove unused function input parameter
Thread-Index: Ac8BbmbvHlDAbJJEQNqq2OCP1jOJfQ==
Date: Wed, 25 Dec 2013 12:40:50 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E47D50@SZXEMA512-MBX.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>
Date: Wed, 25 Dec 2013 20:11:15 +0800
Subject: [PATCH] mtd: nand: remove unused function input parameter

The nand_get_flash_type parameter "busw" input value is not used by any
branch, and it is updated before use it in the function, so remove it, 
define the "busw" as an internal variable.

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 drivers/mtd/nand/nand_base.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 9b3bb3c..a123afa 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3337,10 +3337,10 @@ static bool find_full_id_nand(struct mtd_info *mtd, struct nand_chip *chip,
  */
 static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 						  struct nand_chip *chip,
-						  int busw,
 						  int *maf_id, int *dev_id,
 						  struct nand_flash_dev *type)
 {
+	int busw;
 	int i, maf_idx;
 	u8 id_data[8];
 
@@ -3497,18 +3497,16 @@ ident_done:
 int nand_scan_ident(struct mtd_info *mtd, int maxchips,
 		    struct nand_flash_dev *table)
 {
-	int i, busw, nand_maf_id, nand_dev_id;
+	int i, nand_maf_id, nand_dev_id;
 	struct nand_chip *chip = mtd->priv;
 	struct nand_flash_dev *type;
 
-	/* Get buswidth to select the correct functions */
-	busw = chip->options & NAND_BUSWIDTH_16;
 	/* Set the default functions */
-	nand_set_defaults(chip, busw);
+	nand_set_defaults(chip, chip->options & NAND_BUSWIDTH_16);
 
 	/* Read the flash type */
-	type = nand_get_flash_type(mtd, chip, busw,
-				&nand_maf_id, &nand_dev_id, table);
+	type = nand_get_flash_type(mtd, chip, &nand_maf_id,
+				   &nand_dev_id, table);
 
 	if (IS_ERR(type)) {
 		if (!(chip->options & NAND_SCAN_SILENT_NODEV))
-- 
1.8.1.5

