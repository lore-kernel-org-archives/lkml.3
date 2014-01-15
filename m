Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaAOKVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:21:13 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56825 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaAOKVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:21:05 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2 4/4] zram: report failed read and writes stats
Date: Wed, 15 Jan 2014 13:16:17 +0300
Message-Id: <1389780977-18949-5-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram accounted but did not report numbers of failed read
and write queries. make these stats available as failed_reads
and failed_writes attrs.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6eb2155..ce00d47 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -699,6 +699,8 @@ static DEVICE_ATTR(memory_used, S_IRUGO, memory_used_show, NULL);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
+ZRAM_ATTR_RO(failed_reads);
+ZRAM_ATTR_RO(failed_writes);
 ZRAM_ATTR_RO(pages_stored);
 ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
@@ -711,6 +713,8 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_reset.attr,
 	&dev_attr_num_reads.attr,
 	&dev_attr_num_writes.attr,
+	&dev_attr_failed_reads.attr,
+	&dev_attr_failed_writes.attr,
 	&dev_attr_pages_stored.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
-- 
1.8.5.3.493.gb139ac2

