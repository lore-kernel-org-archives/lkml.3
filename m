Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaBTWww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:52:52 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:40910 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaBTWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:52:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140220221027.GC4250@linux.vnet.ibm.com>
References: <1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<20140220185608.GX4250@linux.vnet.ibm.com>
	<CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com>
	<20140220221027.GC4250@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:52:46 -0800
X-Google-Sender-Auth: _yA53OV7KXWTegAKZAmlxBHHglA
Message-ID: <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 2:10 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Linus, given that you are calling me out for pushing "legalistic and bad"
> things, "syntactic bullshit", and playing "little games", I am forced
> to conclude that you have never attended any sort of standards-committee
> meeting.  ;-)

Heh. I have heard people wax poetic about the pleasures of standards
committee meetings.

Enough that I haven't really ever had the slightest urge to participate ;)

> FWIW, the last time I tried excluding things like "f-f", "x%1", "y*0" and
> so on, I got a lot of pushback.  The reason I didn't argue too much back
> (2007 or some such) then was that my view at the time was that I figured
> the kernel code wouldn't do things like that anyway, so it didn't matter.

Well.. I'd really hope we would never do that. That said, we have
certainly used disgusting things that we knew would disable certain
optimizations in the compiler before, so I wouldn't put it *entirely*
past us to do things like that, but I'd argue that we'd do so in order
to confuse the compiler to do what we want, not in order to argue that
it's a good thing.

I mean, right now we have at least *one* active ugly work-around for a
compiler bug (the magic empty inline asm that works around the "asm
goto" bug in gcc). So it's not like I would claim that we don't do
disgusting things when we need to.

But I'm pretty sure that any compiler guy must *hate* that current odd
dependency-generation part, and if I was a gcc person, seeing that
bugzilla entry Torvald pointed at, I would personally want to
dismember somebody with a rusty spoon..

So I suspect there are a number of people who would be *more* than
happy with a change to those odd dependency rules.

                Linus
