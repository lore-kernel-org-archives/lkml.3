Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab3HNKjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:39:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab3HNKih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Backlund <tmb@mageia.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 75/75] zram: allow request end to coincide with disksize
Date: Wed, 14 Aug 2013 11:37:04 +0100
Message-Id: <1376476624-10011-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Thomas Backlund <tmb@mageia.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 1ae0610..2e88a68 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -545,7 +545,7 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 	end = start + (bio->bi_size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
 	/* out of range range */
-	if (unlikely(start >= bound || end >= bound || start > end))
+	if (unlikely(start >= bound || end > bound || start > end))
 		return 0;
 
 	/* I/O request is valid */
-- 
1.8.3.2

