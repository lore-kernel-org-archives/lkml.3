Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaBQUXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:23:34 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51571 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaBQUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:23:31 -0500
Date: Mon, 17 Feb 2014 12:23:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140217202324.GJ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140213002355.GI4250@linux.vnet.ibm.com>
 <1392321837.18779.3249.camel@triegel.csb>
 <20140214020144.GO4250@linux.vnet.ibm.com>
 <1392352981.18779.3800.camel@triegel.csb>
 <20140214172920.GQ4250@linux.vnet.ibm.com>
 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
 <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392666947.18779.6838.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021720-9332-0000-0000-00000322C7FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 08:55:47PM +0100, Torvald Riegel wrote:
> On Sat, 2014-02-15 at 10:49 -0800, Linus Torvalds wrote:
> > On Sat, Feb 15, 2014 at 9:45 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > >
> > > I think a major benefit of C11's memory model is that it gives a
> > > *precise* specification for how a compiler is allowed to optimize.
> > 
> > Clearly it does *not*. This whole discussion is proof of that. It's
> > not at all clear,
> 
> It might not be an easy-to-understand specification, but as far as I'm
> aware it is precise.  The Cambridge group's formalization certainly is
> precise.  From that, one can derive (together with the usual rules for
> as-if etc.) what a compiler is allowed to do (assuming that the standard
> is indeed precise).  My replies in this discussion have been based on
> reasoning about the standard, and not secret knowledge (with the
> exception of no-out-of-thin-air, which is required in the standard's
> prose but not yet formalized).
> 
> I agree that I'm using the formalization as a kind of placeholder for
> the standard's prose (which isn't all that easy to follow for me
> either), but I guess there's no way around an ISO standard using prose.
> 
> If you see a case in which the standard isn't precise, please bring it
> up or open a C++ CWG issue for it.

I suggest that I go through the Linux kernel's requirements for atomics
and memory barriers and see how they map to C11 atomics.  With that done,
we would have very specific examples to go over.  Without that done, the
discussion won't converge very well.

Seem reasonable?

							Thanx, Paul

> > and the standard apparently is at least debatably
> > allowing things that shouldn't be allowed.
> 
> Which example do you have in mind here?  Haven't we resolved all the
> debated examples, or did I miss any?
> 
> > It's also a whole lot more
> > complicated than "volatile", so the likelihood of a compiler writer
> > actually getting it right - even if the standard does - is lower.
> 
> It's not easy, that's for sure, but none of the high-performance
> alternatives are easy either.  There are testing tools out there based
> on the formalization of the model, and we've found bugs with them.
> 
> And the alternative of using something not specified by the standard is
> even worse, I think, because then you have to guess what a compiler
> might do, without having any constraints; IOW, one is resorting to "no
> sane compiler would do that", and that doesn't seem to very robust
> either.
> 
> 

