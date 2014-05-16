Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaEPO6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:58:38 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51596 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbaEPO6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:58:37 -0400
Message-ID: <53762799.2080403@kernel.dk>
Date: Fri, 16 May 2014 08:58:33 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com> <53762662.2050702@kernel.dk> <20140516145450.GA5939@infradead.org>
In-Reply-To: <20140516145450.GA5939@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-16 08:54, Christoph Hellwig wrote:
> On Fri, May 16, 2014 at 08:53:22AM -0600, Jens Axboe wrote:
>>> This patch fixes the problem by starting/stopping blk-mq
>>> with holding vq_lock.
>>
>> Why not just use blk_mq_start_hw_queues()?
>
> That would kick off a work item on every I/O completion, something
> you didn't particularly like in scsi-mq :)

It would suck, I sent a followup after that one :-)

And yes, it still needs improving in scsi-mq too.

-- 
Jens Axboe

