Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab3LJXcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:32:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35155 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3LJXb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:31:59 -0500
Date: Tue, 10 Dec 2013 23:31:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210233153.GQ10323@ZenIV.linux.org.uk>
References: <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
 <alpine.DEB.2.02.1312102348120.28330@ionos.tec.linutronix.de>
 <CA+55aFymvumbFXw6azLH+-3y6RB7mT_cho-wJguMepezzG=YQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFymvumbFXw6azLH+-3y6RB7mT_cho-wJguMepezzG=YQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:05:46PM -0800, Linus Torvalds wrote:

> Nobody actually uses that argument any more (it goes back to the old
> i386 "let's manually verify that we have write permissions, because
> the CPU doesn't do it for us in the trap handling"), and it should
> probably be removed.

Ah...

> But you're right that it's at least misleading. I'd love to remove it
> entirely, because it's not even syntax-checked, and it's confusing.
> But that would be a humongous patch.
> 
> So these days, "access_ok()" literally just checks that the address is
> in the user address space range. And that would seem to always be
> appropriate for futexes, so why not just do it in the generic code?

So let's turn it into
#define access_ok(type, addr, size) address_ok(addr, size)

and then users can be converted at leisure.  Eventually we'll just remove
the unused macros...
