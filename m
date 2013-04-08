Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936473Ab3DHPgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:36:21 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:45729 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936341Ab3DHPgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:36:19 -0400
Date: Mon, 8 Apr 2013 17:36:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] locking: remove three unused Kconfig symbols
Message-ID: <20130408153614.GB17500@gmail.com>
References: <1365428154.1830.99.camel@x61.thuisdomein>
 <20130408151609.GA13640@gmail.com>
 <1365435015.1830.113.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365435015.1830.113.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Bolle <pebolle@tiscali.nl> wrote:

> On Mon, 2013-04-08 at 17:16 +0200, Ingo Molnar wrote:
> > * Paul Bolle <pebolle@tiscali.nl> wrote:
> > > The Kconfig symbols ARCH_INLINE_READ_UNLOCK_IRQ,
> > > ARCH_INLINE_SPIN_UNLOCK_IRQ, and ARCH_INLINE_WRITE_UNLOCK_IRQ were added
> > > in v2.6.33, but have never actually been used. It is safe to remove
> > > these.
> > > 
> > Erm, if you look at the code in question you'll see that they are unused I think 
> > due to a bug:
> > 
> >  config INLINE_READ_UNLOCK_IRQ
> >         def_bool y
> >         depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH
> > 
> > Shouldn't that depend on ARCH_INLINE_READ_UNLOCK_IRQ?
> > 
> > Similarly for the others.
> 
> Yes, that seems correct. I must admit that I didn't spot that
> possibility, but then again this Kconfig file is near unreadable (too
> much repetition for human readers).

Yeah, Kconfig isn't a very sophisticated language - it's the COBOL of config 
languages.

> Would you have any idea why this problem wasn't noticed in 16 (!) releases? 
> Fedora 17, which I did this patch on, has Kconfig symbolk PREEMPT not set. Is it 
> perhaps commit to not enable that option?

AFAICS it's a latent bug: it can only be noticed if these switches are set to 
different values by an arch - but the defaults and s390 (the two main cases) never 
do that.

So it's not causing any runtime problems today - but should be fixed nevertheless, 
now that you noticed it! :-)

Thanks,

	Ingo
