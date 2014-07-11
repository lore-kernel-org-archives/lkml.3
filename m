Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaGKCPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:15:36 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:40994 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbaGKCPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:15:35 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mtd: denali: avoid using a magic number
Date: Fri, 11 Jul 2014 11:14:05 +0900
Message-Id: <1405044846-21447-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAP10 command with '0x2000' data sets up a read-ahead/write access.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---
 drivers/mtd/nand/denali.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 9f2012a..7c1c1ab 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -74,6 +74,7 @@ MODULE_PARM_DESC(onfi_timing_mode, "Overrides default ONFI setting."
 #define SPARE_ACCESS		0x41
 #define MAIN_ACCESS		0x42
 #define MAIN_SPARE_ACCESS	0x43
+#define PIPELINE_ACCESS		0x2000
 
 #define DENALI_READ	0
 #define DENALI_WRITE	0x100
@@ -765,7 +766,7 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
 			iowrite32(cmd, denali->flash_mem);
 		} else {
 			index_addr(denali, (uint32_t)cmd,
-					0x2000 | op | page_count);
+					PIPELINE_ACCESS | op | page_count);
 
 			/* wait for command to be accepted
 			 * can always use status0 bit as the
-- 
1.9.1

