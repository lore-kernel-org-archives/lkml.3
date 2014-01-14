Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaANEyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:54:13 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:62833 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaANEyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:54:08 -0500
Date: Mon, 13 Jan 2014 23:55:17 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Will Deacon <will.deacon@arm.com>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
In-Reply-To: <20140110094056.GK31570@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1401132344570.20155@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu> <20140108225315.GG31570@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu> <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu> <20140110094056.GK31570@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Peter Zijlstra wrote:

> On Thu, Jan 09, 2014 at 11:08:47PM -0500, Vince Weaver wrote:
> > On Thu, 9 Jan 2014, Will Deacon wrote:
> > 
> > > I'd rather see it in the generic code if at all possible. Maybe we could add
> > > a flags field to perf_pmu_register?
> > 
> > I can look into adding the check in generic code.
> 
> Adding something like this to the generic code would mean adding a
> struct pmu capabilities field and visiting all existing PMU
> implementations to properly fill this out.

I don't see an existing pmu capabilities struct... or do you mean
coming up with one?

Would it only hold an "overflow_interrupt_available" flag, or are
there other generic capabilities it would be handy to know about?

> There's a number of hardware PMU implementations that do not have an
> interrupt and would need to set this flag.

Well that can be added gradually, right?  Things wouldn't get any worse if 
we add a generic check without auditing all code, things will just behave 
the same as before for those architectures.

There is some subtlety here though.  On ARM (or at least rasp-pi) the 
overflow hardware is there, just no interrupt is hooked up.  So things 
like counter overflow are handled as long as overflows aren't faster than 
context switch time.  It's just sampled events aren't possible.

On architectures without overflow support at all (I've had such hardware; 
some SPARC machines, the Playstation 3 hypervisor) then counter overflow 
isn't possible without a periodic timer (sort of like what is done with 
Intel uncore).  Is that something that should be in generic code too?

Vince
