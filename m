Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaBVSyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:54:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaBVSyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:54:19 -0500
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
In-Reply-To: <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
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
	 <1392922421.28840.36.camel@triegel.csb>
	 <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Feb 2014 19:53:43 +0100
Message-ID: <1393095223.28840.4914.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 11:09 -0800, Linus Torvalds wrote:
> On Thu, Feb 20, 2014 at 10:53 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > On Thu, 2014-02-20 at 10:32 -0800, Linus Torvalds wrote:
> >> On Thu, Feb 20, 2014 at 10:11 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> >
> >> > You really need that "consume" to be "acquire".
> >>
> >> So I think we now all agree that that is what the standard is saying.
> >
> > Huh?
> >
> > The standard says that there are two separate things (among many more):
> > mo_acquire and mo_consume.  They both influence happens-before in
> > different (and independent!) ways.
> >
> > What Paul is saying is that *you* should have used *acquire* in that
> > example.
> 
> I understand.
> 
> And I disagree. I think the standard is wrong, and what I *should* be
> doing is point out the fact very loudly, and just tell people to NEVER
> EVER use "consume" as long as it's not reliable and has insane
> semantics.

Stating that (1) "the standard is wrong" and (2) that you think that
mo_consume semantics are not good is two different things.  Making bold
statements without a proper context isn't helpful in making this
discussion constructive.  It's simply not efficient if I (or anybody
else reading this) has to wonder whether you actually mean what you said
(even if, when reading it literally, is arguably not consistent with the
arguments brought up in the discussion) or whether those statements just
have to be interpreted in some other way.

> So what I "should do" is to not accept any C11 atomics use in the
> kernel.

You're obviously free to do that.

> Because with the "acquire", it generates worse code than what
> we already have,

I would argue that this is still under debate.  At least I haven't seen
a definition of what you want that is complete and based on the standard
(e.g., an example of what a compiler might do in a specific case isn't a
definition).  From what I've seen, it's not inconceivable that what you
want is just an optimized acquire.

I'll bring this question up again elsewhere in the thread (where it
hopefully fits better).

