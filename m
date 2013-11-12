Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3KLRXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:23:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22506 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754593Ab3KLRXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:23:48 -0500
Date: Tue, 12 Nov 2013 12:23:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
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
Message-ID: <20131112122345.510b4289@gandalf.local.home>
In-Reply-To: <1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 14:43:36 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:


> + * This is reflected by the actual fields of the sched_param2 structure:
> + *
> + *  @sched_priority     task's priority (might still be useful)
> + *  @sched_deadline     representative of the task's deadline
> + *  @sched_runtime      representative of the task's runtime
> + *  @sched_period       representative of the task's period
> + *  @sched_flags        for customizing the scheduler behaviour
> + *
> + * Given this task model, there are a multiplicity of scheduling algorithms
> + * and policies, that can be used to ensure all the tasks will make their
> + * timing constraints.
> + *
> + * @__unused		padding to allow future expansion without ABI issues
> + */
> +struct sched_param2 {
> +	int sched_priority;
> +	unsigned int sched_flags;

I'm just thinking, if we are creating a new structure, and this
structure already contains u64 elements, why not make sched_flags u64
too? We are now just limiting the total number of possible flags to 32.
I'm not sure how many flags will be needed in the future, maybe 32 is
good enough, but just something to think about.

Of course you can argue that the int sched_flags matches the int
sched_priority leaving out any holes in the structure, which is a
legitimate argument.

> +	u64 sched_runtime;
> +	u64 sched_deadline;
> +	u64 sched_period;
> +
> +	u64 __unused[12];

And in the future, we could use one of these __unused[12] as a
sched_flags2;

I'm not saying we should make it u64, just wanted to make sure we are
fine with it as 32 for now.

-- Steve



> +};
> +
