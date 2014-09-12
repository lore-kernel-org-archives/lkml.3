Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaILP71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:59:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaILP70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:59:26 -0400
MIME-Version: 1.0
In-Reply-To: <5413150B.9010803@kernel.dk>
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
	<1410533253-8045-3-git-send-email-ming.lei@canonical.com>
	<54130ED7.4080106@kernel.dk>
	<CACVXFVOrWaaga=3NWeWs400AL4CS316jBftngxmjS4L-YGKkYQ@mail.gmail.com>
	<5413150B.9010803@kernel.dk>
Date: Fri, 12 Sep 2014 23:59:23 +0800
Message-ID: <CACVXFVPAVGZEpkfX551RSOGV71CkdQO6npkyAoNmZMqze01iQw@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] block: introduce blk_init_flush and its pair
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:45 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-09-12 09:41, Ming Lei wrote:
>>
>> On Fri, Sep 12, 2014 at 11:18 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 2014-09-12 08:47, Ming Lei wrote:
>>>>
>>>>
>>>> These two functions are introduced to initialize and de-initialize
>>>> flush stuff centrally.
>>>
>>>
>>>
>>> I know you said these change later to more proper naming, but that only
>>> happens further down. Lets get rid of these wrappers and just call
>>> blk_alloc_flush_queue() directly.
>>
>>
>> It is too early to call blk_alloc_flush_queue() because flush queue
>> doesn't
>> come until patch 5 appears, :-)  And I think it is cleaner to put
>> flush initialization
>> stuff together first, then introduce flush_queue.
>
>
> Then do it later. Fact is, final result still looks like this in
> blk_mq_init_queue():
>
> if (blk_init_flush(q))
>     ...
>
> where it would be cleaner as just assigning q->fq. My previous (and
> existing) point is that you have no idea what this init_flush() function
> does without jumping in and reading it.

That is a good point, and we can change to call blk_alloc_flush_queue()
directly in patch 5.

Thanks,
