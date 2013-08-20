Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3HTPmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:42:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:6912 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3HTPmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="scan'208";a="349055136"
Message-ID: <52138E46.1030007@linux.intel.com>
Date: Tue, 20 Aug 2013 08:41:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        =?ISO-8859-1?Q?Fernando_Luis_?= =?ISO-8859-1?Q?V=E1zquez_Cao?= 
	<fernando_b1@lab.ntt.co.jp>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
References: <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130819111026.GE24092@twins.programming.kicks-ass.net> <521313D8.9080500@lab.ntt.co.jp> <20130820084405.GC3258@twins.programming.kicks-ass.net> <20130820152910.GB17441@somewhere> <52138C5E.4060705@linux.intel.com> <20130820153524.GC17441@somewhere>
In-Reply-To: <20130820153524.GC17441@somewhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/2013 8:35 AM, Frederic Weisbecker wrote:
> On Tue, Aug 20, 2013 at 08:33:50AM -0700, Arjan van de Ven wrote:
>> On 8/20/2013 8:29 AM, Frederic Weisbecker wrote:
>>
>>>>
>>>> Of course, if we can get away with completely removing all of that
>>>> (which I think Arjan suggested was a real possibility) then that would
>>>> be ever so much better still :-)
>>>
>>> Would be lovely. But I don't know much about cpufreq, I hope somebody who's
>>> familiar with that code can handle this. Then once there are no more users
>>> of get_cpu_iowait_sleep_time() I can simply zap and clean the tick/time related
>>> code.
>>
>> it's just doing the "idle = 100 - busy% - iowait%" calculation.
>> (with the later part only for Intel cpus iirc)
>>
>> in a perfect world the scheduler would be doing that calculation in the first place ;-)
>>
>> removing the later part will impact performance some on specific workloads,
>> but most Intel cpus that this applies to should not be using cpufreq anymore
>> anyway.
>
> Are there other users than intel?
>

http://lxr.linux.no/linux+v3.10.7/drivers/cpufreq/cpufreq_ondemand.c#L69

nope
