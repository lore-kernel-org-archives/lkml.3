Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaBTSyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:54:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaBTSyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:54:15 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
References: <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	 <1392740258.18779.7732.camel@triegel.csb>
	 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	 <1392752867.18779.8120.camel@triegel.csb>
	 <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	 <20140220040102.GM4250@linux.vnet.ibm.com>
	 <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	 <20140220083032.GN4250@linux.vnet.ibm.com>
	 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	 <20140220181116.GT4250@linux.vnet.ibm.com>
	 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Feb 2014 19:53:41 +0100
Message-ID: <1392922421.28840.36.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 10:32 -0800, Linus Torvalds wrote: 
> On Thu, Feb 20, 2014 at 10:11 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > You really need that "consume" to be "acquire".
> 
> So I think we now all agree that that is what the standard is saying.

Huh?

The standard says that there are two separate things (among many more):
mo_acquire and mo_consume.  They both influence happens-before in
different (and independent!) ways.

What Paul is saying is that *you* should have used *acquire* in that
example.

> And I'm saying that that is wrong, that the standard is badly written,
> and should be fixed.
> 
> Because before the standard is fixed, I claim that "consume" is
> unusable. We cannot trust it. End of story.

Then we still have all the rest.  Let's just ignore mo_consume for now,
and look at mo_acquire, I suggest.

> The fact that apparently gcc is currently buggy because it got the
> dependency calculations *wrong* just reinforces my point.

Well, I'm pretty sure nobody actually worked on trying to preserve the
dependencies at all.  IOW, I suspect this fell through the cracks.  We
can ask the person working on this if you really want to know.

> The gcc bug Torvald pointed at is exactly because the current C
> standard is illogical unreadable CRAP.

It's obviously logically consistent to the extent that it can be
represented by a formal specification such as the one by the Cambridge
group.  Makes sense, or not?

> I can guarantee that what
> happened is:
> 
>  - the compiler saw that the result of the read was used as the left
> hand expression of the ternary "? :" operator
> 
>  - as a result, the compiler decided that there's no dependency
> 
>  - the compiler didn't think about the dependency that comes from the
> result of the load *also* being used as the middle part of the ternary
> expression, because it had optimized it away, despite the standard not
> talking about that at all.
> 
>  - so the compiler never saw the dependency that the standard talks about
> 
> BECAUSE THE STANDARD LANGUAGE IS PURE AND UTTER SHIT.

Please, be specific.  Right now you're saying that all of it is useless.
Which is arguable not true.

> My suggested language never had any of these problems, because *my*
> suggested semantics are clear, logical, and don't have these kinds of
> idiotic pit-falls.

Have you looked at and understood the semantics of the memory model
(e.g. in the formalized form) with mo_consume and related being ignored
(ie, just ignore 6.13 and 6.14 in n3132)?


