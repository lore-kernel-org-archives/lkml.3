Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaDGOKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:10:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46472 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaDGOKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:10:20 -0400
Date: Mon, 7 Apr 2014 16:09:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
Subject: Re: [PATCH v8 01/10] qspinlock: A generic 4-byte queue spinlock
 implementation
Message-ID: <20140407140953.GK10526@twins.programming.kicks-ass.net>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
 <1396445259-27670-2-git-send-email-Waiman.Long@hp.com>
 <20140404130012.GE10526@twins.programming.kicks-ass.net>
 <20140404165727.GQ19478@phenom.dumpdata.com>
 <533EE700.4080408@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EE700.4080408@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 01:08:16PM -0400, Waiman Long wrote:
> Peter's patch is a rewrite of my patches 1-4, there is no PV or unfair lock
> support in there.

Yes, because your patches were unreadable and entirely non obvious.

And while I appreciate that its not entirely your fault; the subject is
hard, you didn't even try to make it better and explain things in a
normal gradual fashion.

So what I did was start with a 'simple' correct implementation (although
I could have started simpler still I suppose and added 3-4 more patches)
and then added each optimization on top and explained the what and why
for them.

The result is similar code, but the path is ever so much easier to
understand and review.

And no, it doesn't have PV support; I spend the whole week trying to
reverse engineer your patch 1; whereas if you'd presented it in the form
I posted I might have agreed in a day or so.

I still have to look at the PV bits; but seeing how you have shown no
interest in writing coherent and understandable patch sets I'm less
inclined to go stare at them for another few weeks and rewrite that code
too.

Also; theres a few subtle but important differences between the patch
sets. Your series only makes x86_64 use the qspinlocks; the very last we
want is i386 and x86_64 to use different spinlock implementations; we
want less differences between them, not more.

You stuff a whole lot of code into arch/x86 for no reason what so ever.

Prior to that; I also rewrote your benchmark thing; using jiffies for
timing is just vile. Not to mention you require a full kernel build and
reboot (which is just stupid slow on big machines) to test anything.
