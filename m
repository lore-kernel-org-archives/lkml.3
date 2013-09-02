Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3IBByV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:54:21 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43631 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3IBByU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:54:20 -0400
Date: Mon, 2 Sep 2013 09:54:16 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: [PATCH] block: trace all devices plug operation.
References: <201308210843204575191@gmail.com>
X-Priority: 3
X-GUID: 92976900-B816-4D32-8901-EBE6319275BE
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309020954138877320@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r821sPn4004950

Hi axboe:
	How about this patch?

Thanks!
Jianpeng Ma
>In func blk_queue_bio, if list of plug is empty,it will call
>blk_trace_plug.
>If process deal with a single device,it't ok.But if process deal with
>multi devices,it only trace the first device.
>Using request_count to judge, it can soleve this problem.
>
>In addition, i modify the comment.
>
>Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>---
> block/blk-core.c | 6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>
>diff --git a/block/blk-core.c b/block/blk-core.c
>index 93a18d1..91037f7 100644
>--- a/block/blk-core.c
>+++ b/block/blk-core.c
>@@ -1549,11 +1549,9 @@ get_rq:
> 	if (plug) {
> 		/*
> 		 * If this is the first request added after a plug, fire
>-		 * of a plug trace. If others have been added before, check
>-		 * if we have multiple devices in this plug. If so, make a
>-		 * note to sort the list before dispatch.
>+		 * of a plug trace.
> 		 */
>-		if (list_empty(&plug->list))
>+		if (!request_count)
> 			trace_block_plug(q);
> 		else {
> 			if (request_count >= BLK_MAX_REQUEST_COUNT) {
>-- 
>1.8.3ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
