Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaKCQOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:14:39 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:54349 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaKCQOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:14:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141103155129.GK12706@worktop.programming.kicks-ass.net>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
 <1414745252-4895-11-git-send-email-vincent.guittot@linaro.org> <20141103155129.GK12706@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 3 Nov 2014 17:14:15 +0100
Message-ID: <CAKfTPtBQmhv1Lpjsak27m+GW=3tBuskRqv5UiL_cW7rGnVBp9g@mail.gmail.com>
Subject: Re: [PATCH v8 10/10] sched: make scale_rt invariant with frequency
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
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 November 2014 16:51, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 31, 2014 at 09:47:32AM +0100, Vincent Guittot wrote:
>> The call to arch_scale_frequency_capacity in the rt scheduling path might be
>> a concern for RT folks because I'm not sure whether we can rely on
>> arch_scale_freq_capacity to be short and efficient ?
>
> Well, you put it in quite a hot path on the CFS side too, so it had
> better be blazing fast anyhow.
>
>
> That said, can you move all the running + invariance bits at the
> beginning of the patch set, these appear to be the least controversial
> bits and 'desired' by quite a few people, so we'll try and get those
> agreed upon and merged first.

ok

I'm going to resend with the following order

sched: add utilization_avg_contrib
sched: Track group sched_entity usage contributions
sched: remove frequency scaling from cpu_capacity
sched: Make sched entity usage tracking scale-invariant
sched: make scale_rt invariant with frequency
sched: add per rq cpu_capacity_orig
sched: get CPU's usage statistic
sched: replace capacity_factor by usage
sched: add SD_PREFER_SIBLING for SMT level
sched: move cfs task on a CPU with higher capacity
