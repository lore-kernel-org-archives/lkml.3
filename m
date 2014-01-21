Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaAUOiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:38:08 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60045 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaAUOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:38:06 -0500
Message-ID: <52DE8649.4080909@gmail.com>
Date: Tue, 21 Jan 2014 15:38:01 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Luca Abeni <luca.abeni@unitn.it>
CC: Henrik Austad <henrik@austad.us>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com> <20140120112442.GA8907@austad.us> <52DD1377.5090201@gmail.com> <20140120131616.GB8907@austad.us> <52DD2711.9080504@unitn.it> <20140121102016.GA12002@austad.us> <52DE5B7F.8020900@unitn.it> <20140121123334.GJ30183@twins.programming.kicks-ass.net> <52DE6D21.1080602@unitn.it> <20140121135559.GK30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140121135559.GK30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 02:55 PM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 01:50:41PM +0100, Luca Abeni wrote:
>> On 01/21/2014 01:33 PM, Peter Zijlstra wrote:
> 
>>>> - During the execution of a job, the task might invoke a blocking system call,
>>>>   and block... When it wakes up, it is still in the same job (decoding the same
>>>>   video frame), and not in a different one.
>>>> This is (IMHO) where all the confusion comes from.
>>>
>>> I would strongly urge you not to use that as an example, because its
>>> dead wrong design. An RT thread (be it RR,FIFO or DL) should _NEVER_ do
>>> blocking IO.
>> Well, but it does happen in reality :)
> 
> Yeah, I know, my point was more about not encouraging people to do this
> by explicitly mentioning it.
> 
>> On the other hand, I agree with you that a hard real-time task should be designed
>> not to do things like this. But SCHED_DEADLINE is flexible enough to be used on
>> many different kinds of tasks (hard real-time, soft real-time, etc...).
> 
> At which point I feel obliged to mention the work Jim did on statistical
> bounded tardiness and a potential future option:
> SCHED_FLAG_DL_AVG_RUNTIME, where we would allow tasks to somewhat exceed
> their runtime budget provided that they meet their budget on average.
> 
> A possible implementation could be to track the unused budget of
> previous instances and keep a decaying sum (such that we're guaranteed
> this unused budget < 2*runtime). And then allow runtime overruns upto
> this limit.
> 
> Another possibly extension; one proposed by Ingo; is to demote tasks to
> SCHED_OTHER once they exceed their budget instead of the full block they
> get now -- we could possibly call this SCHED_FLAG_DL_CBS_SOFT or such.
> 
> And of course SCHED_FLAG_DL_CBS_SIGNAL, where the task gets a signal
> delivered if it exceeded the runtime -- I think some of the earlier
> patches had things like this, no?
>

Yes, they both got removed along the way. But we can pick them back if we
realize that they are needed for some scenario.

>>> On the other subject; I wouldn't actually mind if it grew into a proper
>>> (academic or not) summary of deadline scheduling theory and how it
>>> applies.
>>>
>>> Sure, refer to actual papers for all the proofs and such, but it would
>>> be very good to go over all the bits and pieces that make up the system.
>>>
>>> So cover the periodic, sporadic and aperiodic model like henr_k
>>> suggested, please do cover the job/instance idiom as it is used all over
>>> the place.
>> Ok... My point was that it would be better (IMHO) to first explain how
>> sched_deadline works (and no notion of job/instance, etc is needed for this),
>> and then explain how this applies to the real-time task model (and here, of
>> course all the formal notation can be introduced).
>>
>> Do you think this can be reasonable?
> 
> Sure, I think that's reasonable.
> 
>>> Then also treat schedulability tests and their ramification, explain
>>> what laxity is, what tardiness is, that GEDF doesn't have 0 tardiness
>>> but does have bounded tardiness.
>>>
>>> Maybe even mention the actual bounds -- but refer to papers for their
>>> proofs.
>>>
>>> Mention CBS and the ramification etc..
>> Ok.
>> I guess some of these details can be added incrementally, with additional
>> patches?
> 
> Oh sure, all of this will always be a work in progress anyway ;-)
> 

Ok, we are working on a first update.

Thanks,

- Juri
