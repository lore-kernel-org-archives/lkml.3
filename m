Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaFBUxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:53:51 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:32832 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaFBUxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	<20140602162525.GH16155@laptop.programming.kicks-ass.net>
	<CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
	<alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
Date: Mon, 2 Jun 2014 13:53:48 -0700
X-Google-Sender-Auth: icH_iJYGyuz03rfEw46Hqv7Ylbc
Message-ID: <CA+55aFwCy4-x02U6A-KbkPEpe_4pagsZ__ipBhe5HZOQt2vNmw@mail.gmail.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 1:46 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> And what else do you want to do?
>
> Peter Zijlstra said "I've been using xchg() and cmpxchg() without such
> consideration for quite a while." - so it basically implies that the
> kernel is full of such races, mcs_spinlock is just the most visible one
> that crashes the kernel first.

.. so your whole argument is bogus, because it doesn't actually fix
anything else.

Now, something that *would* fix something else is (for example) to
just make "ACCESS_ONCE()" a rvalue so that you cannot use it for
assignments, and then trying to sort out what happens then. It's
possible that the "atomic_pointer_t" would be a part of the solution
to that "what happens then", but THERE IS NO WAY IN HELL we're adding
it for just one architecture and one use that doesn't warrant even
_existing_ on that architecture.

See what I'm saying?

You're not fixing the problem, you're fixing one unimportant detail
that isn't worth fixing that way.

               Linus
