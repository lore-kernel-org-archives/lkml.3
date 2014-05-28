Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaE1Qjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:39:32 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34720 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaE1Qjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:39:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140528154703.GJ19967@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin> <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 28 May 2014 18:39:10 +0200
Message-ID: <CAKfTPtCd8Mm+bvO3f1ybRC=gV-vQ=_5SxcUnOiuZ0XTf0JN=mA@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2014 17:47, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Wed, May 28, 2014 at 02:15:03PM +0100, Vincent Guittot wrote:
>> On 28 May 2014 14:10, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
>> > On Fri, May 23, 2014 at 04:53:02PM +0100, Vincent Guittot wrote:

[snip]

>
>> This value is linked to the CPU on
>> which it has run previously because of the time sharing with others
>> tasks, so the unweighted load of a freshly migrated task will reflect
>> its load on the previous CPU (with the time sharing with other tasks
>> on prev CPU).
>
> I agree that the task runnable_avg_sum is always affected by the
> circumstances on the cpu where it is running, and that it takes this
> history with it. However, I think cfs.runnable_load_avg leads to less
> problems than using the rq runnable_avg_sum. It would work nicely for
> the two tasks on two cpus example I mentioned earlier. We don't need add

i would say that nr_running is an even better metrics for such
situation as the load doesn't give any additional information.
Just to point that we can spent a lot of time listing which use case
are better covered by which metrics :-)

> something on top when the cpu is fully utilized by more than one task.
> It comes more naturally with cfs.runnable_load_avg. If it is much larger
> than 47742, it should be fairly safe to assume that you shouldn't stick
> more tasks on that cpu.
>
>>
>> I'm not saying that such metric is useless but it's not perfect as well.
>
> It comes with its own set of problems, agreed. Based on my current
> understanding (or lack thereof) they just seem smaller :)

I think it's worth using the cpu utilization for some cases because it
has got some information that are not available elsewhere. And the
replacement of the current capacity computation is one example.
As explained previously, I'm not against adding other metrics and i'm
not sure to understand why you oppose these 2 metrics whereas they
could be complementary

Vincent

>
> Morten
