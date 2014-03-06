Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaCFOCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:02:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55414 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaCFOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:02:53 -0500
Date: Thu, 6 Mar 2014 15:02:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Khalid Aziz <khalid.aziz@oracle.com>,
        tglx@linutronix.de, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140306140243.GN9987@twins.programming.kicks-ass.net>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
 <531641A8.40306@zytor.com>
 <87ob1jbgtg.fsf@rasmusvillemoes.dk>
 <20140306133450.GL9987@twins.programming.kicks-ass.net>
 <87k3c7bfvn.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3c7bfvn.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 02:45:00PM +0100, Rasmus Villemoes wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Thu, Mar 06, 2014 at 02:24:43PM +0100, Rasmus Villemoes wrote:
> >> Is it possible to implement non-sleeping versions of {get,put}_user()?
> >
> > __{get,put}_user()
> 
> Huh?
> 
> arch/x86/include/asm/uaccess.h:
> 
> /**
>  * __get_user: - Get a simple variable from user space, with less checking.
>  * @x:   Variable to store result.
>  * @ptr: Source address, in user space.
>  *
>  * Context: User context only.  This function may sleep.
> 
> What am I missing?

__get_user() -> __get_user_nocheck() -> __get_user_size() -> __get_user_asm()

And __get_user_asm() seems to generate the required .fixup section for
this to work in pagefault_disable() context.
