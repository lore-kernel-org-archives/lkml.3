Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaKLOha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:37:30 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55893 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaKLOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:37:29 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: ngupta@vflare.org, minchan@kernel.org, weijie.yang@samsung.com,
        sergey.senozhatsky@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zram: correct ZRAM_ZERO flag bit position
Date: Wed, 12 Nov 2014 22:37:18 +0800
Message-Id: <1415803038-7913-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In struct zram_table_entry, the element *value* contains obj size and
obj zram flags. Bit 0 to bit (ZRAM_FLAG_SHIFT - 1) represent obj size,
and bit ZRAM_FLAG_SHIFT to the highest bit of unsigned long represent obj
zram_flags. So the first zram flag(ZRAM_ZERO) should be from ZRAM_FLAG_SHIFT
instead of (ZRAM_FLAG_SHIFT + 1).

This patch fixes this issue.

Also this patch fixes a typo, "page in now accessed" -> "page is now accessed"

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 drivers/block/zram/zram_drv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index c6ee271..b05a816 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -66,8 +66,8 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 /* Flags for zram pages (table[page_no].value) */
 enum zram_pageflags {
 	/* Page consists entirely of zeros */
-	ZRAM_ZERO = ZRAM_FLAG_SHIFT + 1,
-	ZRAM_ACCESS,	/* page in now accessed */
+	ZRAM_ZERO = ZRAM_FLAG_SHIFT,
+	ZRAM_ACCESS,	/* page is now accessed */
 
 	__NR_ZRAM_PAGEFLAGS,
 };
-- 
1.7.9.5

