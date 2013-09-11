Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3IKE7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab3IKE5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:06 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=EhIqJSlZowIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XX241dhIufAA:10 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042922.974649920@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [185/251] zram: allow request end to coincide with disksize
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0185-zram-allow-request-end-to-coincide-with-disksize.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

[ Upstream commit 75c7caf5a052ffd8db3312fa7864ee2d142890c4 ]

Pass valid_io_request() checks if request end coincides with disksize
(end equals bound), only fail if we attempt to read beyond the bound.

mkfs.ext2 produces numerous errors:
[ 2164.632747] quiet_error: 1 callbacks suppressed
[ 2164.633260] Buffer I/O error on device zram0, logical block 153599
[ 2164.633265] lost page write due to I/O error on zram0

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 3a79d70..b9b3342 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -478,7 +478,7 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 	end = start + (bio->bi_size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
 	/* out of range range */
-	if (unlikely(start >= bound || end >= bound || start > end))
+	if (unlikely(start >= bound || end > bound || start > end))
 		return 0;
 
 	/* I/O request is valid */
-- 
1.7.10.4


