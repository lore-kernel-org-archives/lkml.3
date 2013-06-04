Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3FDQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:09:59 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33067 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab3FDQIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:08:51 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/10] zram: avoid access beyond the zram device
Date: Wed,  5 Jun 2013 00:06:04 +0800
Message-Id: <1370361968-8764-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function valid_io_request() should verify the entire request doesn't
exceed the zram device, otherwise it will cause invalid memory access.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/zram/zram_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 6a54bb9..1c3974f 100644
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

