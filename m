Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaE1LPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:15:23 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51840 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaE1LPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140528105855.GR30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-10-git-send-email-vincent.guittot@linaro.org> <20140528105855.GR30445@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 28 May 2014 13:15:01 +0200
Message-ID: <CAKfTPtAvFEmAmPMQsEN-=ftudQwd0fHOxq4MRs3HDyHYjLPGZQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] sched: test the cpu's capacity in wake affine
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2014 12:58, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 23, 2014 at 05:53:03PM +0200, Vincent Guittot wrote:
>> Currently the task always wakes affine on this_cpu if the latter is idle.
>> Before waking up the task on this_cpu, we check that this_cpu capacity is not
>> significantly reduced because of RT tasks or irq activity.
>>
>> Use case where the number of irq and the time spent under irq is important
>> will take benefit of this because the task that is woken up by irq or softirq
>> will not use the same CPU than irq (and softirq) but a idle one which share
>> its LLC.
>
> OK, so I'm having a terrible time parsing the above.
>
> So looking at the patch you make balance false even when this_load==0
> when the effective power/capacity (nico's patches haven't fully sunk in
> yet) of this cpu is less than that of the previous cpu.
>
> Is that right?

yes,

>
> Now I'm only struggling to understand the rationale for this, its got
> LLC in there somewhere, but I'm failing to comprehend.

Ah.. i have probably overestimated the fact that wake_affine was only
done at MC or SMT level but after reading more deeply the glags
configuration of all  sched_domain level , my assumption is not true.
So I need to test sd flag to make sure that their share their cache at
this level
