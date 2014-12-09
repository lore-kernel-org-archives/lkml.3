Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbaLIQKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:10:55 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41832 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaLIQKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:10:53 -0500
Message-ID: <54871F0B.7080208@kernel.dk>
Date: Tue, 09 Dec 2014 09:10:51 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] blk-mq: Use all available hardware queues
References: <54871BD0.8020305@acm.org> <54871C59.3050903@acm.org>
In-Reply-To: <54871C59.3050903@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:59 AM, Bart Van Assche wrote:
> Suppose that a system has two CPU sockets, three cores per socket,
> that it does not support hyperthreading and that four hardware
> queues are provided by a block driver. With the current algorithm
> this will lead to the following assignment of CPU cores to hardware
> queues:
>
>    HWQ 0: 0 1
>    HWQ 1: 2 3
>    HWQ 2: 4 5
>    HWQ 3: (none)
>
> This patch changes the queue assignment into:
>
>    HWQ 0: 0 1
>    HWQ 1: 2
>    HWQ 2: 3 4
>    HWQ 3: 5
>
> In other words, this patch has the following three effects:
> - All four hardware queues are used instead of only three.
> - CPU cores are spread more evenly over hardware queues. For the
>    above example the range of the number of CPU cores associated
>    with a single HWQ is reduced from [0..2] to [1..2].
> - If the number of HWQ's is a multiple of the number of CPU sockets
>    it is now guaranteed that all CPU cores associated with a single
>    HWQ reside on the same CPU socket.

I have thought about this since your last posting, and I think it should 
be a win for most cases to do this, even if we end up with asymmetric 
queue <-> cpu mappings.

-- 
Jens Axboe

