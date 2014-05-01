Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaEAQba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:31:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:34152 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaEAQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:31:29 -0400
Date: Thu, 1 May 2014 18:31:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu> <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Vince Weaver wrote:

> On Thu, 1 May 2014, Peter Zijlstra wrote:
> > 
> > But yes please!
> 
> OK, sorry for the delay, had forgotten to re-enable -pg for perf in the 
> makefile when I applied your patch so had to re-build the kernel.
> 
> The trace is here:
> 	www.eece.maine.edu/~vweaver/junk/pzbug.out.bz2
> 
> No analysis so hopefully it's good, I've got an event to go to in a few 
> minutes.
> 
> The messages:
> 
> [  634.846367] ------------[ cut here ]------------
> [  634.851477] WARNING: CPU: 6 PID: 2915 at kernel/events/core.c:3232 __free_event+0x93/0xa0()

So we are on the right track:

     perf_fuzzer-2915  [006]   634.846280: bprint:               _free_event: freeing with 0 refs; ptr=0x0xffff8800cef05000

> [  634.935276] CPU: 6 PID: 2915 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #94
> [  634.942754] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
> [  634.950728]  0000000000000009 ffff8801174b7b78 ffffffff81649bf0 0000000000000000
> [  634.958795]  ffff8801174b7bb0 ffffffff810646ad ffff8800cef05000 0000000000000000

----------------------------------------------------^^^^^^^^^^^^^^^^

> [  634.966855]  ffff8800cd47be10 ffff880036c7b388 ffff8800cef052a0 ffff8801174b7bc0

And the corrupted element:

> [  635.995839] Slab corruption (Tainted: G        W    ): kmalloc-2048 start=ffff8800cef05000, len=2048

The same address.

Heading out now and postponing the chase for tomorrow morning.

Thanks,

	tglx
