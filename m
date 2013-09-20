Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3ITUKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:10:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3ITUKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 03/93] zram: allow request end to coincide with disksize
Date: Fri, 20 Sep 2013 13:07:58 -0700
Message-Id: <1379707768-1804-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

commit 75c7caf5a052ffd8db3312fa7864ee2d142890c4 upstream.

Pass valid_io_request() checks if request end coincides with disksize
(end equals bound), only fail if we attempt to read beyond the bound.

mkfs.ext2 produces numerous errors:
[ 2164.632747] quiet_error: 1 callbacks suppressed
[ 2164.633260] Buffer I/O error on device zram0, logical block 153599
[ 2164.633265] lost page write due to I/O error on zram0

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index dd915ce..73534ec 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -473,7 +473,7 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 	end = start + (bio->bi_size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
 	/* out of range range */
-	if (unlikely(start >= bound || end >= bound || start > end))
+	if (unlikely(start >= bound || end > bound || start > end))
 		return 0;
 
 	/* I/O request is valid */
-- 
1.8.1.2

