Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaJHRw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:52:26 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:36798 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaJHRwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:52:25 -0400
Message-ID: <1412790740.5173.4.camel@marge.simpson.net>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 08 Oct 2014 19:52:20 +0200
In-Reply-To: <20141008164557.GB38790@sesse.net>
References: <20141003194428.GA27084@sesse.net>
	 <1412782664.5179.75.camel@marge.simpson.net>
	 <alpine.DEB.2.11.1410081756250.4292@nanos>
	 <20141008164557.GB38790@sesse.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 18:45 +0200, Steinar H. Gunderson wrote: 
> On Wed, Oct 08, 2014 at 06:14:18PM +0200, Thomas Gleixner wrote:
> > It looks far more like an issue with the stocking fish code, but hell
> > with futexes one can never be sure.
> 
> OK, maybe we should move to a more recent Stockfish version first of all;
> the specific benchmark was about that specific binary, but for tracking down
> futex issues we can see if more recent code fixes it (the SMP in this thing
> keeps getting developed).

Mine was self build master, downloaded as a tarball.

> I'm moving to 2ac206e847a04a7de07690dd575c6949e5625115 (current head) of
> https://github.com/mcostalba/Stockfish.git, and building with
> “make -j ARCH=x86-64-bmi2”.
> 
> I still don't see any hangs, but I do see the same behavior of moving around
> between CPUs as the older version exhibited. In a test run (using the given
> test script, just with 28 replaced by 20), I get 18273 kN/sec with default,
> and 21875 kN/sec when using taskset.

Sure, that will likely be workqueues or whatnot running when one of the
chess threads wakes, so select_idle_sibling() shows one of its two
faces.. the butt ugly one.  That's what I wanted to play with on a too
darn big socket box when I discovered the thing didn't want to play.

-Mike

