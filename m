Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBOCIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 21:08:24 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:60052 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaBOCIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 21:08:21 -0500
Date: Fri, 14 Feb 2014 18:08:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140215020815.GS4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392183564.18779.2187.camel@triegel.csb>
 <20140212180739.GB4250@linux.vnet.ibm.com>
 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
 <20140213002355.GI4250@linux.vnet.ibm.com>
 <1392321837.18779.3249.camel@triegel.csb>
 <20140214020144.GO4250@linux.vnet.ibm.com>
 <1392352981.18779.3800.camel@triegel.csb>
 <20140214172920.GQ4250@linux.vnet.ibm.com>
 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021502-7164-0000-0000-0000060CB433
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:02:23PM -0800, Linus Torvalds wrote:
> On Fri, Feb 14, 2014 at 11:50 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Why are we still discussing this idiocy? It's irrelevant. If the
> > standard really allows random store speculation, the standard doesn't
> > matter, and sane people shouldn't waste their time arguing about it.
> 
> Btw, the other part of this coin is that our manual types (using
> volatile and various architecture-specific stuff) and our manual
> barriers and inline asm accesses are generally *fine*.
> 
> The C11 stuff doesn't buy us anything. The argument that "new
> architectures might want to use it" is prue and utter bollocks, since
> unless the standard gets the thing *right*, nobody sane would ever use
> it for some new architecture, when the sane thing to do is to just
> fill in the normal barriers and inline asms.
> 
> So I'm very very serious: either the compiler and the standard gets
> things right, or we don't use it. There is no middle ground where "we
> might use it for one or two architectures and add random hints".
> That's just stupid.
> 
> The only "middle ground" is about which compiler version we end up
> trusting _if_ it turns out that the compiler and standard do get
> things right. From Torvald's explanations (once I don't mis-read them
> ;), my take-away so far has actually been that the standard *does* get
> things right, but I do know from over-long personal experience that
> compiler people sometimes want to be legalistic and twist the
> documentation to the breaking point, at which point we just go "we'd
> be crazy do use that".
> 
> See our use of "-fno-strict-aliasing", for example. The C standard
> aliasing rules are a mistake, stupid, and wrong, and gcc uses those
> stupid type-based alias rules even when statically *proving* the
> aliasing gives the opposite result. End result: we turn the shit off.
> 
> Exact same deal wrt atomics. We are *not* going to add crazy "this
> here is a control dependency" crap. There's a test, the compiler
> *sees* the control dependency for chrissake, and it still generates
> crap, we turn that broken "optimization" off. It really is that
> simple.

>From what I can see at the moment, the standard -generally- avoids
speculative stores, but there are a few corner cases where it might
allow them.  I will be working with the committee to see exactly what the
situation is.  Might be that I am confused and that everything really
is OK, might be that I am right but the corner cases are things that
no sane kernel developer would do anyway, it might be that the standard
needs a bit of repair, or it might be that the corner cases are somehow
inherent and problematic (but I hope not!).  I will let you know what
I find, but it will probably be a few months.

In the meantime, agreed, we keep doing what we have been doing.  And
maybe in the long term as well, for that matter.

One way of looking at the discussion between Torvald and myself would be
as a seller (Torvald) and a buyer (me) haggling over the fine print in
a proposed contract (the standard).  Whether that makes you feel better
or worse about the situation I cannot say.  ;-)

							Thanx, Paul

