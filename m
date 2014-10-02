Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaJBImR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:42:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:55276 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaJBIlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:41:32 -0400
Date: Thu, 2 Oct 2014 10:41:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 00/11] perf: Intel Cache QoS Monitoring support
Message-ID: <20141002084125.GB3003@worktop.programming.kicks-ass.net>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
 <8738b7eac2.fsf@tassilo.jf.intel.com>
 <20141002065124.GF14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002065124.GF14343@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 07:51:24AM +0100, Matt Fleming wrote:
> On Wed, 01 Oct, at 02:42:05PM, Andi Kleen wrote:
> > Matt Fleming <matt@console-pimps.org> writes:
> > >
> > > Changes in v2:
> > >
> > >  - Added Jiri Olsa's Acked-by to PATCH 02/11.
> > >
> > >  - Use x86_match_cpu() in intel_cqm_init() and make sure we grab the
> > >    hotplug lock to prevent races as pointed out by Andi Kleen in
> > >    PATCH 08/11.
> > >
> > >  - Delete a stale comment in commit message of PATCH 10/11.
> > 
> > No support for a modular driver?
> 
> I didn't include support for that because none of the other x86 pmu
> drivers are buildable as modules. Is there a reason for that?

Not really, the rapl driver could easily be a module, and I think there
were osme patches to make the uncore driver a module.

> It's not clear to me that it would be a worthwhile change to make this
> buildable as a module, since that would require a Kconfig entry and the
> user would be required to make a decision regarding whether or not they
> want to build CQM support.
> 
> It's much simpler to just build it in and enable it based on
> CONFIG_PERF_EVENTS + CONFIG_INTEL_CPU. In fact, that's one of the things
> I've always liked about the pmu drivers, if I move to a new machine and
> turn on PERF_EVENTS the correct drivers will be run.

Some people worry about the memory footprint of all that.. That said, I
think we can do without the Kconfig stuff if we allow CONFIG_PERF_EVENTS
to be a tristate, in that case M would build everything that can be a
module as a module and keep the rest builtin.


