Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaJPUYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:24:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaJPUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:24:20 -0400
Date: Thu, 16 Oct 2014 22:24:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the x86 specializations of atomic_[set|clear]_mask
Message-ID: <20141016202410.GL7369@worktop.fdxtended.com>
References: <1413405481-28818-1-git-send-email-patrick@parcs.ath.cx>
 <20141016080209.GE7369@worktop.fdxtended.com>
 <CA+C-WL-EKxA-oZ815vG9jau76BwQvAuL5WiuE-YvddgWPzt-Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+C-WL-EKxA-oZ815vG9jau76BwQvAuL5WiuE-YvddgWPzt-Ew@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 12:49:43PM -0400, Patrick Palka wrote:
> On Oct 16, 2014 4:02 AM, "Peter Zijlstra" <peterz@infradead.org> wrote:
> >
> > On Wed, Oct 15, 2014 at 04:38:01PM -0400, Patrick Palka wrote:
> > > This patch fixes a number of issues with these specializations:
> > >
> > >   1. The memory operand inside the asm specification is erroneously
> > >   declared read-only instead of read-write.
> > >
> > >   2. There is no reason to require the 1st operand of andl/orl to be
> > >   inside a register; the 1st operand could also be an immediate operand.
> > >   So change its specification from "r" to "ir".
> > >
> > >   3. Since addr is supposed to be an atomic_t *, the memory operand
> > >   should be addr->counter and not *addr.
> > >
> > >   4. These specializations should be inline functions instead of macros.
> > >
> > >   5. Finally, the "memory" clobbers are unnecessary, so they should be
> > >   removed.  (This is in line with the other atomic functions such as
> > >   atomic_add and atomic_sub, the likes of which do not have a "memory"
> > >   clobber.)
> >
> > No real problem with this, but I'm going to kill off these functions
> > when I get a little time :)
> 
> Hmm why's that?

because they're odd (inconsistent with the rest of the atomic
interfaces) and not implemented by all archs.

See: https://lkml.org/lkml/2014/2/6/196

3.18 will include up to 4/5 of that series and when I get a spare moment
I need cleanup/post the next arch sweep that will get us that 5/5 thing.


