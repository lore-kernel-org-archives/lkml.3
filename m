Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbaGDBco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:32:44 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:31868 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbaGDBcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:32:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgdfAC8DtlN5LHZ8PGdsb2JhbABagw2sbQEBAQEBAQaaVAGBCxcEAQEBATg1hAMBAQU6HBYNEAgDGAklDwUlAwcaE4hByTkXGIVYiTIHhEMFmnWLTIwVKw
Date: Fri, 4 Jul 2014 11:32:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DNAME_INLINE_LEN versus CONFIG_GENERIC_LOCKBREAK
Message-ID: <20140704013222.GH9508@dastard>
References: <8761je94wk.fsf@rasmusvillemoes.dk>
 <87fviite1u.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fviite1u.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 12:53:01PM -0700, Andi Kleen wrote:
> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> 
> > In dcache.h, DNAME_INLINE_LEN is carefully chosen so that sizeof(struct
> > dentry) is a (specific) multiple of 64 bytes. Obviously this breaks when
> > certain debug options are chosen (DEBUG_LOCK_ALLOC and DEBUG_SPINLOCK),
> > but also, AFAICT, on architectures with CONFIG_GENERIC_LOCKBREAK.
> >
> > I'm not sure it matters, but if it does, I'd suggest putting a
> > BUILD_BUG_ON somewhere, protected by suitable #ifdefs, so that the code
> > documents the assumptions that went into the particular choice of
> > DNAME_INLINE_LEN (this would also help catch changes to some of the
> > structures embedded in struct dentry which would violate those
> > assumptions). 
> 
> The right fix would be to pad it correctly for these other variants
> too.

IF you've turned on debugging options, then you've already lost more
performance that careful packing of the dentry slab cache gains you.
There's no point in carefully tuning DNAME_INLINE_LEN for debug
options - it's just code that will break and annoy people as debug
implementations change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
