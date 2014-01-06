Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbaAFSlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:41:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45117 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaAFSlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:41:21 -0500
Message-ID: <52CAF8D5.7010809@arm.com>
Date: Mon, 06 Jan 2014 18:41:25 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Redpath <Chris.Redpath@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 8/8] sched: remove scheduler domain naming
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com> <1386936688-29113-9-git-send-email-dietmar.eggemann@arm.com> <20131220140842.GW16438@laptop.programming.kicks-ass.net>
In-Reply-To: <20131220140842.GW16438@laptop.programming.kicks-ass.net>
X-OriginalArrivalTime: 06 Jan 2014 18:41:19.0271 (UTC) FILETIME=[E3958B70:01CF0B0E]
X-MC-Unique: 114010618412000701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/13 14:08, Peter Zijlstra wrote:
> On Fri, Dec 13, 2013 at 12:11:28PM +0000, dietmar.eggemann@arm.com wrote:
>> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
>>
>> In case the arch is allowed to define the conventional scheduler domain
>> topology level (i.e. the one without SD_NUMA topology flag) layout, it is
>> not feasible any more for the scheduler to name these levels.  Therefore,
>> this patch gets rid of of the sched_domain_topology_level structure
>> member 'name' and the corresponding SD_INIT_NAME macro.  It was only used
>> when CONFIG_SCHED_DEBUG was set any way.
> 
> Right, so for debug purposes it might be convenient to keep it; we could
> simply put it in the topology array, something like:
> 
>  { cpu_smt_mask, SD_SHARE_CPU_POWER | SD_SHARE_PKG_RESOURCE, SD_NAME(smt) },
> 
> which would still allow us to make it go away on !debug, but does
> provide us with a nice label to print for the debug topology prints.

I will incorporate this idea in my V2 patch set.

> 
> Alternatively we could do something like:
> 
> #define SD_mask(name, flags) \
> 	{ cpu_##name##_mask, (flags), .name = #name }
> 
> to further reduce typing.

But the MC level cpu mask func ptr is called cpu_coregroup_mask.

-- Dietmar

> 


