Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaIEMY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:24:26 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:59726 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbaIEMYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <5409A73B.4050402@linux.vnet.ibm.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org> <5409A73B.4050402@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 5 Sep 2014 14:24:04 +0200
Message-ID: <CAKfTPtA=rfM5VWF9On1SJUcNcTvYOBg-XVMcL8bY8LD2BjceYg@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher capacity
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2014 14:06, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> On 08/26/2014 04:36 PM, Vincent Guittot wrote:
>> If the CPU is used for handling lot of IRQs, trig a load balance to check if
>> it's worth moving its tasks on another CPU that has more capacity.
>>
>> As a sidenote, this will note generate more spurious ilb because we already
>> trig an ilb if there is more than 1 busy cpu. If this cpu is the only one that
>> has a task, we will trig the ilb once for migrating the task.
>>
>> The nohz_kick_needed function has been cleaned up a bit while adding the new
>> test
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> So I see that there are added checks in your previous patches on if the
> cpu capacity for CFS tasks is good enough to run tasks on the cpu. My
> concern is although they appear sensible, would they trigger an increase
> in the number of times we load balance to a large extent.
>
> Ebizzy would not test this aspect right? There are no real time
> tasks/interrupts that get generated.

yes, ebizzy doesn't test this part but check for non regression

The scp test is the one that i use to check this patch and the
previous one but a test with some cfs and rt tasks should also do the
jobs.
we can see an increase of 82% for the dual core when
CONFIG_IRQ_TIME_ACCOUNTING is enable

>
> Besides, what is the column that says patchset+irq? What is the irq
> accounting patchset that you refer to in your cover letter?

it refers to CONFIG_IRQ_TIME_ACCOUNTING which includes the time spent
under interrupt context to compute the scale_rt_capacity

Regards,
Vincent

>
> Regards
> Preeti U Murthy
>
