Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3J3CmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:42:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54131 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3J3Cly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:41:54 -0400
Date: Wed, 30 Oct 2013 10:41:42 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 2/3] block: Check bio can merge before call attempt_plug_merge.
X-Priority: 3
X-GUID: 3DBCCC56-C955-42C2-BD95-1BBEF90DF873
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <2013103010413863125714@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9U2gRvR017351

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0a00e4e..fb970fd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1492,7 +1492,7 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
-	if (attempt_plug_merge(q, bio, &request_count))
+	if (likely(bio_mergeable(bio)) && attempt_plug_merge(q, bio, &request_count))
 		return;
 
 	spin_lock_irq(q->queue_lock);
-- 
1.8.4ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
