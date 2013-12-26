Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3LZBxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 20:53:38 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8572 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3LZBxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 20:53:05 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Huang Shijie <b32955@freescale.com>,
        "David Woodhouse" <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH] mtd: nand:  assign mtd->name in find_full_id_nand
Thread-Topic: [PATCH] mtd: nand:  assign mtd->name in find_full_id_nand
Thread-Index: Ac8B3Q7fqVWcyWsLTCatba+p9jt2RA==
Date: Thu, 26 Dec 2013 01:51:58 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E47E20@SZXEMA512-MBX.china.huawei.com>
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
Date: Wed, 25 Dec 2013 21:19:21 +0800
Subject: [PATCH] mtd: nand: assign mtd->name in find_full_id_nand

This patch assigned the type->name to mtd->name when mtd->name is
NULL in function "find_full_id_nand".
mtd->name is NULL may cause some problem.

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 drivers/mtd/nand/nand_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 9b3bb3c..404e83d 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3327,6 +3327,9 @@ static bool find_full_id_nand(struct mtd_info *mtd, struct nand_chip *chip,
 
 		*busw = type->options & NAND_BUSWIDTH_16;
 
+		if (!mtd->name)
+			mtd->name = type->name;
+
 		return true;
 	}
 	return false;
-- 
1.8.1.5

