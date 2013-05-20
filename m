Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3ETBfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:35:18 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47039 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3ETBfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:35:17 -0400
Message-ID: <51997DA2.4000302@huawei.com>
Date: Mon, 20 May 2013 09:34:26 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <axboe@kernel.dk>
CC: <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cdrom: gdrom: fix device number leak
References: <5195CBE0.6010106@huawei.com>
In-Reply-To: <5195CBE0.6010106@huawei.com>
X-Forwarded-Message-Id: <5195CBE0.6010106@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"repost with Jens Axboe <axboe@kernel.dk> added"  suggest by Tejun Heo <tj@kernel.org>

without this patch, gdrom_major will leak when gd.cd_info alloc faild

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/cdrom/gdrom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 4afcb65..5980cb9 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -830,9 +830,9 @@ probe_fail_cdrom_register:
 	del_gendisk(gd.disk);
 probe_fail_no_disk:
 	kfree(gd.cd_info);
+probe_fail_no_mem:
 	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	gdrom_major = 0;
-probe_fail_no_mem:
 	pr_warning("Probe failed - error is 0x%X\n", err);
 	return err;
 }
-- 
1.7.1



