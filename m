Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaF3Irc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:47:32 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:60440 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaF3Ira (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:47:30 -0400
Message-ID: <53B12417.9060904@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2014 16:47:19 +0800
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
References: <53A11A89.5000602@linux.vnet.ibm.com> <53B11387.9020001@linux.vnet.ibm.com> <1404115601.5132.156.camel@marge.simpson.net>
In-Reply-To: <1404115601.5132.156.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063008-1396-0000-0000-000005225889
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike :)

On 06/30/2014 04:06 PM, Mike Galbraith wrote:
> On Mon, 2014-06-30 at 15:36 +0800, Michael wang wrote: 
>> On 06/18/2014 12:50 PM, Michael wang wrote:
>>> By testing we found that after put benchmark (dbench) in to deep cpu-group,
>>> tasks (dbench routines) start to gathered on one CPU, which lead to that the
>>> benchmark could only get around 100% CPU whatever how big it's task-group's
>>> share is, here is the link of the way to reproduce the issue:
>>
>> Hi, Peter
>>
>> We thought that involved too much factors will make things too
>> complicated, we are trying to start over and get rid of the concepts of
>> 'deep-group' and 'GENTLE_FAIR_SLEEPERS' in the idea, wish this could
>> make things more easier...
> 
> While you're getting rid of the concept of 'GENTLE_FAIR_SLEEPERS', don't
> forget to also get rid of the concept of 'over-scheduling' :)

I'm new to this word... could you give more details on that?

> 
> That gentle thing isn't perfect (is the enemy of good), but preemption
> model being based upon sleep, while nice and simple, has the unfortunate
> weakness that as contention increases, so does the quantity of sleep in
> the system.  Would be nice to come up with an alternative preemption
> model as dirt simple as this one, but lacking the inherent weakness.

The preemtion based on vruntime sounds fair enough, but vruntime-bonus
for wakee do need few more thinking... although I don't want to count
the gentle-stuff in any more, but disable it do help dbench a lot...

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

