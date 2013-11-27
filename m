Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3K0QBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:01:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54702 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3K0QBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:01:46 -0500
Date: Wed, 27 Nov 2013 17:01:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
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
Message-ID: <20131127160119.GI789@laptop.programming.kicks-ass.net>
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
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 10:56:16AM -0500, Steven Rostedt wrote:
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
> 
> But searching the internet, it looks as though most people believe it
> applies to structures, and any compiler that does otherwise will most
> likely break applications.
> 
> That is, this looks to be one of the gray areas that the compiler
> writers just happen to do what's most sane. And they probably assume
> it's talking about structures as well, hence the lack of warnings.

16 says initializers for aggregate or union types are brace-enclosed
lists. A struct is an aggregate type.


