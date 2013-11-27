Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3K0QNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:13:15 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:38257 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3K0QNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:13:13 -0500
Date: Wed, 27 Nov 2013 17:13:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127161308.GA26918@gmail.com>
References: <20131120163318.10253e43@gandalf.local.home>
 <5295F711.5010708@gmail.com>
 <20131127091647.4e16ce53@gandalf.local.home>
 <20131127142649.GC13532@twins.programming.kicks-ass.net>
 <20131127143435.GD25043@gmail.com>
 <20131127145837.GE16796@laptop.programming.kicks-ass.net>
 <20131127153519.GA26095@gmail.com>
 <20131127154015.GG789@laptop.programming.kicks-ass.net>
 <20131127154600.GC26095@gmail.com>
 <20131127105616.6672624c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127105616.6672624c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 27 Nov 2013 16:46:00 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Wed, Nov 27, 2013 at 04:35:19PM +0100, Ingo Molnar wrote:
> > > > So why does GCC then behave like this:
> > > 
> > > I think because its a much saner behaviour; also it might still be the
> > > spec actually says this, its a somewhat opaque text.
> > > 
> > > Anyway, yes GCC seems to behave as we 'expect' it to; I just can't find
> > > the language spec actually guaranteeing this.
> > 
> > So from C99 standard §6.7.8 (Initialization)/21:
> > 
> >     "If there are fewer initializers in a brace-enclosed list than 
> >   there are elements or members of an aggregate, or fewer characters 
> >   in a string literal used to initialize an array of known size than 
> >   there are elements in the array, the remainder of the aggregate 
> >   shall be initialized implicitly the same as objects that have static 
> >   storage duration."
> > 
> > static initialization == zeroing in this case.
> > 
> 
> The confusion here is that the above looks to be talking about arrays.
> But it really doesn't specify structures.

It talks about neither 'arrays' nor 'structures', it talks about 
'aggregates' - which is defined as _both_: 'structures and arrays'.

That's what compiler legalese brings you ;-)

> But searching the internet, it looks as though most people believe 
> it applies to structures, and any compiler that does otherwise will 
> most likely break applications.
> 
> That is, this looks to be one of the gray areas that the compiler 
> writers just happen to do what's most sane. And they probably assume 
> it's talking about structures as well, hence the lack of warnings.

I don't think it's grey, I think it's pretty well specified.

> It gets confusing, as the doc also shows:
> 
> struct { int a[3], b; } w[] = { { 1 }, 2 };

I don't think this is valid syntax, I think this needs one more set of 
braces:

 struct { int a[3], b; } w[] = { { { 1 }, 2 } };

> Then points out that w.a[0] is 1 and w.b[0] is 2, and all other 
> elements are zero.

If by 'w.a[0]' you mean 'w[0].a[0]', and if by 'w.b[0]' you mean 
'w[0].b' then yes, this comes from the definition and it's what I'd 
call 'obvious' initialization behavior.

What makes it confusing to you?

Thanks,

	Ingo
