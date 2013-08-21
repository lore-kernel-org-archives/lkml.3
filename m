Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3HUAn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:43:29 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53005 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3HUAn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:43:28 -0400
Date: Wed, 21 Aug 2013 08:43:25 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] block: trace all devices plug operation.
X-Priority: 3
X-GUID: B54F1205-E8A4-4AB1-9234-24F2294FE161
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201308210843204575191@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7L0hYqP018904

In func blk_queue_bio, if list of plug is empty,it will call
blk_trace_plug.
If process deal with a single device,it't ok.But if process deal with
multi devices,it only trace the first device.
Using request_count to judge, it can soleve this problem.

In addition, i modify the comment.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/blk-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93a18d1..91037f7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1549,11 +1549,9 @@ get_rq:
 	if (plug) {
 		/*
 		 * If this is the first request added after a plug, fire
-		 * of a plug trace. If others have been added before, check
-		 * if we have multiple devices in this plug. If so, make a
-		 * note to sort the list before dispatch.
+		 * of a plug trace.
 		 */
-		if (list_empty(&plug->list))
+		if (!request_count)
 			trace_block_plug(q);
 		else {
 			if (request_count >= BLK_MAX_REQUEST_COUNT) {
-- 
1.8.3
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
