Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaFHHaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 03:30:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:1889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbaFHHaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 03:30:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,997,1392192000"; 
   d="scan'208";a="551990872"
Date: Sun, 8 Jun 2014 07:26:29 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140607232628.GC22261@intel.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606105036.GQ3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 12:50:36PM +0200, Peter Zijlstra wrote:
> > Voltage is combined with frequency, roughly, voltage is proportional
> > to freuquecy, so roughly, power is proportionaly to voltage^3. You
> 
> P ~ V^2, last time I checked.
> 
> > can't say which is more important, or there is no reason to raise
> > voltage without raising frequency.
> 
> Well, some chips have far fewer voltage steps than freq steps; or,
> differently put, they have multiple freq steps for a single voltage
> level.
> 
> And since the power (Watts) is proportional to Voltage squared, its the
> biggest term.
> 
> If you have a distinct voltage level for each freq, it all doesn't
> matter.
> 

Ok. I think we understand each other. But one more thing, I said P ~ V^3,
because P ~ V^2*f and f ~ V, so P ~ V^3. Maybe some frequencies share the same
voltage, but you can still safely assume V changes with f in general, and it
will be more and more so, since we do need finer control over power consumption.

> Sure, but realize that we must fully understand this governor and
> integrate it in the scheduler if we're to attain the goal of IPC/watt
> optimized scheduling behaviour.
> 

Attain the goal of IPC/watt optimized?

I don't see how it can be done like this. As I said, what is unknown for
prediction is perf scaling *and* changing workload. So the challenge for pstate
control is in both. But I see more chanllenge in the changing workload than
in the performance scaling or the resulting IPC impact (if workload is
fixed).

Currently, all freq governors take CPU utilization (load%) as the indicator
(target), which can server both: workload and perf scaling.

As for IPC/watt optimized, I don't see how it can be practical. Too micro to
be used for the general well-being?

> So you (or rather Intel in general) will have to be very explicit on how
> their stuff works and can no longer hide in some driver and do magic.
> The same is true for all other vendors for that matter.
> 
> If you (vendors, not Yuyang in specific) do not want to play (and be
> explicit and expose how your hardware functions) then you simply will
> not get power efficient scheduling full stop.
> 
> There's no rocks to hide under, no magic veils to hide behind. You tell
> _in_public_ or you get nothing.

Better communication is good, especially for our increasingly iterated
products because the changing products do incur noises and inconsistency
in detail.
