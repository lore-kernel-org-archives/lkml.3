Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaKFLbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:31:36 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46704 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:31:34 -0500
Message-ID: <545B5C07.6050400@gmail.com>
Date: Thu, 06 Nov 2014 19:31:19 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] sched/deadline: support dl task migration during
 cpu hotplug
References: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com> <20141105105058.GQ3337@twins.programming.kicks-ass.net> <545A0317.4090406@gmail.com> <20141105125254.GT3337@twins.programming.kicks-ass.net> <20141106014634.GA25640@kernel> <20141106100823.GR10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141106100823.GR10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14/11/6 下午6:08, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 09:46:34AM +0800, Wanpeng Li wrote:
>
>>> Ah, it could be that for offline cpus we have a singleton rd. Lemme try
>> I still cannot find where build the singleton rd in the codes, could you
>> point out?
> So this is all quite horrible code, but what I think happens is that:
>
> 	sched_cpu_inactive() -> set_cpu_active(cpu, false);
> 	cpuset_cpu_inactive() -> cpuset_update_active_cpus(false)
> 	                      -> partition_sched_domains(1, NULL, NULL)
> 			      -> build_sched_domains(cpu_active_mask)
> 			      -> for_each_cpu()
> 			           cpu_attach_domain() -> rq_attach_root()
>
> Now, that will detach all active cpus from the current root domain and
> attach them to the new root domain. Which leaves behind the old root
> domain attached to only the one 'dead' cpu.

Got it, thanks for your great explanation. ;-)

Regards,
Wanpeng Li


