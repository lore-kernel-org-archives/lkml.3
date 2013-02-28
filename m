Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3B1HkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:40:20 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35807 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3B1HkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:40:15 -0500
Message-ID: <512F09D4.1020307@linux.vnet.ibm.com>
Date: Thu, 28 Feb 2013 15:40:04 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH] sched: wakeup buddy
References: <512EFB4B.5040204@linux.vnet.ibm.com> <1362035917.4460.105.camel@marge.simpson.net>
In-Reply-To: <1362035917.4460.105.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022807-9574-0000-0000-000006C87B90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

Thanks for your reply.

On 02/28/2013 03:18 PM, Mike Galbraith wrote:
> On Thu, 2013-02-28 at 14:38 +0800, Michael Wang wrote:
> 
>> +				/*
>> +				 * current is the only task on rq and it is
>> +				 * going to sleep, current cpu will be a nice
>> +				 * candidate for p to run on.
>> +				 */
> 
> The sync hint only means it might be going to sleep soon, and even then,
> there can still be enough execution overlap to be a win to schedule
> cross core.  Sched pipe numbers will always be much prettier if you do
> wakeup cpu affine, as it's ~100% scheduler and ~100% sync.

Hmm.. so it's the comparison between 'cache benefit - execution overlap'
and 'latency - execution overlap'?

I could not estimate how many latency will be added to wait for current
going to sleep (it should be faster than access cold data, isn't it?),
but I really like the cache benefit, unless sync doesn't means current
is going to sleep every time, but that's the promise of WF_SYNC, isn't it?

You may lose
> a lot on other stuff if you interpret the hint as gospel truth.

Could you please give more details on this point?

> 
> IMHO, sched pipe is a "how fat have I become" benchmark, not "how well
> do I perform".  The scheduler performs well when it makes more work
> happen.  Playing ping-pong with yourself is _exercise_, not a job :)

That's right, may be I'm using the wrong description, it's the ops/sec
which has been doubled, that means 'fat', correct?

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

