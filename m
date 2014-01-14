Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaANRJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:09:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36485 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaANRJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:09:32 -0500
Date: Tue, 14 Jan 2014 18:09:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: Re: [PATCH RFC v2 0/4] perf: IRQ-bound performance events
Message-ID: <20140114170925.GA12115@localhost.localdomain>
References: <cover.1388858996.git.agordeev@redhat.com>
 <20140113155034.GA10355@localhost.localdomain>
 <20140114160751.GC6873@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114160751.GC6873@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 05:07:52PM +0100, Alexander Gordeev wrote:
> On Mon, Jan 13, 2014 at 04:50:37PM +0100, Frederic Weisbecker wrote:
> > On Sat, Jan 04, 2014 at 07:22:32PM +0100, Alexander Gordeev wrote:
> > > Hello,
> > > 
> > > This is version 2 of RFC "perf: IRQ-bound performance events". That is an
> > > introduction of IRQ-bound performance events - ones that only count in a
> > > context of a hardware interrupt handler. Ingo suggested to extend this
> > > functionality to softirq and threaded handlers as well:
> > 
> > Hi Alexander,
> > 
> > I still strongly think we should use toggle events to achieve that:
> > https://lkml.org/lkml/2013/9/25/227
> 
> Hi Frederic,
> 
> The toggle events would not allow counting per-action in hardware interrupt
> context. The design I propose provisions any possible combination of actions/
> IRQs.

I think we could define one event per handler by using tracepoint filters.

> 
> I.e. if we had few drivers on IRQn and few drivers on IRQm we could assign
> an event to let's say ISR0, ISR2 on IRQn and ISR1 on IRQm.

Yeah that should be possible with tracepoints as well.

> Moreover, given that hardware context handlers are running with local
> interrupts disabled and therefore an IRQ-bound event could be enabled/
> disabled only from a single handler at a time - we just need to allocate
> a single hardware counter for any possible combination.

Hmm I don't get what you mean here. Why tracepoint defined event don't work in this scenario?

> 
> I think it would be ideal if the two approaches could be converged somehow,
> but I just do not know how at the moment. I believe the next step is to
> measure the overhead Andi mentioned. That well might be a showstopper for
> either or both approaches.
> 
> By contrast with the hardware context, the toggle events seem to able
> monitoring softirq in its current form.
> 
> As of the threaded context handlers, I have not come up with the idea how to
> make it yet, but it does not seem the toggle events are able eigher.

A per task event should do the trick for threaded irqs profiling.

Thanks.
