Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaHCWtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 18:49:03 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43070 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaHCWtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 18:49:00 -0400
From: Sami Kerola <kerolasa@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: kerolasa@iki.fi, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: return EBUSY when max_comp_streams change fails for device in use
Date: Sun,  3 Aug 2014 23:48:49 +0100
Message-Id: <1407106129-30705-1-git-send-email-kerolasa@iki.fi>
X-Mailer: git-send-email 2.0.3
Organization: lastminute.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both disksize and comp_algorithm return EBUSY when a change is attempted
to a device in use, and so should max_comp_streams.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 36e54be..0211734 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -139,7 +139,7 @@ static ssize_t max_comp_streams_store(struct device *dev,
 	if (init_done(zram)) {
 		if (!zcomp_set_max_streams(zram->comp, num)) {
 			pr_info("Cannot change max compression streams\n");
-			ret = -EINVAL;
+			ret = -EBUSY;
 			goto out;
 		}
 	}
-- 
2.0.3

