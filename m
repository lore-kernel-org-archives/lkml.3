Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3KLTHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:07:48 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:39142 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3KLTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 10/12] mtd: ms02-nv: Remove superfluous name cast
Date: Tue, 12 Nov 2013 20:07:23 +0100
Message-Id: <1384283245-9419-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd_info.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/devices/ms02-nv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/ms02-nv.c b/drivers/mtd/devices/ms02-nv.c
index 182849d39c61..5c8b322ba904 100644
--- a/drivers/mtd/devices/ms02-nv.c
+++ b/drivers/mtd/devices/ms02-nv.c
@@ -205,7 +205,7 @@ static int __init ms02nv_init_one(ulong addr)
 	mtd->type = MTD_RAM;
 	mtd->flags = MTD_CAP_RAM;
 	mtd->size = fixsize;
-	mtd->name = (char *)ms02nv_name;
+	mtd->name = ms02nv_name;
 	mtd->owner = THIS_MODULE;
 	mtd->_read = ms02nv_read;
 	mtd->_write = ms02nv_write;
-- 
1.7.9.5

