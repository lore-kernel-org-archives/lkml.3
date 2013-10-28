Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3J1Q3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:29:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab3J1Q3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:29:18 -0400
Message-ID: <526E90D7.1070604@kernel.dk>
Date: Mon, 28 Oct 2013 10:29:11 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org
Subject: Re: blk-mq flush fix
References: <20131026114612.GA8576@infradead.org> <20131026153124.GA22227@infradead.org> <20131027222914.GG22549@kernel.dk> <20131028084821.GA31270@infradead.org>
In-Reply-To: <20131028084821.GA31270@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 02:48 AM, Christoph Hellwig wrote:
> On Sun, Oct 27, 2013 at 10:29:25PM +0000, Jens Axboe wrote:
>> On Sat, Oct 26 2013, Christoph Hellwig wrote:
>>> I think this variant of the patch from Alexander should fix the issue
>>> in a minimally invasive way.  Longer term I'd prefer to use q->flush_rq
>>> like in the non-mq case by copying over the context and tag information.
>>
>> This one is pretty simple, we could definitely use it as a band aid. I
>> too would greatly prefer using the static ->flush_rq instead. Just have
>> it marked to bypass most of the free logic.
> 
> We already bypass the free logical by setting and end_io callback for
> a while, similar to what the old code does.  Maybe it's not all that
> hard to prealloc the request, let me give a sping.  Using the static
> allocated one will be hard due to the driver-specific extra data,
> though.

It's not that I think the existing patch is THAT bad, it fits in alright
with the reserved tagging and works regardless of whether a driver uses
reserved tags or not. And it does have the upside of not requiring
special checks or logic for this special non-tagged request that using
the preallocated would might need.

>> I'll add this one.
> 
> Gimme another day or so to figure this out.

OK, holding off.

-- 
Jens Axboe

