Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbaCSWZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:25:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51927 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbaCSWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:25:18 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: shc_work@mail.ru, computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mtd: diskonchip: mem resource name is not optional
Date: Wed, 19 Mar 2014 18:24:37 -0400
Message-Id: <1395267877-15223-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing a name to request_mem_region() isn't optional and can't just
be NULL. Passing NULL causes a NULL ptr deref later in the boot
process.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/mtd/nand/diskonchip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index b9b4db6..f68a7bc 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1439,7 +1439,7 @@ static int __init doc_probe(unsigned long physadr)
 	int reg, len, numchips;
 	int ret = 0;
 
-	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, NULL))
+	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, "DiskOnChip"))
 		return -EBUSY;
 	virtadr = ioremap(physadr, DOC_IOREMAP_LEN);
 	if (!virtadr) {
-- 
1.7.2.5

