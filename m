Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab3GLNHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:07:01 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44074 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932997Ab3GLNHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:07:00 -0400
Date: Fri, 12 Jul 2013 14:06:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 8/9] sched: power: Add initial frequency scaling
 support to power scheduler
Message-ID: <20130712130601.GD28271@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <1373385338-12983-9-git-send-email-morten.rasmussen@arm.com>
 <51DD5D63.7000602@linux.intel.com>
 <20130712125113.GF20960@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712125113.GF20960@e103034-lin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 01:51:13PM +0100, Morten Rasmussen wrote:
> On Wed, Jul 10, 2013 at 02:10:59PM +0100, Arjan van de Ven wrote:
> > On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> > > Extends the power scheduler capacity management algorithm to handle
> > > frequency scaling and provide basic frequency/P-state selection hints
> > > to the power driver.
> > >
> > > Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> > > CC: Ingo Molnar <mingo@kernel.org>
> > > CC: Peter Zijlstra <peterz@infradead.org>
> > > CC: Catalin Marinas <catalin.marinas@arm.com>
> > > ---
> > >   kernel/sched/power.c |   33 ++++++++++++++++++++++++++++-----
> > >   1 file changed, 28 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/kernel/sched/power.c b/kernel/sched/power.c
> > > index 9e44c0e..5fc32b0 100644
> > > --- a/kernel/sched/power.c
> > > +++ b/kernel/sched/power.c
> > > @@ -21,6 +21,8 @@
> > >
> > >   #define INTERVAL 5 /* ms */
> > >   #define CPU_FULL 90 /* Busy %-age - TODO: Make tunable */
> > > +#define CPU_TARGET 80 /* Target busy %-age - TODO: Make tunable */
> > > +#define CPU_EMPTY 5 /* Idle noise %-age - TODO: Make tunable */
> > >
> > 
> > to be honest, this is the policy part that really should be in the hardware specific driver
> > and not in the scheduler.
> > (even if said driver is sort of a "generic library" kind of thing)
> 
> I agree that the values should be set by a hardware specific power
> driver. Or do you mean that algorithms using this sort of values should
> be in the driver?

I think for flexibility we could place the default algorithm in a
library and it would be used by the cpufreq power driver wrapper or
directly by a new power driver. The intel_pstate.c driver could be
allowed to do smarter things.

-- 
Catalin
