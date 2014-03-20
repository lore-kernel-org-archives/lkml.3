Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbaCTVGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:06:06 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46874 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbaCTVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:06:01 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Arnd Bergmann <arnd@arndb.de>, Jerome Marchand <jmarchan@redhat.com>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: include err.h in zram_drv
Date: Fri, 21 Mar 2014 00:02:03 +0300
Message-Id: <1395349323-18838-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.1.623.gfb8a990
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcomp returns error-valued pointer, also include err.h header
in zram_drv.

Per Arnd Bergmann:
The zram driver uses the ERR_PTR macro defined in <linux/err.h>
and relies on this header to be included implicitly through
other headers, which is not (always) the case on the ARM architecture.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8b13014..9849b52 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/err.h>
 
 #include "zram_drv.h"
 
-- 
1.9.1.623.gfb8a990

