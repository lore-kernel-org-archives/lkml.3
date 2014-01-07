Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbaAGImi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:42:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51613 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaAGImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:42:37 -0500
Date: Tue, 7 Jan 2014 09:42:15 +0100
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
Message-ID: <20140107084215.GO30183@twins.programming.kicks-ass.net>
References: <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219103134.GD30183@twins.programming.kicks-ass.net>
 <87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219112812.GY21999@twins.programming.kicks-ass.net>
 <20131219123955.GA18186@gmail.com>
 <87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
 <20131219151024.GI16438@laptop.programming.kicks-ass.net>
 <87iotw6bwx.fsf@tassilo.jf.intel.com>
 <20140106220509.GI30183@twins.programming.kicks-ass.net>
 <20140107005231.GZ20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107005231.GZ20765@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:52:31AM +0100, Andi Kleen wrote:
> > > Also of course it requires disabling/enabling PT explicitly for 
> > > every perf message, which is slow. So you add at least 2*WRMSR cost
> > > (thousands of cycles).
> > 
> > That's just dumb, no flush the entire PT buffer into a few large
> > records.
> 
> How would that work?
> 
> You mean a separate buffer and then copy or map?
> 
> ------
> 
> Also here are some more problems with interleaving: 
> 
> A common PT config is to just run it as a ring buffer in the background
> and only take the data out when something happens (sample, crash etc.)
> 
> But the side band still needs to be logged and at arbitary times.
> 
> So the PT wrapping will happen much more often than the perf wrapping.

So create two events, one for the PT stuff and one to track the
side-band stuff. We have a NOP event for just this purpose.
