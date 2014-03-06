Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaCFOde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:33:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:54097 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaCFOdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:33:33 -0500
Date: Thu, 6 Mar 2014 15:33:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "H. Peter Anvin" <hpa@zytor.com>, Khalid Aziz <khalid.aziz@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, akpm@linux-foundation.org,
        andi.kleen@intel.com, rob@landley.net, viro@zeniv.linux.org.uk,
        oleg@redhat.com, venki@google.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
In-Reply-To: <20140306140243.GN9987@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1403061530470.18573@ionos.tec.linutronix.de>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <87ob1jbgtg.fsf@rasmusvillemoes.dk> <20140306133450.GL9987@twins.programming.kicks-ass.net> <87k3c7bfvn.fsf@rasmusvillemoes.dk>
 <20140306140243.GN9987@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Mar 2014, Peter Zijlstra wrote:

> On Thu, Mar 06, 2014 at 02:45:00PM +0100, Rasmus Villemoes wrote:
> > Peter Zijlstra <peterz@infradead.org> writes:
> > 
> > > On Thu, Mar 06, 2014 at 02:24:43PM +0100, Rasmus Villemoes wrote:
> > >> Is it possible to implement non-sleeping versions of {get,put}_user()?
> > >
> > > __{get,put}_user()
> > 
> > Huh?
> > 
> > arch/x86/include/asm/uaccess.h:
> > 
> > /**
> >  * __get_user: - Get a simple variable from user space, with less checking.
> >  * @x:   Variable to store result.
> >  * @ptr: Source address, in user space.
> >  *
> >  * Context: User context only.  This function may sleep.
> > 
> > What am I missing?
> 
> __get_user() -> __get_user_nocheck() -> __get_user_size() -> __get_user_asm()
> 
> And __get_user_asm() seems to generate the required .fixup section for
> this to work in pagefault_disable() context.

Well, it still might sleep if you're using it in page fault enabled
context. So the documentation of that function sucks.

Thanks,

	tglx

