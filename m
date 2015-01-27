Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbbA0OKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:10:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43706 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbbA0OKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:10:20 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, ezequiel.garcia@free-electrons.com,
        dwmw2@infradead.org, computersforpeace@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] mtd: pxa3xx_nand: initialiaze pxa3xx_flash_ids to 0
Date: Tue, 27 Jan 2015 15:10:08 +0100
Message-Id: <1422367816-4257-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pxa3xx_flash_ids wasn't initialized to 0, which in certain cases could
end up containing corrupted values in its members. Fix this to avoid
possible issues.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/mtd/nand/pxa3xx_nand.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 96b0b1d27df1..d00ac392d1c4 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1472,6 +1472,8 @@ static int pxa3xx_nand_scan(struct mtd_info *mtd)
 		return ret;
 	}
 
+	memset(pxa3xx_flash_ids, 0, sizeof(pxa3xx_flash_ids));
+
 	pxa3xx_flash_ids[0].name = f->name;
 	pxa3xx_flash_ids[0].dev_id = (f->chip_id >> 8) & 0xffff;
 	pxa3xx_flash_ids[0].pagesize = f->page_size;
-- 
2.2.2

