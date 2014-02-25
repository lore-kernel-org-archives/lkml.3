Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaBYBIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:08:19 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64692 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaBYBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:08:17 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-9c-530becfee996
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] zram: avoid null access when fail to alloc meta
Date: Tue, 25 Feb 2014 10:08:35 +0900
Message-Id: <1393290516-21158-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.5.3
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram_meta_alloc could be failed so caller should check it.
Otherwise, your system will be hang.

Cc: <stable@vger.kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5ec61be793d2..21aee3edcb25 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -554,6 +554,8 @@ static ssize_t disksize_store(struct device *dev,
 
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
+	if (!meta)
+		return -ENOMEM;
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
-- 
1.8.5.3

