Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaEPCXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 22:23:22 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43702 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaEPCXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 22:23:20 -0400
Message-ID: <5375768F.1010000@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 10:23:11 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com> <20140513142328.GE2485@laptop.programming.kicks-ass.net> <53731D12.7040804@linux.vnet.ibm.com> <20140514094426.GF30445@twins.programming.kicks-ass.net> <5374387E.4080802@linux.vnet.ibm.com> <20140515083531.GE30445@twins.programming.kicks-ass.net> <53747EE4.3020605@linux.vnet.ibm.com> <20140515090638.GI30445@twins.programming.kicks-ass.net> <53748A5D.6070605@linux.vnet.ibm.com> <20140515115751.GK30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140515115751.GK30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051602-8256-0000-0000-00000D239F72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 07:57 PM, Peter Zijlstra wrote:
[snip]
>>
>> It's like:
>>
>> 	/cgroup/cpu/l1/l2/l3/l4/l5/l6/A
>>
>> about level 7, the issue can not be solved any more.
> 
> That's pretty retarded and yeah, that's way past the point where things
> make sense. You might be lucky and have l1-5 as empty/pointless
> hierarchy so the effective depth is less and then things will work, but
> *shees*..

Exactly, that's the simulation of cgroup topology setup by libvirt,
really doesn't make sense... rather torture than deployment, but they do
make things like that...

> 
[snip]
>> I'm not sure which account will turns to be huge when group get deeper,
>> the load accumulation will suffer discount when passing up, isn't it?
>>
> 
> It'll use 20 bits for precision instead of 10, so it gives a little more
> 'room' for deeper hierarchies/big cpu-count.

Got it :)

> 
> All assuming you're running 64bit kernels of course.

Yes, it's 64bit, I tried the testing with this feature on, seems like
haven't address the issue...

But we found that one difference when group get deeper is the tasks of
that group become to gathered on CPU more often, some time all the
dbench instances was running on the same CPU, this won't happen for l1
group, may could explain why dbench could not get CPU more than 100% any
more.

But why the gather happen when group get deeper is unclear... will try
to make it out :)

Regards,
Michael Wang

> 

