Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3AUClJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:41:09 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42370 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3AUClH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:41:07 -0500
Message-ID: <50FCAA82.2030903@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 08:10:02 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com> <CAKfTPtDF==vxfLy8JA5UtszdRPFSoTs8t7LkdeUjUOM6SsF1PA@mail.gmail.com> <50EBB76A.3070501@linux.vnet.ibm.com> <CAKfTPtB4ABqkB=x6sUzCmvJCj6p+RaFKpGYneNt+zASyL-oU0w@mail.gmail.com> <50ECE097.7010609@linux.vnet.ibm.com> <50FC0DB1.6050605@intel.com> <50FC12B4.2030103@intel.com>
In-Reply-To: <50FC12B4.2030103@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012102-5816-0000-0000-000006562AEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,
Thank you very much for running the below benchmark on
blocked_load+runnable_load:) Just a few queries.

How did you do the wake up balancing? Did you iterate over the L3
package looking for an idle cpu? Or did you just query the L2 package
for an idle cpu?

I think when you are using blocked_load+runnable_load it would be better
if we just query the L2 package as Vincent had pointed out because the
fundamental behind using blocked_load+runnable_load is to keep a steady
state across cpus unless we could reap the advantage of moving the
blocked load to a sibling core when it wakes up.

And the drop of performance is relative to what?
1.Your v3 patchset with runnable_load_avg in weighted_cpu_load().
2.Your v3 patchset with runnable_load_avg+blocked_load_avg in
weighted_cpu_load().

Are the above two what you are comparing? And in the above two versions
have you included your [PATCH] sched: use instant load weight in burst
regular load balance?

On 01/20/2013 09:22 PM, Alex Shi wrote:
>>>> The blocked load of a cluster will be high if the blocked tasks have
>>>> run recently. The contribution of a blocked task will be divided by 2
>>>> each 32ms, so it means that a high blocked load will be made of recent
>>>> running tasks and the long sleeping tasks will not influence the load
>>>> balancing.
>>>> The load balance period is between 1 tick (10ms for idle load balance
>>>> on ARM) and up to 256 ms (for busy load balance) so a high blocked
>>>> load should imply some tasks that have run recently otherwise your
>>>> blocked load will be small and will not have a large influence on your
>>>> load balance
>>
>> Just tried using cfs's runnable_load_avg + blocked_load_avg in
>> weighted_cpuload() with my v3 patchset, aim9 shared workfile testing
>> show the performance dropped 70% more on the NHM EP machine. :(
>>
> 
> Ops, the performance is still worse than just count runnable_load_avg.
> But dropping is not so big, it dropped 30%, not 70%.
> 

Thank you

Regards
Preeti U Murthy

