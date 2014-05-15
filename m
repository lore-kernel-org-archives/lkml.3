Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaEOIqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:46:43 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:32857 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaEOIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:46:39 -0400
Message-ID: <53747EE4.3020605@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 16:46:28 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com> <20140513142328.GE2485@laptop.programming.kicks-ass.net> <53731D12.7040804@linux.vnet.ibm.com> <20140514094426.GF30445@twins.programming.kicks-ass.net> <5374387E.4080802@linux.vnet.ibm.com> <20140515083531.GE30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140515083531.GE30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051508-0260-0000-0000-000004F31876
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 04:35 PM, Peter Zijlstra wrote:
> On Thu, May 15, 2014 at 11:46:06AM +0800, Michael wang wrote:
>> But for the dbench, stress combination, that's not spin-wasted, dbench
>> throughput do dropped, how could we explain that one?
> 
> I've no clue what dbench does.. At this point you'll have to
> expose/trace the per-task runtime accounting for these tasks and ideally
> also the things the cgroup code does with them to see if it still makes
> sense.

I see :)

BTW, some interesting thing we found during the dbench/stress testing
is, by doing:

	echo 240000000 > /proc/sys/kernel/sched_latency_ns
        echo NO_GENTLE_FAIR_SLEEPERS > /sys/kernel/debug/sched_features

that is sched_latency_ns increased around 10 times and
GENTLE_FAIR_SLEEPERS was disabled, the dbench got it's CPU back.

However, when the group level is too deep, that doesn't works any more...

I'm not sure but seems like 'deep group level' and 'vruntime bonus for
sleeper' is the keep points here, will try to list the root cause after
more investigation, thanks for the hints and suggestions, really helpful ;-)

Regards,
Michael Wang

> 

