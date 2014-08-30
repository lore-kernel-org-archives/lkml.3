Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaH3GYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:24:19 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48021 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaH3GYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <87oav7n7cr.fsf@matterhorn.verdurent.com>
References: <87mwb0fixy.fsf@matterhorn.verdurent.com>
	<CAMHCuPWeMwjJO+xzmQrZFmEMdx3+yF=zkove8brWX4rQiti50w@mail.gmail.com>
	<87oav7n7cr.fsf@matterhorn.verdurent.com>
Date: Sat, 30 Aug 2014 11:54:15 +0530
Message-ID: <CAMHCuPXaacqyngDRb-LnP7x5xC_A3davaKSRt0vfAk+80YOrgw@mail.gmail.com>
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
        len.brown@intel.com, mark.gross@intel.com, larry.bassel@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Tue, Aug 26, 2014 at 11:02 AM, Amit Kucheria
<amit.kucheria@linaro.org> wrote:

> Consider the following examples:
>
> *On a given platform*, we see the same benchmark scores with and
> without patchset ABC, but including patchset ABC leads to better "power
> behaviour" i.e. requests of deeper idle states and/or lower frequencies.
>
> Consider another example where the benchmark score dramatically improves
> with patchset XYZ while the idle and frequency requests are marginally
> worse (shallower idle, reduced residency or increased frequency requests).
>
> In both cases, it is left to platforms to do real measurements to confirm that
> this is indeed the case. The latter example might not even be possible
> on some platforms, given some platform constraints e.g. the platform
> thermal envelope.
>
> Idlestat is not a replacement for real measurements. It is a tool to
> allow maintainers (scheduler, PM) to judge if any further investigation
> is needed and request such numbers from people running the code on
> various architectures before merging the patches.

As I mentioned, it is very much possible for a workload to preserve the CPU
C/P states but damage some other system metric like memory/soc bandwidth,
cache characteristics because the scheduler was probably doing more aggressive
task placements. I agree that no tool (within room for
errors/approximations) can
replace a physical measurement; my only query/concern being is C/P correlation
the direct or primary metric for scheduler behavior (not PM behavior).

> First, idlestat is designed to be architecture-independent. It only
> depends on what the kernel knows.
> Second, it is created with benchmarking in mind - non-interactive and
> minimal overhead.
> Third, it was designed for maintainers to be able to quickly tell if a
> patchset changes OS behaviour dramatically and request deeper
> analysis on various architectures.
> Fourth, it has the prediction logic which calculates the intersection of
> C-state requests by several cpus in a cluster to determine the cluster
> state.
>
> On top of this, we have two WIP additions:
>  - an experimental "energy model" patch for idlestat that lets a SoC
>  vendor provide the cost of various states as input and idlestat will
>  output the "energy cost" of a workload.
>  - a 'diff mode' to show the diff between two traces

I see this as no different from powertop; would it not be easier to
add the prediction
logic and investigate energy models integration? I dont mind a
different tool to be
doing almost same things, but is there really a need for one?

> Correct. At the moment, idlestat can only provide an indication if
> something might be wrong.

And that's where I think I see an immense value for idlestat to stick to
scheduler details beyond the traditional C/P state statistics.

> These would show up as regressions in benchmark results. Fengguang's
> excellent benchmark report[1] already captures such "changes". Does it
> make sense to recapture that in a tool?
> [1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg703826.html

I am yet to digest that report, so apologies :)

> We're open to tracking more metrics if it is felt they are useful.
>
> One of the tenets of energy-aware scheduling is "improving energy
> efficiency with little or no performance regression". idlestat tells us
> about possible regressions on the energy front and benchmarks should
> tell us if we are regressing on performance. Hence the focus on
> C/P-states for now.

I would like to know your views on adding additional scheduler metrics
like task thrashing,
irregular placements, increased load balancing into the tool to be
able to zero in the
scheduler for efficiency losses. There might be more critical metrics
that I am missing...

Cheers!
-- 
---------
The views expressed in this email are personal and do not necessarily
echo my employers.
