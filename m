Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaBRUre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:47:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaBRUrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:47:33 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Peter.Sewell@cl.cam.ac.uk
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CAHWkzRQp3x4Wsnr6ZRdxfk04MuWT3bANnL8=VbCVEZ6+ifiqYA@mail.gmail.com>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
	 <CA+55aFw=9iKadR-r5sdZdJ_7yDzSV4=+P=gZXXsrxU61wKHf5w@mail.gmail.com>
	 <CAHWkzRQp3x4Wsnr6ZRdxfk04MuWT3bANnL8=VbCVEZ6+ifiqYA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 21:46:24 +0100
Message-ID: <1392756384.18779.8272.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 18:21 +0000, Peter Sewell wrote:
> On 18 February 2014 17:38, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, Feb 18, 2014 at 4:12 AM, Peter Sewell <Peter.Sewell@cl.cam.ac.uk> wrote:
> >>
> >> For example, suppose we have, in one compilation unit:
> >>
> >>     void f(int ra, int*rb) {
> >>       if (ra==42)
> >>         *rb=42;
> >>       else
> >>         *rb=42;
> >>     }
> >
> > So this is a great example, and in general I really like your page at:
> >
> >> For more context, this example is taken from a summary of the thin-air
> >> problem by Mark Batty and myself,
> >> <www.cl.cam.ac.uk/~pes20/cpp/notes42.html>, and the problem with
> >> dependencies via other compilation units was AFAIK first pointed out
> >> by Hans Boehm.
> >
> > and the reason I like your page is that it really talks about the
> > problem by pointing to the "unoptimized" code, and what hardware would
> > do.
> 
> Thanks.  It's certainly necessary to separately understand what compiler
> optimisation and the hardware might do, to get anywhere here.   But...
> 
> > As mentioned, I think that's actually the *correct* way to think about
> > the problem space, because it allows the programmer to take hardware
> > characteristics into account, without having to try to "describe" them
> > at a source level.
> 
> ...to be clear, I am ultimately after a decent source-level description of what
> programmers can depend on, and we (Mark and I) view that page as
> identifying constraints on what that description can say.  There are too
> many compiler optimisations for people to reason directly in terms of
> the set of all transformations that they do, so we need some more
> concise and comprehensible envelope identifying what is allowed,
> as an interface between compiler writers and users.  AIUI that's basically
> what Torvald is arguing.

Yes, that's one reason.  Another one is that if a programmer would
actually want to use atomics in a machine-independent / portable way,
he/she does also not want to reason about how all those transformations
might interact with the machine's memory model.

