Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaBRB0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:26:42 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41342 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBRB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:26:40 -0500
Date: Mon, 17 Feb 2014 17:26:36 -0800
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
Message-ID: <20140218012636.GB4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
 <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <1392672063.18779.6940.camel@triegel.csb>
 <1392675939.18779.7063.camel@triegel.csb>
 <CA+55aFx2jxE8sTZEmNnMg6ktDuU_0xPiEw3=qH0=+xat8p8cAA@mail.gmail.com>
 <1392680518.18779.7213.camel@triegel.csb>
 <CA+55aFzSBZMC6kbdJj5Jus9-q1dzXdCYQXfMm34O+9h8SbGcGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzSBZMC6kbdJj5Jus9-q1dzXdCYQXfMm34O+9h8SbGcGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021801-0928-0000-0000-000006C44319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:18:52PM -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 3:41 PM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > There's an underlying problem here that's independent from the actual
> > instance that you're worried about here: "no sense" is a ultimately a
> > matter of taste/objectives/priorities as long as the respective
> > specification is logically consistent.
> 
> Yes. But I don't think it's "independent".
> 
> Exactly *because* some people will read standards without applying
> "does the resulting code generation actually make sense for the
> programmer that wrote the code", the standard has to be pretty clear.
> 
> The standard often *isn't* pretty clear. It wasn't clear enough when
> it came to "volatile", and yet that was a *much* simpler concept than
> atomic accesses and memory ordering.
> 
> And most of the time it's not a big deal. But because the C standard
> generally tries to be very portable, and cover different machines,
> there tends to be a mindset that anything inherently unportable is
> "undefined" or "implementation defined", and then the compiler writer
> is basically given free reign to do anything they want (with
> "implementation defined" at least requiring that it is reliably the
> same thing).
> 
> And when it comes to memory ordering, *everything* is basically
> non-portable, because different CPU's very much have different rules.
> I worry that that means that the standard then takes the stance that
> "well, compiler re-ordering is no worse than CPU re-ordering, so we
> let the compiler do anything". And then we have to either add
> "volatile" to make sure the compiler doesn't do that, or use an overly
> strict memory model at the compiler level that makes it all pointless.

For whatever it is worth, this line of reasoning has been one reason why
I have been objecting strenuously every time someone on the committee
suggests eliminating "volatile" from the standard.

							Thanx, Paul

> So I really really hope that the standard doesn't give compiler
> writers free hands to do anything that they can prove is "equivalent"
> in the virtual C machine model. That's not how you get reliable
> results.
> 
>                Linus
> 

