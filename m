Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaGAC6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:58:05 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54033 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaGAC6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:58:02 -0400
Message-ID: <53B223AE.10903@linux.vnet.ibm.com>
Date: Tue, 01 Jul 2014 10:57:50 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <53B11387.9020001@linux.vnet.ibm.com> <1404115601.5132.156.camel@marge.simpson.net> <53B12417.9060904@linux.vnet.ibm.com> <1404120453.5132.194.camel@marge.simpson.net>
In-Reply-To: <1404120453.5132.194.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070102-7014-0000-0000-000005314675
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 05:27 PM, Mike Galbraith wrote:
> On Mon, 2014-06-30 at 16:47 +0800, Michael wang wrote: 
[snip]
>>> While you're getting rid of the concept of 'GENTLE_FAIR_SLEEPERS', don't
>>> forget to also get rid of the concept of 'over-scheduling' :)
>>
>> I'm new to this word... could you give more details on that?
> 
> Massive context switching.  When heavily overloaded, wakeup preemption
> tends to hurt.  Trouble being that when overloaded, that's when
> fast/light tasks also need to get in and back out quickly the most. 

That's true... but for those who sensitive to latency, more frequently
the preemption is, more quickly they could have chances to run, although
that's really a very small piece of slice, but some time they just need
so much... like the mouse scurrying.

> 
[snip]
>> The preemtion based on vruntime sounds fair enough, but vruntime-bonus
>> for wakee do need few more thinking... although I don't want to count
>> the gentle-stuff in any more, but disable it do help dbench a lot...
> 
> It's scaled, but that's not really enough.  Zillion tasks can sleep in
> parallel, and when they are doing that, sleep time becomes a rather
> meaningless preemption yardstick.  It's only meaningful when there is a
> significant delta between task behaviors.  When running a homogeneous
> load of sleepers, eg a zillion java threads all doing the same damn
> thing, you're better off turning wakeup preemption off, because trying
> to smooth out microscopic vruntime deltas via wakeup preemption then
> does nothing but trashes caches.

I see, for those who prefer throughput, the effort on latency is
meaningless...

IMHO, currently the generic scheduler just try to take care both latency
and throughput, both will take a little damage but won't be damaged too
much, they just sacrificed for each other...

Fortunately, we still have various knobs and features to custom our own
scheduler, The flash or The Hulk ;-)

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

