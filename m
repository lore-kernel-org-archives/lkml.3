Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaAFWFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:05:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaAFWFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:05:43 -0500
Date: Mon, 6 Jan 2014 23:05:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20140106220509.GI30183@twins.programming.kicks-ass.net>
References: <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218150900.GU21999@twins.programming.kicks-ass.net>
 <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iotw6bwx.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:25:02PM -0800, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Thu, Dec 19, 2013 at 04:30:53PM +0200, Alexander Shishkin wrote:
> >> So I'd like to steer away from the ways in which hardware can be broken
> >> and talk about a usable interface, to begin with.
> >
> > Just dump it into the regular one buffer like I outlined.
> 
> Just getting back to this. 
> 
> Do you realize that PT buffers have to be page aligned. 
> 
> So to mix it with a regular perf buffer would need padding every PT
> message by 4K, which wastes a lot of memory. The side band messages
> are usually only a few bytes (e.g. context switch).
> 
> If the sideband is mfrequent it could even take up >half of the buffer,
> but mostly only with padding.
> 
> Is that what you intended?
> 
> perf doesn't support gaps today, so your proposal wouldn't even
> seem to fit into the current perf design.

That would a really trivial addition.

> Also of course it requires disabling/enabling PT explicitly for 
> every perf message, which is slow. So you add at least 2*WRMSR cost
> (thousands of cycles).

That's just dumb, no flush the entire PT buffer into a few large
records.

> > That said; we very much need to have at least two architectures
> > implemented for any of this code to move.
> >
> > But we cannot ignore the hardware trainwreck; we cannot shape our
> > interface around something that's utterly broken.
> >
> > Some hardware is just too broken to support.
> 
> I don't think the PT design is broken in any way, it's straight 
> forward and simple.

If it were actually implemented like the spec says and not have this
crappy S/G limitation, then maybe.

> Trying to mix hardware tracing and software tracing in the same buffer
> on the other hand ...
> 
> Anyways if perf is not flexible enough to support this I suppose
> it could switch to a simple device driver, and only run perf with
> separate fds for side band purposes. 
> 
> Would you prefer that?

Don't be stupid.
