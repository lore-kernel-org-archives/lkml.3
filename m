Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaHWCOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 22:14:50 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54405 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHWCOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 22:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <87mwb0fixy.fsf@matterhorn.verdurent.com>
References: <87mwb0fixy.fsf@matterhorn.verdurent.com>
Date: Fri, 22 Aug 2014 19:14:46 -0700
Message-ID: <CAMHCuPWeMwjJO+xzmQrZFmEMdx3+yF=zkove8brWX4rQiti50w@mail.gmail.com>
Subject: Re: [ANNOUNCE] (Resend) Tools to analyse PM and scheduling behaviour
From: Sundar <sunder.svit@gmail.com>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul McKenney <Paul.McKenney@us.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Juri Lelli <juri.lelli@arm.com>, sched-tools@linaro.org,
        len.brown@intel.com, mark.gross@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Tue, Aug 19, 2014 at 11:11 AM, Amit Kucheria
<amit.kucheria@linaro.org> wrote:
>
> We’re soliciting early feedback from community on the direction of idlestat

Nice :)

> Idlestat Details
> ----------------
> Idlestat uses FTRACE to capture traces related to C-state and P-state
> transitions of the CPU and wakeups (IRQ, IPI) on the system and then
> post-processes the data to print statistics. It is designed to be used
> non-interactively. Idlestat can deduce the idle time for a cluster as an
> intersection between the idle times of all the cpus belonging to the same
> cluster. This data is useful to analyse and optimise scheduling behaviour.
> The tool will also list how many times the menu governor mis-predicts
> target residency in a C-state.

We discussed this in the energy aware scheduling workshop this week @
the Kernel Summit. A few notes:

1. We need to really understand the co-relation of this tool w.r.t
actual hardware states.
It is usually likely that the software "thinks" it is in a low power
state, but the actual
hardware might not be. What is the coverage for these kind of cases here.

2. I understand that C/P states are a direct metric of how well the
workload behaved w.r.t power;
but I am not sure that relates to a direct measure of how the
scheduler performed. The C/P states
could be maintained whilst giving away performance or power at the
expense of additional components
on the SoC and platform like DDR IOs, fabric states etc.

Quick Summary of what I discussed with Daniel @ the workshop about idlestat:

1. There might be usually platform specific tools to get residencies
for P/C states.
PowerTop & Turbostat are two that first come to mind. Any specific
item apart from prediction logic
that idlestat differs from these two?

2. To me debugging performance or power, C/P states provide the
direction that something is wrong.
But they still dont tell me "what" is wrong "if" the issue is somehow
in the kernel as opposed to a more
easily fixable software code (traceable at hardware/software level for
best optimizations). How do I
conclude that my scheduler is the culprit apart from the points where
it took a decision to select the
right idle states based on predicted sleep times? In my opinion, that
would boil down to if the scheduler
was invoking too much load balancing calls, moving my threads across
cores too much, data being
thrashed across caches, cores too much etc.

I think a tool for scheduler metrics must be based on more inner
details like the above, finally culminating
into C/P states. as opposed to C/P states being the metric to be relied.

Let me know your thoughts.

Cheers!

-- these are my personal thoughts and do not represent my employers'
