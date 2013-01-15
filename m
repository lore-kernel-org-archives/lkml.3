Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3AOAac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:30:32 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54763 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3AOAab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:30:31 -0500
Date: Tue, 15 Jan 2013 08:30:22 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        tj <tj@kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH] blkcg: Before starting a new slice, firstly count bps/iops limit in func tg_may_dispatch.
References: <201301111711251317275@gmail.com> <50F0211D.7040209@kernel.dk> <20130111191726.GB12019@redhat.com> <201301141015538278161@gmail.com>, 
	<20130114152233.GB2380@redhat.com>
X-Priority: 3
X-GUID: 768C7C6D-43ED-44F3-8925-C9F43ADDB011
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201301150830194353580@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0F0UcmL004809

>On Mon, Jan 14, 2013 at 10:15:58AM +0800, majianpeng wrote:
>
>[..]
>> >Index: linux-2.6/block/blk-throttle.c
>> >===================================================================
>> >--- linux-2.6.orig/block/blk-throttle.c	2012-10-18 01:52:28.000000000 -0400
>> >+++ linux-2.6/block/blk-throttle.c	2013-01-14 03:40:41.355731375 -0500
>> >@@ -648,8 +648,14 @@ static bool tg_may_dispatch(struct throt
>> > 	 * If previous slice expired, start a new one otherwise renew/extend
>> > 	 * existing slice to make sure it is at least throtl_slice interval
>> > 	 * long since now.
>> >+	 *
>> >+	 * Start a new slice only if there is no bio queued in that direction.
>> >+	 * That bio is waiting to be dispatched and slice needs to be
>> >+	 * extended. It might happen that bio waited to be dispatched but
>> >+	 * workqueue execution got little late it might restart a new slice
>> >+	 * instead of taking all the waited time into account.
>> > 	 */
>> >-	if (throtl_slice_used(td, tg, rw))
>> >+	if (throtl_slice_used(td, tg, rw) && !tg->nr_queued[rw])
>> > 		throtl_start_new_slice(td, tg, rw);
>> > 	else {
>> > 		if (time_before(tg->slice_end[rw], jiffies + throtl_slice))
>> Hi vivek,
>> 	Your patch is ok.But i had a question:
>> What's condition tg->nr_queued[rw] = 0, but bio is not null?
>
>When a new bio is about to be queued in an empty group (look at
>blk_throtl_bio). At that time, tg->nr_queued[rw] might be 0 if no other
>bio is already queued.
>
>Thanks
>Vivek
I see. Thanks your time!

Jianpeng
Thanks!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
