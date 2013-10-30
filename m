Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3J3CmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:42:16 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59455 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3J3Cly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:41:54 -0400
Date: Wed, 30 Oct 2013 10:41:39 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 1/3] block: Add REQ_NOMERGE into REQ_COMMON_MASK
X-Priority: 3
X-GUID: F0F53160-0C14-4546-8EC2-4E500F4B9F62
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <2013103010413537651613@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9U2gq2Y017363

For bio with REQ_NOMERGE,it mean this bio can't merge with other bios.
And the request with this bio has the same meaning.
In blk_queue_bio, bio with REQ_NOMERGE can't be merged and get a new
request. But in init_request_from_bio, request can't test REQ_NOMERGE.
So the request can merge other bio or merge other request.
Add REQ_NOMERGE into REQ_COMMON_MASK to avoid this.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 include/linux/blk_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fa1abeb..fc7f4c5 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -197,7 +197,7 @@ enum rq_flag_bits {
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
 	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
-	 REQ_SECURE)
+	 REQ_SECURE | REQ_NOMERGE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
-- 
1.8.4ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
