Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaAGIlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:41:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51566 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaAGIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:41:40 -0500
Date: Tue, 7 Jan 2014 09:41:13 +0100
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
Message-ID: <20140107084113.GN30183@twins.programming.kicks-ass.net>
References: <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
 <20140106221528.GK30183@twins.programming.kicks-ass.net>
 <8761pw6717.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761pw6717.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 03:10:28PM -0800, Andi Kleen wrote:
> > To me it seems very weird that PT is hooked to the same PMI as the
> > normal PMU, it really should have been a different interrupt.
> 
> It's in the same STATUS register, so it's cheap to check both.
> 
> It shouldn't add any new spurious problems (or at least nothing
> worse than what we already have)
> 
> I understand that it would be nice to separate other NMI users
> from all of PMI, but that would be an orthogonal problem.
> 
> Any other issues?

Aside from the fact that PT and the PMU are otherwise unrelated, so it
being in the global status register is weird too.

Also, the PT interrupt doesn't actually need to be an NMI; when the
proposed S/G implementation would actually work as stated there can be
plenty room left when we trigger the interrupt.

But again, see the other email I referenced; the PMU triggering a PMI
while we're in one PT triggered is my biggest concern; esp. since both
have different FREEZE semantics.

