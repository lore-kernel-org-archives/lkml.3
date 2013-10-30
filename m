Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3J3Clz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:41:55 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46123 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J3Clw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:41:52 -0400
Date: Wed, 30 Oct 2013 10:41:46 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 3/3] md/raid5: For stripe with R5_ReadNoMerge, we replace REQ_FLUSH with REQ_NOMERGE.
X-Priority: 3
X-GUID: 8DC05C51-ACFE-4902-B516-BFF05C4588E6
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <2013103010414134402615@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9U2g2o9017347

For R5_ReadNoMerge,it mean this bio can't merge with other bios or
request.It used REQ_FLUSH to achieve this. But REQ_NOMERGE can do the
same work.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f8b9068..8e0aeaa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -772,7 +772,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				bi->bi_sector = (sh->sector
 						 + rdev->data_offset);
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
-				bi->bi_rw |= REQ_FLUSH;
+				bi->bi_rw |= REQ_NOMERGE;
 
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
-- 
1.8.4ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
