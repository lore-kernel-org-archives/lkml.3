Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaAIVeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:34:06 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47014 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaAIVd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:33:59 -0500
MIME-Version: 1.0
In-Reply-To: <52CF0D85.7060905@bjorling.me>
References: <CAFR8uedovPTT0562nZSAfatjqqhyi8WXRdHj5wa9oCkVbzrBag@mail.gmail.com>
	<52CF0D85.7060905@bjorling.me>
Date: Thu, 9 Jan 2014 13:33:59 -0800
Message-ID: <CAFR8ueeDHLe51jm6JRU1r5Qm7trhfPaYgXkzG2c=gUXxU0oU0A@mail.gmail.com>
Subject: Re: [block:for-3.14/core] blk-mq: Compile fix for null_blk
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Matias Bjorling <m@bjorling.me>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tom.leiming@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Matias. Yes, Ming Lei's 4th patch does make the function internal.

So, which branch has the laest patches... i am checking for-3.14/core...

Regards,
Muthu


On Thu, Jan 9, 2014 at 12:58 PM, Matias Bjorling <m@bjorling.me> wrote:
> On 01/09/2014 07:54 PM, Muthu Kumar wrote:
>>
>> Jens,
>>
>> Compiling null_blk.ko failed with error that blk_mq_free_queue() was
>> defined implicitly. So, moved the declaration from block/blk-mq.h to
>> include/linux/blk-mq.h and exported it.
>>
>
> The patch from Ming Lei is missing in -rc6
>
> 4af48694451676403188a62385dd1a2849fc05c5
> block: null_blk: fix queue leak inside removing device
>
> Its queued for -rc7. It removes the usage of blk_mq_free_queue in blk_null.
>
>
>> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
>>
>> ----------------------
>>
>>   block/blk-mq.c         |    1 +
>>   block/blk-mq.h         |    1 -
>>   include/linux/blk-mq.h |    1 +
>>   3 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 57039fc..3e08b87 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -1422,6 +1422,7 @@ void blk_mq_free_queue(struct request_queue *q)
>>          list_del_init(&q->all_q_node);
>>          mutex_unlock(&all_q_mutex);
>>   }
>> +EXPORT_SYMBOL(blk_mq_free_queue);
>>
>>   /* Basically redo blk_mq_init_queue with queue frozen */
>>   static void blk_mq_queue_reinit(struct request_queue *q)
>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>> index 5c39179..35ff4f7 100644
>> --- a/block/blk-mq.h
>> +++ b/block/blk-mq.h
>> @@ -28,7 +28,6 @@ void blk_mq_run_request(struct request *rq, bool
>> run_queue, bool async);
>>   void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
>>   void blk_mq_init_flush(struct request_queue *q);
>>   void blk_mq_drain_queue(struct request_queue *q);
>> -void blk_mq_free_queue(struct request_queue *q);
>>
>>   /*
>>    * CPU hotplug helpers
>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index 851d34b..51109b8 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -113,6 +113,7 @@ enum {
>>   };
>>
>>   struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
>> +void blk_mq_free_queue(struct request_queue *q);
>>   int blk_mq_register_disk(struct gendisk *);
>>   void blk_mq_unregister_disk(struct gendisk *);
>>   void blk_mq_init_commands(struct request_queue *, void (*init)(void
>> *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void
>> *data);
>>
>
