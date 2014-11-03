Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaKCK7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:59:43 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:52783 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaKCK7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:59:34 -0500
MIME-Version: 1.0
In-Reply-To: <54572852.7040304@gmail.com>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
 <1414745252-4895-8-git-send-email-vincent.guittot@linaro.org> <54572852.7040304@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 3 Nov 2014 11:59:12 +0100
Message-ID: <CAKfTPtC64X+FoKXkVmNE=wntjzhK=P9F4N08a-WNGdan1oX65w@mail.gmail.com>
Subject: Re: [PATCH v8 07/10] sched: replace capacity_factor by usage
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 November 2014 08:01, Wanpeng Li <kernellwp@gmail.com> wrote:
> Hi Vincent,
> On 14/10/31 下午4:47, Vincent Guittot wrote:
>>
>> The scheduler tries to compute how many tasks a group of CPUs can handle
>> by
>> assuming that a task's load is SCHED_LOAD_SCALE and a CPU's capacity is
>> SCHED_CAPACITY_SCALE. group_capacity_factor divides the capacity of the
>> group
>> by SCHED_LOAD_SCALE to estimate how many task can run in the group. Then,
>> it
>> compares this value with the sum of nr_running to decide if the group is
>> overloaded or not. But the group_capacity_factor is hardly working for SMT
>>   system, it sometimes works for big cores but fails to do the right thing
>> for
>>   little cores.
>>
>> Below are two examples to illustrate the problem that this patch solves:
>>
>> 1- If the original capacity of a CPU is less than SCHED_CAPACITY_SCALE
>> (640 as an example), a group of 3 CPUS will have a max capacity_factor of
>> 2
>> (div_round_closest(3x640/1024) = 2) which means that it will be seen as
>> overloaded even if we have only one task per CPU.
>>
>> 2 - If the original capacity of a CPU is greater than SCHED_CAPACITY_SCALE
>> (1512 as an example), a group of 4 CPUs will have a capacity_factor of 4
>> (at max and thanks to the fix [0] for SMT system that prevent the
>> apparition
>
>
> What's the story of 'fix [0] for SMT system' here?

The [0] url has disappeared. please find it below:
[0] https://lkml.org/lkml/2013/8/28/194

Let me know if your need more explanation than my answer of your
previous question for the cover letter

Regards,
Vincent

>
> Regards,
> Wanpeng Li
>
>
>> of ghost CPUs) but if one CPU is fully used by rt tasks (and its capacity
>> is
>> reduced to nearly nothing), the capacity factor of the group will still be
>> 4
>> (div_round_closest(3*1512/1024) = 5 which is cap to 4 with [0]).
>>

[snip]
