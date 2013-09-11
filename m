Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3IKFej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:34:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3IKE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:19 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=RVOP1rhIKk8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0ejEZCebz-MA:10 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=hPjdaMEvmhQA:10 a=LI9Vle30uBYA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042916.969675077@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiang Liu <jiang.liu@huawei.com>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [148/251] zram: avoid double free in function zram_bvec_write()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0148-zram-avoid-double-free-in-function-zram_bvec_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

[ Upstream commit 65c484609a3b25c35e4edcd5f2c38f98f5226093 ]

When doing a patial write and the whole page is filled with zero,
zram_bvec_write() will free uncmem twice.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/zram/zram_drv.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5047bfe..35b6a44 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -327,8 +327,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
 		zram_stat_inc(&zram->stats.pages_zero);
 		zram_set_flag(zram, index, ZRAM_ZERO);
 		ret = 0;
-- 
1.7.10.4


