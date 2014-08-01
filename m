Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaHAJ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:28:48 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:59529 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbaHAJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140731191638.GG28673@intel.com>
References: <20140729015344.GF5203@intel.com> <1406800573-9692-1-git-send-email-vincent.guittot@linaro.org>
 <20140731191638.GG28673@intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 1 Aug 2014 11:28:26 +0200
Message-ID: <CAKfTPtDnO9Tq_W4qCrLhqj-t=KiCyqrsepyh-S_hhUQefp2zpQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
To: Yuyang Du <yuyang.du@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2014 21:16, Yuyang Du <yuyang.du@intel.com> wrote:
> Hi Vincent,
>
> On Thu, Jul 31, 2014 at 11:56:13AM +0200, Vincent Guittot wrote:
>>
>> load_sum is now the average runnable time before being weighted
>
> So when weight changes, load_avg will completely use new weight. I have
> some cents:
>
> 1) Task does not change weight much, so it is practically ok
>
> 2) Group entity does change weight much, and very likely back and forth,
>    so I really think keeping the intact history will make everything
>    more predictable/stable, prevent thrashing, etc.
>
> 3) If you do the same for cfs_rq->load.weight, then we simply abandoned
>    blocked entities, and all states won't compute. So we then need to
>    maintain blocked load average again, and we just can't do cfs_rq load
>    average as a whole anymore, but must update at the granularity of an
>    entity...
>
> Anyway, it does not seem to me you really need to change load_sum, no? So
> could you please not change it?
>
>> The sum of usage_sum of the tasks that are on a rq, is used to detect
>> the overload of a rq.
>
> I think you only need usage_sum for task and rq, but not cfs_rq. Others
> are ok.

yes, only usage_sum is useful for my rework of cpu_power

>
>> Does something like the patch below to be applied of top of your patchset, seem
>> reasonable add-on?
>>
>
> If you only add running statistics, I am all good, and indeed reasonable if
> you can make good use of it. I am not at all against adding anything or
> adding running average or unweighted anything...

ok. Thanks

Vincent

>
> Thanks,
> Yuyang
