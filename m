Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3K0Qd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:33:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756830Ab3K0QdZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:33:25 -0500
Date: Wed, 27 Nov 2013 11:33:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20131127113321.67f34ee6@gandalf.local.home>
In-Reply-To: <20131127161308.GA26918@gmail.com>
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
	<20131127161308.GA26918@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 17:13:08 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 27 Nov 2013 16:46:00 +0100
> > Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Wed, Nov 27, 2013 at 04:35:19PM +0100, Ingo Molnar wrote:
> > > > > So why does GCC then behave like this:
> > > > 
> > > > I think because its a much saner behaviour; also it might still be the
> > > > spec actually says this, its a somewhat opaque text.
> > > > 
> > > > Anyway, yes GCC seems to behave as we 'expect' it to; I just can't find
> > > > the language spec actually guaranteeing this.
> > > 
> > > So from C99 standard §6.7.8 (Initialization)/21:
> > > 
> > >     "If there are fewer initializers in a brace-enclosed list than 
> > >   there are elements or members of an aggregate, or fewer characters 
> > >   in a string literal used to initialize an array of known size than 
> > >   there are elements in the array, the remainder of the aggregate 
> > >   shall be initialized implicitly the same as objects that have static 
> > >   storage duration."
> > > 
> > > static initialization == zeroing in this case.
> > > 
> > 
> > The confusion here is that the above looks to be talking about arrays.
> > But it really doesn't specify structures.
> 
> It talks about neither 'arrays' nor 'structures', it talks about 
> 'aggregates' - which is defined as _both_: 'structures and arrays'.

Yeah, I misread it. I was reading the array section for awhile, and got
confused.


> 
> That's what compiler legalese brings you ;-)

Yep.

> 
> > But searching the internet, it looks as though most people believe 
> > it applies to structures, and any compiler that does otherwise will 
> > most likely break applications.
> > 
> > That is, this looks to be one of the gray areas that the compiler 
> > writers just happen to do what's most sane. And they probably assume 
> > it's talking about structures as well, hence the lack of warnings.
> 
> I don't think it's grey, I think it's pretty well specified.
> 
> > It gets confusing, as the doc also shows:
> > 
> > struct { int a[3], b; } w[] = { { 1 }, 2 };
> 
> I don't think this is valid syntax, I think this needs one more set of 
> braces:
> 
>  struct { int a[3], b; } w[] = { { { 1 }, 2 } };
> 
> > Then points out that w.a[0] is 1 and w.b[0] is 2, and all other 
> > elements are zero.
> 
> If by 'w.a[0]' you mean 'w[0].a[0]', and if by 'w.b[0]' you mean 
> 'w[0].b' then yes, this comes from the definition and it's what I'd 
> call 'obvious' initialization behavior.
> 
> What makes it confusing to you?

Well, because it's mixing arrays and structures, and I was on the
misconception that the paragraph was talking about just arrays.

Can I just have my turkey now?

-- Steve
