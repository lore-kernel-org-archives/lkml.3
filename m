Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbbALULu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:11:50 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:32903 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbbALULt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:11:49 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] linux/types.h: Always use unsigned long for pgoff_t
Date: Mon, 12 Jan 2015 21:11:49 +0100
Message-Id: <1421093509-26449-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everybody uses unsigned long for pgoff_t, and no ever overrode the
definition of pgoff_t. Keep it that way, and remove the option of
overriding it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/types.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index a0bb7048687f565e..c26aa84be9d36131 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -135,12 +135,9 @@ typedef unsigned long blkcnt_t;
 #endif
 
 /*
- * The type of an index into the pagecache.  Use a #define so asm/types.h
- * can override it.
+ * The type of an index into the pagecache.
  */
-#ifndef pgoff_t
 #define pgoff_t unsigned long
-#endif
 
 /* A dma_addr_t can hold any valid DMA or bus address for the platform */
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-- 
1.9.1

