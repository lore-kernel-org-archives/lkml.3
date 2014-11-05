Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaKEK7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:59:44 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48851 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaKEK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:59:43 -0500
Message-ID: <545A0317.4090406@gmail.com>
Date: Wed, 05 Nov 2014 18:59:35 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] sched/deadline: support dl task migration during
 cpu hotplug
References: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com> <20141105105058.GQ3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141105105058.GQ3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On 14/11/5 下午6:50, Peter Zijlstra wrote:
> On Wed, Nov 05, 2014 at 04:51:57PM +0800, Wanpeng Li wrote:
>> Note: dl task can be migrated successfully if rq is offline currently, however,
>> I'm still not sure why task_rq(task)->rd->span just include the cpu which the dl
>> task previous running on, so cpu_active_mask is used in the patch.
>>
>> Peterz, Juri?
> So the root domain span is for exclusive cpusets
> (Documentation/cgroups/cpusets.txt) where we fully separate sets of CPUs
> and have no load-balancing between the sets.
>
> For 'normal' setups the rd->span is the entire machine, but using
> cpusets you can create more (smaller) domains.

I don't setup any cpusets related stuff, however, 
task_rq(task)->rd->span just include the cpu which the dl task previous 
running on instead of the entire machine in find_later_rq().

Regards,
Wanpeng Li

>
> Is this what you were asking?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

