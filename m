Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaFBVD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:03:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55244 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaFBVDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:03:55 -0400
Date: Mon, 2 Jun 2014 14:03:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140602210348.GF22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060221-0928-0000-0000-0000025BA7DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:09:35AM -0700, Linus Torvalds wrote:
> On Mon, Jun 2, 2014 at 9:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > And I can't say I'm a particular fan of these ops either, as alternative
> > I'm almost inclined to just exclude parisc from using opt spinning.
> 
> Please do.
> 
> There is no way in hell that we should introduce a magic new
> atomic_pointer thing for parisc. And the idea somebody had to change
> ACCESS_ONCE() for PA-RISC (I'm not going to go back to find who to
> blame) is just horribly wrong too, since it's not even necessary for
> any normal use: the special "load-and-store-zero" instruction isn't
> actually used for "real" data, it's used only for the special
> spinlocks afaik, so doing it for all ACCESS_ONCE() users would be
> wrong even on PA-RISC. For any normal data, the usual "just load the
> value, making sure the compiler doesn't reload it" is perfectly fine -
> even on PA-RISC.

Guilty to charges as read on suggesting PA-RISC-specific ACCESS_ONCE().  ;-)

							Thanx, Paul

> Now, if PA-RISC was a major architecture, we'd have to figure this
> out. But as it is, PA-RISC is just about the shittiest RISC ever
> invented (with original sparc being a strong contender), and let's
> face it, nobody really uses it.  It's a "fun project", but it is not
> something that we should use to mess up either ACCESS_ONCE() or the
> MCS locks.
> 
> Just make PA-RISC use its own locks, not any of the new fancy ones.
> 
>               Linus
> 

