Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaICGtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:49:43 -0400
Received: from mail3.unitn.it ([193.205.206.24]:53757 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbaICGtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:49:41 -0400
Message-ID: <5406BA02.20806@unitn.it>
Date: Wed, 03 Sep 2014 08:49:38 +0200
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@arm.com>
CC: peterz@infradead.org, rdunlap@infradead.org, mingo@redhat.com,
        raistlin@linux.it, juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] Documentation/scheduler/sched-deadline.txt: improve
 and clarify AC bits
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com> <1409220029-9002-4-git-send-email-juri.lelli@arm.com> <20140902214538.GC22581@sisyphus.home.austad.us>
In-Reply-To: <20140902214538.GC22581@sisyphus.home.austad.us>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/02/2014 11:45 PM, Henrik Austad wrote:
[...]
>> + On multiprocessor systems with global EDF scheduling (non partitioned
>> + systems), a sufficient test for schedulability can not be based on the
>> + utilisations (it can be shown that task sets with utilisations slightly
>> + larger than 1 can miss deadlines regardless of the number of CPUs M).
>> + However, as previously stated, enforcing that the total utilisation is smaller
>> + than M is enough to guarantee that non real-time tasks are not starved and
>> + that the tardiness of real-time tasks has an upper bound.
>
> I'd _really_ appreciate a link to a paper where all of this is presented
> and proved!
Well, my original plan was to add the bibliography in the next round of patches...
Is this ok?

[...]
>> + As already stated in Section 3, a necessary condition to be respected to
>> + correctly schedule a set of real-time tasks is that the total utilisation
>> + is smaller than M. When talking about -deadline tasks, this requires to
>> + impose that the sum of the ratio between runtime and period for all tasks
>> + is smaller than M.
>
> "This requires to impose that .." uhm, what? Drop 'to impose'.
Ok. I'll send an updated patch to Juri in few days


>> [...] Notice that the ratio runtime/period is equivalent to
>> + the utilisation of a "traditional" real-time task, and is also often
>> + referred to as "bandwidth".
>> + The interface used to control the CPU bandwidth that can be allocated
>> + to -deadline tasks is similar to the one already used for -rt
>>    tasks with real-time group scheduling (a.k.a. RT-throttling - see
>>    Documentation/scheduler/sched-rt-group.txt), and is based on readable/
>>    writable control files located in procfs (for system wide settings).
>> @@ -232,8 +285,16 @@ CONTENTS
>>    950000. With rt_period equal to 1000000, by default, it means that -deadline
>>    tasks can use at most 95%, multiplied by the number of CPUs that compose the
>>    root_domain, for each root_domain.
>> -
>> - A -deadline task cannot fork.
>> + This means that non -deadline tasks will receive at least 5% of the CPU time,
>> + and that -deadline tasks will receive their runtime with a guaranteed
>> + worst-case delay respect to the "deadline" parameter. If "deadline" = "period"
>> + and the cpuset mechanism is used to implement partitioned scheduling (see
>> + Section 5), then this simple setting of the bandwidth management is able to
>> + deterministically guarantee that -deadline tasks will receive their runtime
>> + in a period.
>
> The whole 950000 / 1000000, is at least 50 *consecutive* ms given to non
> rt/dl tasks every second, or is this more finegrained now?
>
> If the 50ms can be given in a single go, then I don't think you can
> guarantee that deadline-tasks will receive their runtime in a period - a
> period can be <50ms, no?
Uhmm... Maybe there is something I am missing in how the SCHED_DEADLINE admission
control is implemented, but I do not know about any "50 consecutive ms to non dl
tasks" rule. I agree that if there is such a rule then deadline tasks are screwed.
Juri?


>> + Finally, notice that in order not to jeopardize this admission control a
>> + -deadline task cannot fork.
>
> s/this/the
> (there aren't any other admission controls in the kernel)
Ok; this will go in my updated patch



			Thanks,
				Luca
