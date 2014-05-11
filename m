Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbaEKTZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:25:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733AbaEKTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.14 60/83] mtd: diskonchip: mem resource name is not optional
Date: Sun, 11 May 2014 21:20:01 +0200
Message-Id: <20140511191914.895049228@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 86e4bbc766b9456f583f2fc3c4f6c623b422af88 upstream.

Passing a name to request_mem_region() isn't optional and can't just
be NULL. Passing NULL causes a NULL ptr deref later in the boot
process.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/diskonchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1438,7 +1438,7 @@ static int __init doc_probe(unsigned lon
 	int reg, len, numchips;
 	int ret = 0;
 
-	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, NULL))
+	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, "DiskOnChip"))
 		return -EBUSY;
 	virtadr = ioremap(physadr, DOC_IOREMAP_LEN);
 	if (!virtadr) {


