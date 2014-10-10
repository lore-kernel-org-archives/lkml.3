Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaJJOic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:38:32 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:48004 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaJJOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141009151211.GV10832@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-6-git-send-email-vincent.guittot@linaro.org>
 <20141009113614.GP4750@worktop.programming.kicks-ass.net> <CAKfTPtDtfhQDWNjU5i-YpX4-Ak3nT3uaOCvhqgNP-u=-La7_gw@mail.gmail.com>
 <20141009151211.GV10832@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 10 Oct 2014 16:38:06 +0200
Message-ID: <CAKfTPtBVbs=sniL4UJ-Ax4zpVwf1ut8RVpYTVRnmYN4VOhhzvw@mail.gmail.com>
Subject: Re: [PATCH v7 5/7] sched: get CPU's usage statistic
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 17:12, Peter Zijlstra <peterz@infradead.org> wrote:

>> >> +static int get_cpu_usage(int cpu)
>> >> +{
>> >> +     unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
>> >> +     unsigned long capacity = capacity_orig_of(cpu);
>> >> +
>> >> +     if (usage >= SCHED_LOAD_SCALE)
>> >> +             return capacity + 1;
>> >
>> > Like Morten I'm confused by that +1 thing.
>>
>> ok. the goal was to point out the erroneous case where usage is out of
>> the range but if it generates confusion, it can remove it
>
> Well, the fact that you clip makes that point, returning a value outside
> of the specified range doesn't.

i meant removing the +1
