Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaE2Tve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:51:34 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33061 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaE2Tvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140529135510.GG11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org> <20140529135510.GG11074@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 29 May 2014 21:51:12 +0200
Message-ID: <CAKfTPtAdUJfXQAEwA+9+rNJrKE-3B9ZOELUxsWfyVXWre0mKjQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] sched: replace capacity by activity
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

On 29 May 2014 15:55, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 23, 2014 at 05:53:05PM +0200, Vincent Guittot wrote:
>> The scheduler tries to compute how many tasks a group of CPUs can handle by
>> assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
>> SCHED_POWER_SCALE.
>> We can now have a better idea of the utilization of a group fo CPUs thanks to
>> group_actitvity and deduct how many capacity is still available.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>
> Right, so as Preeti already mentioned, this wrecks SMT. It also seems to
> loose the aggressive spread, where we want to run 1 task on each 'core'
> before we start 'balancing'.
>
> So I think we should be able to fix this by setting PREFER_SIBLING on
> the SMT domain, that way we'll get single tasks running on each SMT
> domain before filling them up until capacity.
>
> Now, its been a while since I looked at PREFER_SIBLING, and I've not yet
> looked at what your patch does to it, but it seems to me that that is
> the first direction we should look for an answer to this.

OK, i'm going to look more deeply in PREFER_SIBLING too
