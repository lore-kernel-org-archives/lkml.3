Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaBZFWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:22:44 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45037 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaBZFWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:22:41 -0500
Date: Tue, 25 Feb 2014 21:22:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: George Spelvin <linux@horizon.com>
Cc: akpm@linux-foundation.org, dhowells@redhat.com, gcc@gcc.gnu.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, Ramana.Radhakrishnan@arm.com,
        torvalds@linux-foundation.org, triegel@redhat.com, will.deacon@arm.com
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140226052234.GC8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140226030653.17328.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226030653.17328.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022605-7164-0000-0000-0000066C43DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 10:06:53PM -0500, George Spelvin wrote:
> <paulmck@linux.vnet.ibm.com> wrote:
> > <torvalds@linux-foundation.org> wrote:
> >> I have for the last several years been 100% convinced that the Intel
> >> memory ordering is the right thing, and that people who like weak
> >> memory ordering are wrong and should try to avoid reproducing if at
> >> all possible.
> >
> > Are ARM and Power really the bad boys here?  Or are they instead playing
> > the role of the canary in the coal mine?
> 
> To paraphrase some older threads, I think Linus's argument is that
> weak memory ordering is like branch delay slots: a way to make a simple
> implementation simpler, but ends up being no help to a more aggressive
> implementation.
> 
> Branch delay slots give a one-cycle bonus to in-order cores, but
> once you go superscalar and add branch prediction, they stop helping,
> and once you go full out of order, they're just an annoyance.
> 
> Likewise, I can see the point that weak ordering can help make a simple
> cache interface simpler, but once you start doing speculative loads,
> you've already bought and paid for all the hardware you need to do
> stronger coherency.
> 
> Another thing that requires all the strong-coherency machinery is
> a high-performance implementation of the various memory barrier and
> synchronization operations.  Yes, a low-performance (drain the pipeline)
> implementation is tolerable if the instructions aren't used frequently,
> but once you're really trying, it doesn't save complexity.
> 
> Once you're there, strong coherency always doesn't actually cost you any
> time outside of critical synchronization code, and it both simplifies
> and speeds up the tricky synchronization software.
> 
> 
> So PPC and ARM's weak ordering are not the direction the future is going.
> Rather, weak ordering is something that's only useful in a limited
> technology window, which is rapidly passing.

That does indeed appear to be Intel's story.  Might well be correct.
Time will tell.

> If you can find someone in IBM who's worked on the Z series cache
> coherency (extremely strong ordering), they probably have some useful
> insights.  The big question is if strong ordering, once you've accepted
> the implementation complexity and area, actually costs anything in
> execution time.  If there's an unavoidable cost which weak ordering saves,
> that's significant.

There has been a lot of ink spilled on this argument.  ;-)

PPC has much larger CPU counts than does the mainframe.  On the other
hand, there are large x86 systems.  Some claim that there are differences
in latency due to the different approaches, and there could be a long
argument about whether all this in inherent in the memory ordering or
whether it is due to implementation issues.

I don't claim to know the answer.  I do know that ARM and PPC are
here now, and that I need to deal with them.

							Thanx, Paul

