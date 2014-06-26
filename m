Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbaFZQvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:51:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813AbaFZQvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:51:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] cfq: Increase default value of target_latency
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
	<1403683129-10814-7-git-send-email-mgorman@suse.de>
	<x491tub65t9.fsf@segfault.boston.devel.redhat.com>
	<20140626161955.GH10819@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 26 Jun 2014 12:50:32 -0400
In-Reply-To: <20140626161955.GH10819@suse.de> (Mel Gorman's message of "Thu,
	26 Jun 2014 17:19:56 +0100")
Message-ID: <x49simr4ntz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> On Thu, Jun 26, 2014 at 11:36:50AM -0400, Jeff Moyer wrote:
>> Right, and I guess I hadn't considered that case as I thought folks used
>> more than one spinning disk for such workloads.
>> 
>
> They probably are but by and large my IO testing is based on simple
> storage. The reasoning is that if we get the simple case wrong then we
> probably are getting the complex case wrong too or at least not performing
> as well as we should. I also don't use SSD on my own machines for the
> same reason.

A single disk is actually the hard case in this instance, but I
understand what you're saying.  ;-)

>> My main reservation about this change is that you've only provided
>> numbers for one benchmark. 
>
> The other obvious one to run would be pgbench workloads but it's a rathole of
> arguing whether the configuration is valid and whether it's inappropriate
> to test on simple storage. The tiobench tests alone take a long time to
> complete -- 1.5 hours on a simple machine, 7 hours on a low-end NUMA machine.

And we should probably run our standard set of I/O exercisers at the
very least.  But, like I said, it seems like wasted effort.

>> To bump the default target_latency, ideally
>> we'd know how it affects other workloads.  However, I'm having a hard
>> time justifying putting any time into this for a couple of reasons:
>> 1) blk-mq pretty much does away with the i/o scheduler, and that is the
>>    future
>> 2) there is work in progress to convert cfq into bfq, and that will
>>    essentially make any effort put into this irrelevant (so it might be
>>    interesting to test your workload with bfq)
>> 
>
> Ok, you've convinced me and I'll drop this patch. For anyone based on
> kernels from around this time they can tune CFQ or buy a better disk.
> Hopefully they will find this via Google.

Funny, I wasn't weighing in against your patch.  I was merely indicating
that I personally wasn't going to invest the time to validate it.  But,
if you're ok with dropping it, that's obviously fine with me.

Cheers,
Jeff
