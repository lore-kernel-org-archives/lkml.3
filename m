Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaJTJLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:11:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:52506 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaJTJLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:11:47 -0400
Date: Mon, 20 Oct 2014 11:11:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <dave@stgolabs.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
In-Reply-To: <1413684978.17869.18.camel@linux-t7sj.site>
Message-ID: <alpine.DEB.2.11.1410201106260.4121@nanos>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>  <1413617580.29249.9.camel@linux-t7sj.site>  <1413662314.17869.11.camel@linux-t7sj.site>  <CA+55aFzmsF4F-SOO4OzZDbreaQ4X4RUCQksv_ONu59BbyZ8Ocg@mail.gmail.com>
 <1413684978.17869.18.camel@linux-t7sj.site>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2014, Davidlohr Bueso wrote:
> On Sat, 2014-10-18 at 13:50 -0700, Linus Torvalds wrote:
> > On Sat, Oct 18, 2014 at 12:58 PM, Davidlohr Bueso <dave@stgolabs.net> wrote:
> > >
> > > And [get/put]_futex_keys() shouldn't even be called for private futexes.
> > > The following patch had some very minor testing on a 60 core box last
> > > night, but passes both Darren's and perf's tests. So I *think* this is
> > > right, but lack of sleep and I overall just don't trust them futexes!
> > 
> > Hmm. I don't see the advantage of making the code more complex in
> > order to avoid the functions that are no-ops for the !fshared case?
> > 
> > IOW, as far as I can tell, this patch doesn't actually really *change*
> > anything. Am I missing something?
> 
> Right, all we do is avoid a NOP, but I don't see how this patch makes
> the code more complex. In fact, the whole idea is to make it easier to
> read and makes the key referencing differences between shared and
> private futexes crystal clear, hoping to mitigate future bugs. 

I tend to disagree. The current code is symetric versus get/drop and
you make it unsymetric by avoiding the drop call with a pointless
extra conditional in all call sites.

I really had to look twice to figure out that the patch is correct,
but I really cannot see any value and definitely have a hard time how
this makes the code clearer and would prevent future bugs.

I rather keep it symetric and document the NOP property for private
futexes in both get and drop.

Thanks,

	tglx


