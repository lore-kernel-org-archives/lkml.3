Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3IYSLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:11:54 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50373 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3IYSLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:11:50 -0400
Date: Wed, 25 Sep 2013 20:11:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130925181146.GA16693@gmail.com>
References: <20130924154159.855373283@linux.com>
 <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com>
 <20130924171029.GB10261@gmail.com>
 <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 24 Sep 2013, Ingo Molnar wrote:
> 
> > Ok, this variant looks pretty good, modulo testing. I'd do:
> >
> >   s/check_preemption/check_preemption_disabled
> >
> > but that's a minor detail.
> 
> Sure.
> 
> > > +config DEBUG_THIS_CPU_OPERATIONS
> > > +	bool "Debug __this_cpu operations"
> > > +	depends on DEBUG_PREEMPT
> > > +	default n
> > > +	help
> > > +	  Enables preemption checks for __this_cpu macros. These
> > > +	  are macros to generate single instruction operations on
> > > +	  per cpu data. The option only affects the __this_cpu variant
> > > +	  which is used when fallback to multiple instructions without
> > > +	  other synchronization is possible. A verification is then
> > > +	  done to make sure that the thread cannot be preempted.
> >
> > I don't think there's a need to make this a separate preemption debug 
> > option: smp_processor_id() is really just a subset of the checks.
> 
> I think this is necessary since it seems that the discussions on how to 
> do the raw_cpu conversions may take some time. If we enable it by 
> default then there will be numerous new log messages. That way a 
> developer can enable it for working on this.

Note that for these patches to be eligible for upstream merge any extra 
warnings that trigger must be fixed, regardless of the default setting.

The blind __this_cpu conversions without proper preempt debugging cannot 
continue without first fixing all the fallout of the missing debug checks 
to begin with.

Thanks,

	Ingo
