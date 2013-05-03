Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269Ab3ECF5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:57:48 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49696 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760451Ab3ECF5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:57:47 -0400
Message-ID: <518351CF.6090500@linux.vnet.ibm.com>
Date: Fri, 03 May 2013 13:57:35 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <51833302.6090208@linux.vnet.ibm.com> <1367557300.5907.30.camel@marge.simpson.net>
In-Reply-To: <1367557300.5907.30.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050305-5816-0000-0000-000007CFCEC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike

Thanks for your reply.

On 05/03/2013 01:01 PM, Mike Galbraith wrote:
[snip]
>>
>> If this approach caused any concerns, please let me know ;-)
> 
> I wonder if throttling on failure is the way to go.  Note the minimal
> gain for pgbench with the default 1ms throttle interval.  It's not very
> effective out of the box for the load type it's targeted to help, and
> people generally don't twiddle scheduler knobs.  If you throttle on
> success, you directly restrict migration frequency without that being
> affected by what other tasks are doing.  Seems that would be a bit more
> effective.

This is a good timing to make some conclusion for this problem ;-)

Let's suppose when wake-affine failed, next time slice got a higher
failure chance, then whether throttle on failure could be the question like:

	throttle interval should cover more failure timing
	or more success timing?

Obviously we should cover more failure timing, since it's just wasting
cycle and change nothing.

However, I used to concern about the damage of succeed wake-affine at
that rapid, sure it also contain the benefit, but which one is bigger?

Now if we look at the RFC version which throttle on succeed, for
pgbench, we could find that the default 1ms benefit is < 5%, while the
current version which throttle on failure bring 7% at most.

And that eliminate my concern :)

> 
> (I still like the wakeup buddy thing, it's more effective because it
> adds and uses knowledge, though without the knob, cache domain size.
> Peter is right about the interrupt wakeups though, that could very
> easily cause regressions, dirt simple throttle is much safer).

Exactly, dark issue deserve dark solution, let darkness guide him...

Regards,
Michael Wang

> 
> -Mike
> 

