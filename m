Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936394Ab3DHVrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:47:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54679 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935090Ab3DHVrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:47:41 -0400
Date: Mon, 8 Apr 2013 22:47:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Hilman <khilman@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 08/34] arm: Use generic idle loop
Message-ID: <20130408214719.GN17995@n2100.arm.linux.org.uk>
References: <20130321214930.752934102@linutronix.de> <20130321215233.826238797@linutronix.de> <87zjxv9lga.fsf@linaro.org> <alpine.LFD.2.02.1303251230440.22263@ionos> <20130325114808.GQ4977@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1303251501520.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303251501520.22263@ionos>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 03:02:39PM +0100, Thomas Gleixner wrote:
> On Mon, 25 Mar 2013, Russell King - ARM Linux wrote:
> 
> > On Mon, Mar 25, 2013 at 12:31:20PM +0100, Thomas Gleixner wrote:
> > > On Fri, 22 Mar 2013, Kevin Hilman wrote:
> > > 
> > > > Hi Thomas,
> > > > 
> > > > Thomas Gleixner <tglx@linutronix.de> writes:
> > > > 
> > > > > Use the generic idle loop and replace enable/disable_hlt with the
> > > > > respective core functions.
> > > > >
> > > > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > > > Cc: Russell King <linux@arm.linux.org.uk>
> > > > 
> > > > I gave patches 1-5 + this a quick spin on ARM (specifially some OMAP3 and
> > > > OMAP4 platforms, with and without CPUidle enabled.)
> > > > 
> > > > The OMAP stuff needed a couple minor compile fixes (below), but
> > > > otherwise it passes the quick "seems to work" test.
> > > 
> > > Yeah, that's needed for the other arch/arm conversions as well.
> > 
> > So, the only patch I got was this one, which is useless to test on its
> > own...
> 
> I'm testing V2 now and will post an git URL with a testing branch
> later tonight.

So, how can I review these changes when all there is is a git URL, and
I *do* not want to pull them into my tree without first looking at the
patches, possibly reviewing them and *replying* with the patch inline?

I see you've now added this stuff to -tip.  I guess ARM doesn't matter
to you at all.  I guess having ARM people review the core changes doesn't
matter either.

Well, I guess if it's broken, we'll just have to fix it up after the
merge window.

One rule for x86, a different one for ARM.  Let x86 maintainers moan
about ARM people, but don't let ARM people moan about x86 maintainers.
Yes, sure, right, I get it.

So, explicitly, my concern is this replacement of enable_hlt()/disable_hlt()
with this cpu_idle_poll_ctrl(), and whether this interface is still
counted - so that it's possible to call disable_hlt() to _permanently_
disable any hlt-based idle loop.

If that's not possible with your revised interface, you have just broken
some ARM platforms.  I can only guess... because you never copied your
entire patch set to me nor to the ARM lists.
