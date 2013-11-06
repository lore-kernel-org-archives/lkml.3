Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3KFOIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:08:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56799 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3KFOIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:08:35 -0500
Date: Wed, 6 Nov 2013 15:08:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
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
        Lukasz Majewski <l.majewski@samsung.com>, james.hogan@imgtec.com,
        heiko.carstens@de.ibm.com
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
Message-ID: <20131106140807.GM10651@twins.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
 <20131105140626.GP31370@twins.programming.kicks-ass.net>
 <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
 <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <20131106145344.448d7733@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106145344.448d7733@mschwide>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 02:53:44PM +0100, Martin Schwidefsky wrote:
> On Tue, 5 Nov 2013 23:27:52 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, Nov 05, 2013 at 03:57:23PM +0100, Vincent Guittot wrote:
> > > Your proposal looks fine for me. It's clearly better to move in one
> > > place the configuration of sched_domain fields. Have you already got
> > > an idea about how to let architecture override the topology?
> > 
> > Maybe something like the below -- completely untested (my s390 compiler
> > is on a machine that's currently powered off).
> 
> In principle I do not see a reason why this should not work, but there
> are a few more things to take care of. E.g. struct sd_data is defined
> in kernel/sched/core.c, cpu_cpu_mask as well. These need to be moved
> to a header where arch/s390/kernel/smp.c can pick it up.
> 
> I do have the feeling that the sched_domain_topology should be left
> where they are, or do we really want to expose more of the scheduler
> internals?

Ah, its a trade off; in that previous patch I removed the entire
sched_domain initializers the archs used to 'have' to fill out. That
exposed far too much behavioural stuff the archs really shouldn't
bother with.

In return we now provide a (hopefully) simpler interface that allows
archs to communicate their topology to the scheduler -- without getting
mixed up in the behavioural aspects (too much).

Maybe s390 wasn't the best example to pick, as the book domain really
isn't that exciting. Arguably I should have taken Power7+ and the
ASYM_PACKING SMT thing.


