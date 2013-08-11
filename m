Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab3HKUMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 16:12:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51647 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab3HKUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 16:12:51 -0400
From: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
Subject: [PATCH 1/1] mtd: mtdoops: fix for a potential memory leak in mtdoops_notify_remove
Date: Sun, 11 Aug 2013 13:11:48 -0700
Message-Id: <1376251908-7451-1-git-send-email-nilanjan.roychowdhury@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are allocating cxt->oops_page_used using vmalloc in mtdoops_notify_add for
every mtd_info addition but not freeing it in mtdoops_notify_remove

Signed-off-by: Nilanjan Roychowdhury <nilanjan.roychowdhury@gmail.com>
---
 drivers/mtd/mtdoops.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 97bb8f6..02f49aa 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -386,6 +386,7 @@ static void mtdoops_notify_remove(struct mtd_info *mtd)
 	cxt->mtd = NULL;
 	flush_work(&cxt->work_erase);
 	flush_work(&cxt->work_write);
+	vfree(cxt->oops_page_used);
 }
 
 
-- 
1.7.9.5

