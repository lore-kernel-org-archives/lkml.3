Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3FCPpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:45:12 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47504 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921Ab3FCPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:45:08 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 6/8] zram: avoid access beyond the zram device
Date: Mon,  3 Jun 2013 23:42:18 +0800
Message-Id: <1370274140-26420-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function valid_io_request() should verify the entire request doesn't
exceed the zram device, otherwise it will cause invalid memory access.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 66cf28a..64b51b9 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -428,6 +428,10 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 		return 0;
 	}
 
+	if (unlikely((bio->bi_sector << SECTOR_SHIFT) + bio->bi_size >=
+		     zram->disksize))
+		return 0;
+
 	/* I/O request is valid */
 	return 1;
 }
-- 
1.8.1.2

