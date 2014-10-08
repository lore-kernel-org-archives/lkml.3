Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaJHR7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:59:50 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34269 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaJHR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:59:48 -0400
Message-ID: <1412791184.5173.11.camel@marge.simpson.net>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 08 Oct 2014 19:59:44 +0200
In-Reply-To: <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
References: <20141003194428.GA27084@sesse.net>
	 <1412782664.5179.75.camel@marge.simpson.net>
	 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 13:04 -0400, Linus Torvalds wrote: 
> On Wed, Oct 8, 2014 at 11:37 AM, Mike Galbraith
> <umgwanakikbuti@gmail.com> wrote:
> >
> > 11d4616bd07f38d496bd489ed8fad1dc4d928823 is the first bad commit
> > commit 11d4616bd07f38d496bd489ed8fad1dc4d928823
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Thu Mar 20 22:11:17 2014 -0700
> >
> >     futex: revert back to the explicit waiter counting code
> 
> While that revert might make things a tiny bit slower (I hated doing
> it, but the clever approach sadly didn't work on powerpc and depended
> on x86 locking semantics), I seriously doubt it's really relevant.
> It's more likely that the *real* problem itself is very
> timing-dependent, and the subtle synchronization changes here then
> expose it or hide it, rather than really fixing anything.
> 
> So like Thomas, I would suspect a race condition in the futex use, and
> then the exact futex implementation details are just exposing it
> incidentally.

Whew, good, futex.c is hard.  Heads up chess guys <punt>. 

-Mike

