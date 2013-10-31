Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3JaFYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:24:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51345 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3JaFYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:24:16 -0400
Date: Thu, 31 Oct 2013 13:24:10 +0800
From: kedacomkernel <kedacomkernel@gmail.com>
To: NeilBrown <neilb@suse.de>, majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Reply-To: kedacomkernel <kedacomkernel@gmail.com>
Subject: Re: Re: [PATCH 3/3] md/raid5: For stripe with R5_ReadNoMerge, we replace REQ_FLUSH with REQ_NOMERGE.
References: <2013103010414134402615@gmail.com>, 
	<20131031141056.1525429a@notabene.brown>
X-Priority: 3
X-GUID: 4A1AE4F5-4A3F-492A-9C50-D3064ABAE4F4
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201310311324074524940@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9V5OPSe024832

>On Wed, 30 Oct 2013 10:41:46 +0800 majianpeng <majianpeng@gmail.com> wrote:
>
>> For R5_ReadNoMerge,it mean this bio can't merge with other bios or
>> request.It used REQ_FLUSH to achieve this. But REQ_NOMERGE can do the
>> same work.
>> 
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  drivers/md/raid5.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index f8b9068..8e0aeaa 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -772,7 +772,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>>  				bi->bi_sector = (sh->sector
>>  						 + rdev->data_offset);
>>  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
>> -				bi->bi_rw |= REQ_FLUSH;
>> +				bi->bi_rw |= REQ_NOMERGE;
>>  
>>  			bi->bi_vcnt = 1;
>>  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
>
>Thanks.
>
>I've queued this up pending Jens' acceptance of the other patches.
>
>By the way, your patch file has a carriage return as well as a newline at the
>end of each line.
>"patch" can still handle them but "git am" doesn't like it.
>
>If you are able to send the patches as plain text with just a NEWLINE at the
>end of each line, rather than base64 encodes with carriage returns, it would
>help a little.
>
Sorroy for that, i'll pay attention to this.
Thanks!
Jianpeng Ma

>Thanks,
>NeilBrown
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
