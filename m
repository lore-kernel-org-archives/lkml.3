Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaLNEFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 23:05:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51576 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaLNEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 23:05:06 -0500
Date: Sat, 13 Dec 2014 20:04:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141214040459.GA8382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213180408.GH25340@linux.vnet.ibm.com>
 <20141213204152.GA15714@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213204152.GA15714@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121404-0013-0000-0000-0000070C86FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 03:41:52PM -0500, Dave Jones wrote:
> On Sat, Dec 13, 2014 at 10:04:08AM -0800, Paul E. McKenney wrote:
>  > On Sat, Dec 13, 2014 at 11:59:15AM -0500, Dave Jones wrote:
>  > > On Fri, Dec 12, 2014 at 11:14:06AM -0800, Linus Torvalds wrote:
>  > >  > On Fri, Dec 12, 2014 at 10:54 AM, Dave Jones <davej@redhat.com> wrote:
>  > >  > >
>  > >  > > Something that's still making me wonder if it's some kind of hardware
>  > >  > > problem is the non-deterministic nature of this bug.
>  > >  > 
>  > >  > I'd expect it to be a race condition, though. Which can easily cause
>  > >  > these kinds of issues, and the timing will be pretty random even if
>  > >  > the load is very regular.
>  > >  > 
>  > >  > And we know that the scheduler has an integer overflow under Sasha's
>  > >  > loads, although I didn't hear anything from Ingo and friends about it.
>  > >  > Ingo/Peter, you were cc'd on that report, where at least one of the
>  > >  > multiplcations in wake_affine() ended up overflowing..
>  > >  > 
>  > >  > Some scheduler thing that overflows only under heavy load, and screws
>  > >  > up scheduling could easily account for the RCU thread thing. I see it
>  > >  > *less* easily accounting for DaveJ's case, though, because the
>  > >  > watchdog is running at RT priority,  and the scheduler would have to
>  > >  > screw up much more to then not schedule an RT task, but..
>  > >  > 
>  > >  > I'm also not sure if the bug ever happens with preemption disabled.
>  > > 
>  > > Bah, so I see some watchdog traces with preemption off, and that then
>  > > taints the kernel, and the fuzzing stops.  I'll hack something up
>  > > so it ignores the taint and keeps going. All I really care about here
>  > > is the "machine hangs completely" case, which the trace below didn't
>  > > hit..
>  > > 
>  > > (back to fuzzing almost everything, not just lsetxattr btw)
>  > 
>  > Hmmm...  This one looks like the RCU grace-period kthread is getting
>  > starved: "idle=b4c/0/0".  Is this running with the "dangerous" patch
>  > that sets these kthreads to RT priority?
> 
> sorry, no. Ran out of time yesterday. I'll try and get to applying that
> later this evening if I get chance.

Whew!!!  You had me worried there for a bit!  ;-)

							Thanx, Paul

