Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaBTToT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:44:19 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:52352 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaBTToS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:44:18 -0500
Date: Thu, 20 Feb 2014 14:46:17 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <alpine.DEB.2.10.1402201414380.24360@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402201438480.24360@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu> <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu> <20140219101949.GG15586@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
 <20140220100830.GN6835@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu> <20140220182300.GN9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402201352010.24360@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402201414380.24360@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Vince Weaver wrote:

> On Thu, 20 Feb 2014, Vince Weaver wrote:
> 
> > Might be relevant: check the last_cpu values.  Right before the above
> > it looks like the thread gets moved from CPU 1 to CPU 0
> > (possibly as a result of the long chain started with the
> > close() of the tracepoint event),
> > so the problem NMI watchdog event being enabled is a different one than 
> > the one that was disabled just before.
> 
> so is this a false warning?  If you get scheduled to a new CPU
> and there's an already running CPU-wide event, is that OK?
> 
> Or should x86_pmu_disable() be setting PERF_HES_STOPPED on all events?
> It looks like other architectures are (such as armpmu_stop() ).

an actually I take that back, other architectures don't.

It's just confusing how
	perf_pmu_disable()
		calls
	pmu->pmu_disable()

	which on arm is:
		armpmu_disable()
	which calls:
		armpmu->stop()
	which is *not* the same as:
		armpmu_stop()
	but is actually armpmu->pmu->stop()

Urgh.

Vince
