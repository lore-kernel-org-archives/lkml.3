Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaGCCKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:10:06 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:58315 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGCCKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:10:03 -0400
Message-ID: <53B4BB71.7030500@linux.vnet.ibm.com>
Date: Thu, 03 Jul 2014 10:09:53 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net> <53A8F1DE.2060908@linux.vnet.ibm.com> <20140701082020.GL6758@twins.programming.kicks-ass.net> <53B273A2.5050500@linux.vnet.ibm.com> <20140701085658.GM6758@twins.programming.kicks-ass.net> <53B372C6.5000107@linux.vnet.ibm.com> <20140702124918.GE19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140702124918.GE19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070302-3568-0000-0000-000005CA441E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 08:49 PM, Peter Zijlstra wrote:
> On Wed, Jul 02, 2014 at 10:47:34AM +0800, Michael wang wrote:
>> The opinion on features actually make me a little confusing... I used to
>> think the scheduler is willing on providing kinds of way to adapt itself
>> to different situation, and some features do help on that, make them
>> only a debug option make the scheduler more static to users, but I know
>> that's not what I should touched...
>>
>> Anyway, the problem is still there and seems like we have to adopt some
>> optional solution to address it, we'll still working and practice on
>> that, please let us know if you have any ideas we could help on ;-)
> 
> No, its very much not intended as a user knob to adapt.
> 
> The problem with that approach to scheduling is that one set of knobs
> runs workload A, while another set of knobs runs workload B, but what
> happens if you need to run both A and B on the same machine?

That's actually what make me think the scheduler should be able to adapt
itself, our performance testing mostly based on static kinds of
workload, and that's too far away from the real world.

We tested A, we tested B, we tested A + B, but what if C joined? what if
folks only like A, don't care B?

The key point here is, scheduler still can't promise that all kinds of
situation is taking good care under it's static policy... it just
running there, won't get any feedback from user, thinking it's doing the
right thing, but sometimes not from admin's view.

> 
> So optional things and knobs are a complete fail and will not happen.

But how could we promise that our static policy is the best?

For example the 'sysctl_sched_min_granularity', why it should be 750k?
is that the best on any kinds of platform to any kinds of workloads at
any time?

Regards,
Michael Wang

> 
> Clearly I need to go take out all these things because people don't seem
> to know this and SCHED_DEBUG isn't a big enough hint. Tedious.
> 

