Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab3LBQuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:50:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47457 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3LBQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:50:09 -0500
Message-ID: <529CBA0A.8020703@kernel.dk>
Date: Mon, 02 Dec 2013 09:49:14 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, Ming Lei <tom.leiming@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: fix mq request allocation
References: <1385890077-30873-1-git-send-email-tom.leiming@gmail.com> <x49ob4z700n.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ob4z700n.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 08:20 AM, Jeff Moyer wrote:
> Ming Lei <tom.leiming@gmail.com> writes:
> 
>> blk_mq_alloc_request_pinned() may return NULL request in case of
>> !__GFP_WAIT, so cause its callers to derefence NULL pointer for
>> releasing current context.
>>
>> This patch introduces two flags to address the issue.
> 
> Hi, Ming,
> 
> 
> Good catch, but your patch seems overly complicated.  How about
> something like the following (compile-tested only), instead?  Note that
> I did not touch blk_make_request, as the put_ctx there seems to
> correlate to a get_ctx earlier in the function (not a leaked reference
> from __blk_mq_alloc_request).

I would tend to agree, it's overly complicated. The bug is real, however.

> p.s. Jens, every time I see GFP_ATOMIC|__GFP_WAIT, my head explodes.  Just sayin'.

It's perfectly fine :-)

-- 
Jens Axboe

