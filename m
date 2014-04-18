Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaDRLey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:34:54 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56469 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRLev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:34:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140418105601.GU11182@twins.programming.kicks-ass.net>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <1397209481-28542-2-git-send-email-vincent.guittot@linaro.org> <20140418105601.GU11182@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 18 Apr 2014 13:34:30 +0200
Message-ID: <CAKfTPtCQpesxEMOcaOPemv+QydhrnN9H=NPHdczsY991Vhtdkg@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] sched: rework of sched_domain topology definition
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2014 12:56, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Apr 11, 2014 at 11:44:37AM +0200, Vincent Guittot wrote:
>> We replace the old way to configure the scheduler topology with a new method
>> which enables a platform to declare additionnal level (if needed).
>>
>> We still have a default topology table definition that can be used by platform
>> that don't want more level than the SMT, MC, CPU and NUMA ones. This table can
>> be overwritten by an arch which either wants to add new level where a load
>> balance make sense like BOOK or powergating level or wants to change the flags
>> configuration of some levels.
>>
>> For each level, we need a function pointer that returns cpumask for each cpu,
>> a function pointer that returns the flags for the level and a name. Only flags
>> that describe topology, can be set by an architecture. The current topology
>> flags are:
>>  SD_SHARE_CPUPOWER
>>  SD_SHARE_PKG_RESOURCES
>>  SD_NUMA
>>  SD_ASYM_PACKING
>>
>> Then, each level must be a subset on the next one. The build sequence of the
>> sched_domain will take care of removing useless levels like those with 1 CPU
>> and those with the same CPU span and no more relevant information for
>> load balancing than its childs.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>
> On x86_64 defconfig this gets me:
>
> kernel/sched/core.c: In function 'sched_init_numa':
> kernel/sched/core.c:6197:4: warning: initialization makes pointer from integer without a cast [enabled by default]
> kernel/sched/core.c:6197:4: warning: (near initialization for '(anonymous).sd_flags') [enabled by default]

Sorry, while moving from int to function pointer, i forgot to change
the numa part

I'm going to send a fix right now


>
