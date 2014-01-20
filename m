Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaATIas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:30:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50448 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaATIap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:30:45 -0500
Date: Mon, 20 Jan 2014 09:30:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140120083021.GC30183@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
 <CAJvTdKmdopjSopfHrZRKXJBKqjizrFHich+dQCd6Fq7C3bOogw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJvTdKmdopjSopfHrZRKXJBKqjizrFHich+dQCd6Fq7C3bOogw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 08:00:19PM -0500, Len Brown wrote:
> On Wed, Jan 15, 2014 at 10:58 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> >
> > arch/x86/kernel/process.c: In function 'mwait_idle':
> > /scratch/sfr/next/arch/x86/kernel/process.c:434:3: error: implicit declaration of function '__monitor' [-Werror=implicit-function-declaration]
> >    __monitor((void *)&current_thread_info()->flags, 0, 0);
> >    ^
> > arch/x86/kernel/process.c:437:4: error: implicit declaration of function '__sti_mwait' [-Werror=implicit-function-declaration]
> >     __sti_mwait(0, 0);
> >     ^
> >
> > Caused by commit 16824255394f ("x86, acpi, idle: Restructure the mwait
> > idle routines") interacting with commit 7760518cce95 ("x86 idle: restore
> > mwait_idle()") from the idle tree.
> >
> > I am not sure how to fix this so I just reverted the idle tree commit for
> > now (since it reverted cleanly). Please let me know if there is a better
> > solution.
> 
> IMO, a regression fix (restore mwait_idle()) is more important than a clean up
> (restructure mwait routines), and the clean-up should take a back seat;
> in -tip, in -next, upstream, and in -stable.

It was part of that other regression fix, the 50+ watt thingy for your
broken EX chips.

It was also written much earlier and widely mailed and published before
you did the core2 thing.

> Also, I'm wondering if that clean-up went too far -- as not all users of mwait
> are necessarily under the same conditions...

Then make them so. The fact was that most of the mwait idle sites
were bloody broken. And the single mwait_idle_with_hints() function
presents a single nice function that does all the required magics.


