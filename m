Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3LBTPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:15:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3LBTOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:52 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: fix mq request allocation
References: <1385890077-30873-1-git-send-email-tom.leiming@gmail.com>
	<x49ob4z700n.fsf@segfault.boston.devel.redhat.com>
	<529CBA0A.8020703@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 02 Dec 2013 14:14:45 -0500
In-Reply-To: <529CBA0A.8020703@kernel.dk> (Jens Axboe's message of "Mon, 02
	Dec 2013 09:49:14 -0700")
Message-ID: <x49y5435al6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 12/02/2013 08:20 AM, Jeff Moyer wrote:
>> Ming Lei <tom.leiming@gmail.com> writes:
>> 
>>> blk_mq_alloc_request_pinned() may return NULL request in case of
>>> !__GFP_WAIT, so cause its callers to derefence NULL pointer for
>>> releasing current context.
>>>
>>> This patch introduces two flags to address the issue.
>> 
>> Hi, Ming,
>> 
>> 
>> Good catch, but your patch seems overly complicated.  How about
>> something like the following (compile-tested only), instead?  Note that
>> I did not touch blk_make_request, as the put_ctx there seems to
>> correlate to a get_ctx earlier in the function (not a leaked reference
>> from __blk_mq_alloc_request).
>
> I would tend to agree, it's overly complicated. The bug is real, however.

Hmm, did I make it sound as though I thought it wasn't a bug?  Your
response leaves me wondering whether my patch made it to your inbox.

>> p.s. Jens, every time I see GFP_ATOMIC|__GFP_WAIT, my head explodes.  Just sayin'.
>
> It's perfectly fine :-)

Sure, it's not *your* head!  ;-)

-Jeff
