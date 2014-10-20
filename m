Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaJTKPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:15:42 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45848 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaJTKPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:15:41 -0400
Date: Mon, 20 Oct 2014 11:15:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Darren Hart <dvhart@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
Message-ID: <20141020101524.GC23751@e104818-lin.cambridge.arm.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
 <5442C045.2040909@linux.intel.com>
 <1413663590.17869.14.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413663590.17869.14.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 09:19:50PM +0100, Davidlohr Bueso wrote:
> On Sat, 2014-10-18 at 14:32 -0500, Darren Hart wrote:
> > Which is not incomplete (lacking the explicit smp_mb()) added by this
> > patch. Perhaps the MB implementation of get_futex_key_refs() need not be
> > explicitly enumerated here?
> 
> Agreed, how about this:
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 21f7e41..7a0805a 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -143,9 +143,8 @@
>   *
>   * Where (A) orders the waiters increment and the futex value read through
>   * atomic operations (see hb_waiters_inc) and where (B) orders the write
> - * to futex and the waiters read -- this is done by the barriers in
> - * get_futex_key_refs(), through either ihold or atomic_inc, depending on the
> - * futex type.
> + * to futex and the waiters read -- this is done by the barriers for both
> + * shared and private futexes in get_futex_key_refs().
>   *
>   * This yields the following case (where X:=waiters, Y:=futex):

Looks fine to me. Since Linus already picked the original patch, if you
plan to send an update for the comments please also mention the
"explicit MB (B) for private futexes" in get_futex_key_refs().

Thanks.

-- 
Catalin
