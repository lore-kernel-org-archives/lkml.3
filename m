Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaEANMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:12:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:40495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEANMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:12:51 -0400
Date: Thu, 1 May 2014 15:12:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140501131245.GQ11096@twins.programming.kicks-ass.net>
References: <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
 <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404301701260.15279@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1404302310530.6261@ionos.tec.linutronix.de>
 <20140501102602.GP11096@twins.programming.kicks-ass.net>
 <20140501115042.GC13658@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1405011433180.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405011433180.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 02:35:02PM +0200, Thomas Gleixner wrote:
> > grep ptr=0xffff880118fda000 bug.out | less
> > 
> > We find lovely bits such as:
> > 
> >      perf_fuzzer-4387  [001]  1773.427175: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff880118fda000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> >      ksoftirqd/6-38    [006]  1773.457770: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff880118fda000
> >           <idle>-0     [007]  1774.020378: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff880118fda000
> >      perf_fuzzer-4387  [000]  1774.096354: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff880118fda000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> > 
> > 
> > That's almost half a second between the double free, Vince, is your TSC
> > solid?
> 
> grep DROPPED bug.out
> 
> Now align that with the double malloc/free sites and you have an explanation ...

Argh!
