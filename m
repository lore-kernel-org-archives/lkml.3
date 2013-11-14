Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3KNMIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:08:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52717 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3KNMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:08:10 -0500
Date: Thu, 14 Nov 2013 13:07:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
Message-ID: <20131114120742.GI16796@laptop.programming.kicks-ass.net>
References: <20131105140626.GP31370@twins.programming.kicks-ass.net>
 <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
 <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <20131106145344.448d7733@mschwide>
 <20131106140807.GM10651@twins.programming.kicks-ass.net>
 <528268C8.8010501@arm.com>
 <20131112180844.GF21461@twins.programming.kicks-ass.net>
 <52839F04.60702@arm.com>
 <20131113162919.GM26898@twins.programming.kicks-ass.net>
 <20131114104902.GB5762@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114104902.GB5762@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 10:49:02AM +0000, Morten Rasmussen wrote:
> We need a way to know which group of cpus the flag applies to. If we
> don't want to pass a pointer to the sched_domain and we want to replace
> the current named sched_domain levels with something more flexible, the
> only solution I can think of right now is to pass a cpumask to the arch
> code. Better suggestions?

That might work.

> If we let arch generate the topology it could set the flags as well. But
> that means that an arch would have to deal with generating the topology
> even if it just needs to flip a single flag in the default topology.
> 
> Another thing is if we want to put energy related information into the
> sched_domain hierarchy. If we want various energy costs (P and C state)
> to be represented here we would need to modify more than just flags.
> 
> One way to do that is to put the energy information into a sub-struct and
> have another arch_sd_energy() call that allows the arch to populate that
> struct with relevant information.

Right.. I didn't think that far ahead yet :-)

So one thing that could be done is something like:

struct sd_energy arch_sd_energy(const struct sched_domain * sd);

Where you have an entire sd available, but since its const you cannot
actually modify it and are restricted to the return value -- which we
can validate before applying.

And we can have one such a function per specific thing we want to allow
modifying.
