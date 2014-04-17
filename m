Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaDQTNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:13:14 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55409 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaDQTNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <5350257A.30107@web.de>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
	<1397749778-14485-4-git-send-email-tom.leiming@gmail.com>
	<5350257A.30107@web.de>
Date: Thu, 17 Apr 2014 23:13:07 +0400
Message-ID: <CAMo8BfLLvUj0egqQSV5BGBv03x+3ejCZXwriVUGPHNJnq4yQvw@mail.gmail.com>
Subject: Re: [PATCH next 3/4] blk-mq: user (1 << order) to implement order_to_size()
From: Max Filippov <jcmvbkbc@gmail.com>
To: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:03 PM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
> Ming Lei wrote, on 04/17/2014 17:49:
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  block/blk-mq.c |    7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index baff2d0..1eff3d9 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -1130,12 +1130,7 @@ static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
>>
>>  static size_t order_to_size(unsigned int order)
>>  {
>> -     size_t ret = PAGE_SIZE;
>> -
>> -     while (order--)
>> -             ret *= 2;
>> -
>> -     return ret;
>> +     return (1 << order) * PAGE_SIZE;
>
> Shouldn't this be
>
>         return ((size_t)1 << order) * PAGE_SIZE;
>
> ?

Maybe even

return (size_t)PAGE_SIZE << order;

?

-- 
Thanks.
-- Max
