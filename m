Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaAPNQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:16:21 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49407 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaAPNQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:16:16 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 6/8] zram: report failed read and write stats
Date: Thu, 16 Jan 2014 16:12:14 +0300
Message-Id: <1389877936-15543-7-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram accounted but did not report numbers of failed read
and write queries. make these stats available as failed_reads
and failed_writes attrs.

Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e7102f1..9d67fbf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -728,6 +728,8 @@ static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
+ZRAM_ATTR_RO(failed_reads);
+ZRAM_ATTR_RO(failed_writes);
 ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
@@ -739,6 +741,8 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_reset.attr,
 	&dev_attr_num_reads.attr,
 	&dev_attr_num_writes.attr,
+	&dev_attr_failed_reads.attr,
+	&dev_attr_failed_writes.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
-- 
1.8.5.3.493.gb139ac2

