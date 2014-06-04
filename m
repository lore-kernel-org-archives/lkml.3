Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaFDSzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:55:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56056 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFDSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:55:14 -0400
Message-ID: <538F6B8F.1060107@kernel.dk>
Date: Wed, 04 Jun 2014 12:55:11 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>, willy@linux.intel.com,
        sbradshaw@micron.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@infradead.org
Subject: Re: [PATCH v5] conversion to blk-mq
References: <1401742510-10827-1-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406021642480.11244@AMR> <alpine.LRH.2.03.1406021702530.11244@AMR> <538E2C2E.1010500@bjorling.me> <alpine.LRH.2.03.1406031553280.11244@AMR> <alpine.LRH.2.03.1406031625120.11244@AMR> <538EE3E6.60408@bjorling.me> <alpine.LRH.2.03.1406041146280.11244@AMR> <538F68A9.50608@kernel.dk> <alpine.LRH.2.03.1406041246300.11244@AMR>
In-Reply-To: <alpine.LRH.2.03.1406041246300.11244@AMR>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 12:52 PM, Keith Busch wrote:
> On Wed, 4 Jun 2014, Jens Axboe wrote:
>> On 06/04/2014 12:28 PM, Keith Busch wrote:
>> Are you testing against 3.13? You really need the current tree for this,
>> otherwise I'm sure you'll run into issues (as you appear to be :-)
> 
> I'm using Matias' current tree:
> 
> git://github.com/MatiasBjorling/linux-collab nvmeq_wip_6
> 
> Is this the right one to use? Looks like a 3.15rc1+.

It is, I misread that diff wrong.

> Also ... obviously that's the wrong diff from before. I didn't save my
> file before creating the diff. Should have looked like this:
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index d10013b..d1b986c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -105,7 +105,8 @@ static int blk_mq_queue_enter(struct request_queue *q)
>      __percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
>      smp_wmb();
>      /* we have problems to freeze the queue if it's initializing */
> -    if (!blk_queue_bypass(q) || !blk_queue_init_done(q))
> +    if (!blk_queue_dying(q) && (!blk_queue_bypass(q) ||
> +                    !blk_queue_init_done(q)))
>          return 0;
> 
>      __percpu_counter_add(&q->mq_usage_counter, -1, 1000000);

This looks better.

-- 
Jens Axboe

