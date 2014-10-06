Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaJFIza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:55:30 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:57876 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaJFIz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141003153826.GM2849@worktop.programming.kicks-ass.net>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org> <20141003153826.GM2849@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 6 Oct 2014 10:55:07 +0200
Message-ID: <CAKfTPtBrS=xJeDuW9_LjtUxdB0U-9ANnhhF8_u_-nxVDGfdHyw@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2014 17:38, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Sep 23, 2014 at 06:08:04PM +0200, Vincent Guittot wrote:
>
>> This implementation of utilization_avg_contrib doesn't solve the scaling
>> in-variance problem, so i have to scale the utilization with original
>> capacity of the CPU in order to get the CPU usage and compare it with the
>> capacity. Once the scaling invariance will have been added in
>> utilization_avg_contrib, we will remove the scale of utilization_avg_contrib
>> by cpu_capacity_orig in get_cpu_usage. But the scaling invariance will come
>> in another patchset.
>
> I would have expected this in the previous patch that introduced that
> lot. Including a few words on how/why the cpu_capacity is a 'good'
> approximation etc..

That's fair, i can move the explanation

>
>> Finally, the sched_group->sched_group_capacity->capacity_orig has been removed
>> because it's more used during load balance.
>
> That sentence is a contradiction, I expect there's a negative gone
> missing someplace.

yes the "no" is of "because it is no more used during load balance" is missing
