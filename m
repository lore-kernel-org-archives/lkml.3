Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaGDQDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:03:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46794 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaGDQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:03:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140704110612.GA6120@e103034-lin>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
	<20140703231950.GA4881@intel.com>
	<20140704110612.GA6120@e103034-lin>
Date: Fri, 4 Jul 2014 19:03:51 +0300
Message-ID: <CAJL_dMtiAozRT5hGuQcAZ5xZwLwqdbpmVg80nMV=Shzs-Ys4dQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware scheduling
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Yuyang Du <yuyang.du@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sounds like an an math problem ( for Donald Knuth :) )
You need to think out of the box, present the problem right is just
the fist step and an big one.
Then you need to come with an formal algorithm to solve it, then proof it.
Next step is to code that algorithm and verify that is working in real world.

If you not present the problem right ( missed bigLittle,
over/down-clocking ) you will not get the wright algorithm.
For new algorithms very few people does it right for the first time.

On Fri, Jul 4, 2014 at 2:06 PM, Morten Rasmussen
<morten.rasmussen@arm.com> wrote:
> Hi Yuyang,
>
> On Fri, Jul 04, 2014 at 12:19:50AM +0100, Yuyang Du wrote:
>> Hi Morten,
>>
>> On Fri, Jul 04, 2014 at 12:25:47AM +0800, Morten Rasmussen wrote:
>> > * Note that these energy savings are _not_ representative of what can be
>> > achieved on a true SMP platform where all cpus are equally
>> > energy-efficient. There should be benefit for SMP platforms as well,
>> > however, it will be smaller.
>> >
>> > The energy model led to consolidation of the short tasks on the A7
>> > cluster (more energy-efficient), while sysbench made use of all cpus as
>> > the A7s didn't have sufficient compute capacity to handle the five
>> > tasks.
>>
>> Looks like this patchset is mainly for big.LITTLE?
>
> No, not at all. The only big.LITTLE in there is the test platform but
> that has been configured to be as close as possible to an SMP platform.
> That is, no performance difference between cpus. I would have preferred
> a true SMP platform for testing, but this is the only dual-cluster
> platform that I have access to with proper mainline kernel support.
>
> The patch set essentially puts tasks where it is most energy-efficient
> guided by the platform energy model. That should benefit any platform,
> SMP and big.LITTLE. That is at least the goal.
>
> On an SMP platform with two clusters/packages (whatever you call a group
> of cpus sharing the same power domain) you get task consolidation on a
> single cluster if the energy model says that it is beneficial. Very much
> like your previous proposals. It is also what I'm trying to show with
> the numbers I have included.
>
> That said, we are of course keeping in mind what would be required to
> make this work for big.LITTLE. However, there is nothing big.LITTLE
> specific in the patch set. Just the possibility of having different
> energy models for different cpus in the system. We will have to add some
> tweaks eventually to get the best out of big.LITTLE later. Somewhat
> similar to what exists today for better SMT support and other
> architecture specialities.
>
>> And can the patchset actually replace Global Task Scheduling?
>
> Global Task Scheduling is (ARM) marketing speak for letting the
> scheduler know about all cpus in a big.LITTLE system. It is not an
> actual implementation. There is an out-of-tree implementation of GTS
> available which is very big.LITTLE specific.
>
> The energy model driven scheduling proposed here is not big.LITTLE
> specific, but aims at introducing generic energy-awareness in the
> scheduler. Once energy-awareness is in place, most of the support needed
> for big.LITTLE will be there too. It is generic energy-aware code that
> is capable of making informed decisions based on the platform model,
> big.LITTLE or SMP.
>
> The short answer is: Not in its current state, but if we get the
> energy-awareness right it should be able to.
>
> Morten
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
