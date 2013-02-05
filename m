Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3BEXp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:45:29 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49409 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3BEXp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:45:27 -0500
X-AuditID: 9c930179-b7c24ae00000119c-77-51119994568b
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH] zram: fix warning of print format
Date: Wed,  6 Feb 2013 08:45:22 +0900
Message-Id: <1360107922-21725-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.1.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild bot whinges due to print format mistmatch caused by
zram: force disksize setting before using zram.

This patch fixes it.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 85055c4..3318b0f 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -519,7 +519,7 @@ int zram_init_device(struct zram *zram)
 		"ratio. Note that zram uses about 0.1%% of the size of "
 		"the disk when not in use so a huge zram is "
 		"wasteful.\n"
-		"\tMemory Size: %zu kB\n"
+		"\tMemory Size: %lu kB\n"
 		"\tSize you selected: %llu kB\n"
 		"Continuing anyway ...\n",
 		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
-- 
1.8.1.1

