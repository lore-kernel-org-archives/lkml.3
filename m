Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbaJXQis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:38:48 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:45014 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbaJXQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:38:46 -0400
Message-ID: <1414168721.5308.3.camel@marge.simpson.net>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 24 Oct 2014 18:38:41 +0200
In-Reply-To: <alpine.DEB.2.11.1410241724370.5308@nanos>
References: <20141003194428.GA27084@sesse.net>
	 <1412782664.5179.75.camel@marge.simpson.net>
	 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
	 <1412791184.5173.11.camel@marge.simpson.net>
	 <alpine.DEB.2.11.1410241724370.5308@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 17:25 +0200, Thomas Gleixner wrote: 
> On Wed, 8 Oct 2014, Mike Galbraith wrote:
> > On Wed, 2014-10-08 at 13:04 -0400, Linus Torvalds wrote: 
> > > On Wed, Oct 8, 2014 at 11:37 AM, Mike Galbraith
> > > <umgwanakikbuti@gmail.com> wrote:
> > > >
> > > > 11d4616bd07f38d496bd489ed8fad1dc4d928823 is the first bad commit
> > > > commit 11d4616bd07f38d496bd489ed8fad1dc4d928823
> > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Date:   Thu Mar 20 22:11:17 2014 -0700
> > > >
> > > >     futex: revert back to the explicit waiter counting code
> > > 
> > > While that revert might make things a tiny bit slower (I hated doing
> > > it, but the clever approach sadly didn't work on powerpc and depended
> > > on x86 locking semantics), I seriously doubt it's really relevant.
> > > It's more likely that the *real* problem itself is very
> > > timing-dependent, and the subtle synchronization changes here then
> > > expose it or hide it, rather than really fixing anything.
> > > 
> > > So like Thomas, I would suspect a race condition in the futex use, and
> > > then the exact futex implementation details are just exposing it
> > > incidentally.
> > 
> > Whew, good, futex.c is hard.  Heads up chess guys <punt>. 
> 
> I wonder whether the barrier fix which got into 3.17 late fixes that
> issue as well.

Yes, it did.

-Mike


