Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaDRTX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:23:59 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:33184 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaDRTX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:23:57 -0400
Message-ID: <53517BC5.7090002@web.de>
Date: Fri, 18 Apr 2014 21:23:49 +0200
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,jcmvbkbc@gmail.com
To: Ming Lei <tom.leiming@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH next 3/4] blk-mq: user (1 << order) to implement order_to_size()
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>	<1397749778-14485-4-git-send-email-tom.leiming@gmail.com>	<5350257A.30107@web.de> <CACVXFVMFuiHpM-bVjyutP7fH621Gt0bo2+HLwRbk_aGsiZ+1Vw@mail.gmail.com>
In-Reply-To: <CACVXFVMFuiHpM-bVjyutP7fH621Gt0bo2+HLwRbk_aGsiZ+1Vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ID: G5u-MGZ6ghdqMr0d8ihHX3LcHAgc5ex-9h+6YYLIfE16hFHztpauERgbW+O5lVgwa+@t-dialin.net
X-TOI-MSGID: c48cd18e-36bb-4ac2-9665-0e1e2d5ffcf0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei wrote, on 04/18/2014 17:47:
> On Fri, Apr 18, 2014 at 3:03 AM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
>> Ming Lei wrote, on 04/17/2014 17:49:
>>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>>> ---
>>>  block/blk-mq.c |    7 +------
>>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index baff2d0..1eff3d9 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -1130,12 +1130,7 @@ static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
>>>
>>>  static size_t order_to_size(unsigned int order)
>>>  {
>>> -     size_t ret = PAGE_SIZE;
>>> -
>>> -     while (order--)
>>> -             ret *= 2;
>>> -
>>> -     return ret;
>>> +     return (1 << order) * PAGE_SIZE;
>>
>> Shouldn't this be
>>
>>         return ((size_t)1 << order) * PAGE_SIZE;
>>
>> ?
> 
> IMO, it isn't necessary since compiler will cast type
> of 1 and the expression to size_t automatically.
> 
> 
> Thanks,

Testing this with gcc 4.8.2 with order > 30 confirms that the automatic casting
is done operator-wise and the explicit casting is necessary.

Regards,
jvp.

