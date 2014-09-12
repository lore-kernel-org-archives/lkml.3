Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaILPpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:45:42 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36377 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaILPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:45:19 -0400
Message-ID: <5413150B.9010803@kernel.dk>
Date: Fri, 12 Sep 2014 09:45:15 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/9] block: introduce blk_init_flush and its pair
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>	<1410533253-8045-3-git-send-email-ming.lei@canonical.com>	<54130ED7.4080106@kernel.dk> <CACVXFVOrWaaga=3NWeWs400AL4CS316jBftngxmjS4L-YGKkYQ@mail.gmail.com>
In-Reply-To: <CACVXFVOrWaaga=3NWeWs400AL4CS316jBftngxmjS4L-YGKkYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-12 09:41, Ming Lei wrote:
> On Fri, Sep 12, 2014 at 11:18 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-09-12 08:47, Ming Lei wrote:
>>>
>>> These two functions are introduced to initialize and de-initialize
>>> flush stuff centrally.
>>
>>
>> I know you said these change later to more proper naming, but that only
>> happens further down. Lets get rid of these wrappers and just call
>> blk_alloc_flush_queue() directly.
>
> It is too early to call blk_alloc_flush_queue() because flush queue doesn't
> come until patch 5 appears, :-)  And I think it is cleaner to put
> flush initialization
> stuff together first, then introduce flush_queue.

Then do it later. Fact is, final result still looks like this in 
blk_mq_init_queue():

if (blk_init_flush(q))
     ...

where it would be cleaner as just assigning q->fq. My previous (and 
existing) point is that you have no idea what this init_flush() function 
does without jumping in and reading it.


-- 
Jens Axboe

