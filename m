Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaJ1IDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:03:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:32665 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaJ1IC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,801,1406617200"; 
   d="scan'208";a="621918299"
Message-ID: <544F4B31.7050308@linux.intel.com>
Date: Tue, 28 Oct 2014 15:52:17 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027074419.GE10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141027074419.GE10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/27 15:44, Peter Zijlstra wrote:
> On Mon, Oct 27, 2014 at 02:27:27PM +0800, Li, Aubrey wrote:
>>>> +static void freezer_suspend_tk(int cpu)
>>>>  {
>>>> +	if (tick_do_timer_cpu != cpu)
>>>> +		return;
>>>> +
>>>
>>> I had a note here that this might be broken for clocksource drivers that
>>> have suspend/resume methods. You seem to have 'lost' that note, is that
>>> because you found it isn't a problem?
>>>
>> I don't see it's a problem as long as we do not refer the clock source
>> before it resumes. But I think my testing didn't cover that case that
>> clock source drivers have suspend/resume methods. Can you please give
>> more details what do you worry about?
> 
> I can't seem to recall :/ Maybe I conflated clocksource and clockevents
> and figured we'd need to run the clocksource suspend callback on each
> cpu.

Both clocksource and clockevents are not per-cpu device, why do we need
to run their suspend callback on *each* cpu?

Thanks,
-Aubrey

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

