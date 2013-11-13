Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab3KMInM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:43:12 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34455 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3KMInF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:43:05 -0500
Message-ID: <52833B95.7060700@gmail.com>
Date: Wed, 13 Nov 2013 09:43:01 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface.
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>	<1383831828-15501-3-git-send-email-juri.lelli@gmail.com> <20131112122345.510b4289@gandalf.local.home>
In-Reply-To: <20131112122345.510b4289@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 06:23 PM, Steven Rostedt wrote:
> On Thu,  7 Nov 2013 14:43:36 +0100
> Juri Lelli <juri.lelli@gmail.com> wrote:
> 
> 
>> + * This is reflected by the actual fields of the sched_param2 structure:
>> + *
>> + *  @sched_priority     task's priority (might still be useful)
>> + *  @sched_deadline     representative of the task's deadline
>> + *  @sched_runtime      representative of the task's runtime
>> + *  @sched_period       representative of the task's period
>> + *  @sched_flags        for customizing the scheduler behaviour
>> + *
>> + * Given this task model, there are a multiplicity of scheduling algorithms
>> + * and policies, that can be used to ensure all the tasks will make their
>> + * timing constraints.
>> + *
>> + * @__unused		padding to allow future expansion without ABI issues
>> + */
>> +struct sched_param2 {
>> +	int sched_priority;
>> +	unsigned int sched_flags;
> 
> I'm just thinking, if we are creating a new structure, and this
> structure already contains u64 elements, why not make sched_flags u64
> too? We are now just limiting the total number of possible flags to 32.
> I'm not sure how many flags will be needed in the future, maybe 32 is
> good enough, but just something to think about.
> 
> Of course you can argue that the int sched_flags matches the int
> sched_priority leaving out any holes in the structure, which is a
> legitimate argument.
> 
>> +	u64 sched_runtime;
>> +	u64 sched_deadline;
>> +	u64 sched_period;
>> +
>> +	u64 __unused[12];
> 
> And in the future, we could use one of these __unused[12] as a
> sched_flags2;
> 
> I'm not saying we should make it u64, just wanted to make sure we are
> fine with it as 32 for now.
> 

I'd stick with the current declaration for exactly the points you have made.

What others think?

Thanks,

- Juri
