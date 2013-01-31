Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3AaG6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:58:43 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60965 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3AaG6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:58:41 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-d6-510a161fb520
From: Namhyung Kim <namhyung@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
	<1359580757-4121-3-git-send-email-bigeasy@linutronix.de>
	<5109D313.1020409@linux.vnet.ibm.com>
	<8738xiue31.fsf@sejong.aot.lge.com>
	<510A1198.2070803@linux.vnet.ibm.com>
Date: Thu, 31 Jan 2013 15:58:38 +0900
In-Reply-To: <510A1198.2070803@linux.vnet.ibm.com> (Michael Wang's message of
	"Thu, 31 Jan 2013 14:39:20 +0800")
Message-ID: <87txpxu9cx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 14:39:20 +0800, Michael Wang wrote:
> On 01/31/2013 01:16 PM, Namhyung Kim wrote:
>> Anyway, I have an idea with this in mind.  It's like adding a new "idle
>> load" to each idle cpu rather than special casing the idle cpus like
>> above.  IOW an idle cpu will get very small load weight depends on how
>> deep it's slept so that it can be compared to other cpus in a same way
>> but we can find prefered (lowest load) cpu among the idle cpus.
>> 
>> The simple way I can think of is adding idle_level to a rq load in
>> weighted_cpuload():
>> 
>> static unsigned long weighted_cpuload(const int cpu)
>> {
>> 	return cpu_rq(cpu)->load.weight + cpuidle_get_state(cpu);
>> }
>
> Hmm... then we don't need changes in find_idlest_cpu(), just compare the
> load as before, but it works only when the appendix state value is
> smaller than the lowest load of one task, which is 15 currently, I'm not
> sure whether we have the promise...

You said about a nice 19 process, right?  But I found that SCHED_IDLE
task will have weight of 3. :(

  #define WEIGHT_IDLEPRIO                3


But AFAIK the number of states in cpuidle is usually less than 10 so maybe
we can change the weight then, but there's no promise...

Thanks,
Namhyung
