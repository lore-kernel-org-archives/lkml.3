Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaCLRIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:08:21 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:59208 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaCLRIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:08:20 -0400
MIME-Version: 1.0
X-Originating-IP: [185.25.64.249]
In-Reply-To: <53208845.5090305@kernel.dk>
References: <1394640348-9109-1-git-send-email-felipe@paradoxo.org>
	<1394640348-9109-2-git-send-email-felipe@paradoxo.org>
	<53208845.5090305@kernel.dk>
Date: Wed, 12 Mar 2014 17:08:19 +0000
Message-ID: <CANxchRSOpr63_GuktU_Y53y=vE0n+x6tqQ+=+uo_WgMGP13yRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mtip32xx: Don't bounce IO requests
From: Felipe Franciosi <felipe@paradoxo.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Sam Bradshaw <sbradshaw@micron.com>,
        david.vrabel@citrix.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 4:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 03/12/2014 10:05 AM, Felipe Franciosi wrote:
>>
>> This device support 64-bit DMA and therefore no IO requests needs bouncing.
>> On 32-bit systems, blk_queue_bounce() will bounce all IO requests with high
>> mem pages. This makes performance really really bad.
>>
>> Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
>> ---
>>   drivers/block/mtip32xx/mtip32xx.c |    2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
>> index 5160269..24c87fdb 100644
>> --- a/drivers/block/mtip32xx/mtip32xx.c
>> +++ b/drivers/block/mtip32xx/mtip32xx.c
>> @@ -4082,8 +4082,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
>>
>>         sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
>>         if (likely(sg != NULL)) {
>> -               blk_queue_bounce(queue, &bio);
>> -
>>                 if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
>>                         dev_warn(&dd->pdev->dev,
>>                                 "Maximum number of SGL entries exceeded\n");
>
>
> That seems to be because the driver forgets to set the DMA capabilities. It needs a blk_queue_bounce_limit() call when it sets up the queue.
>
> --
> Jens Axboe
>

Hmm... I see what you are saying. David, would you like to comment?

Thanks,
Felipe

p.s. resending as GMail was naughty and sent my previous reply in HTML.
