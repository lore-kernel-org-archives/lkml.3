Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaDRLzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:55:12 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50445 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaDRLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:55:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140418105801.GV11182@twins.programming.kicks-ass.net>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <1397209481-28542-5-git-send-email-vincent.guittot@linaro.org> <20140418105801.GV11182@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 18 Apr 2014 13:54:48 +0200
Message-ID: <CAKfTPtATHUk8kswxQ+MaGhFa-m4TB4pcAxL5mBJHOOZXmm8bwA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
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

On 18 April 2014 12:58, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Apr 11, 2014 at 11:44:40AM +0200, Vincent Guittot wrote:
>> A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
>> in a sched_domain level can or not reach different power state. As an example,
>> the flag should be cleared at CPU level if groups of cores can be power gated
>> independently. This information can be used in the load balance decision or to
>> add load balancing level between group of CPUs that can power gate
>> independantly.
>> This flag is part of the topology flags that can be set by arch.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>
> Building a cris-defconfig this gets me an endless stream of misery:
>
> In file included from /usr/src/linux-2.6/init/do_mounts.c:12:0:
> /usr/src/linux-2.6/include/linux/sched.h:1048:46: warning: 'struct sched_domain_topology_level' declared inside parameter list [enabled by default]
> /usr/src/linux-2.6/include/linux/sched.h:1048:46: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> In file included from /usr/src/linux-2.6/include/linux/utsname.h:5:0,
>                  from /usr/src/linux-2.6/include/linux/init_task.h:6,
>                  from /usr/src/linux-2.6/init/init_task.c:1:
>
> Might be something about UP builds, didn't check x86-UP.

yes, you're right
An empty set_sched_topology function has been define for UP whereas it
can't because of the sched_domain_topology_level parameter which is
available only in SMP

I'm going to send a fix.

sorry for the dumb error
