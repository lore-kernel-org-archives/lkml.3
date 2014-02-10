Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaBJBqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:46:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaBJBqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:46:43 -0500
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
In-Reply-To: <CA+55aFy0SPge-z9TbaLF2yxLffVTviv_WhhbkXsB5mMA9d9iaQ@mail.gmail.com>
References: <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <20140206192743.GH4250@linux.vnet.ibm.com>
	 <1391721423.23421.3898.camel@triegel.csb>
	 <20140206221117.GJ4250@linux.vnet.ibm.com>
	 <1391730288.23421.4102.camel@triegel.csb>
	 <20140207042051.GL4250@linux.vnet.ibm.com>
	 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
	 <20140207165028.GO4250@linux.vnet.ibm.com>
	 <20140207165548.GR5976@mudshark.cambridge.arm.com>
	 <20140207180216.GP4250@linux.vnet.ibm.com>
	 <1391992071.18779.99.camel@triegel.csb>
	 <CA+55aFwFVr2KiXX2MObMBGypQk9eabe-93Nhmro=HL1RtC-1jw@mail.gmail.com>
	 <1391994986.18779.169.camel@triegel.csb>
	 <CA+55aFy0SPge-z9TbaLF2yxLffVTviv_WhhbkXsB5mMA9d9iaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Feb 2014 17:46:08 -0800
Message-ID: <1391996768.18779.212.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 17:24 -0800, Linus Torvalds wrote:
> On Sun, Feb 9, 2014 at 5:16 PM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > (a) seems to say that you don't like requiring programmers to mark
> > atomic accesses specially.  Is that the case?
> 
> In Paul's example, they were marked specially.
> 
> And you seemed to argue that Paul's example could possibly return
> anything but 0/0.

Just read my reply to Paul again.  Here's an excerpt:

> Initial state: x == y == 0
> 
> T1:   r1 = atomic_load_explicit(x, memory_order_relaxed);
>       atomic_store_explicit(42, y, memory_order_relaxed);
>       if (r1 != 42)
>               atomic_store_explicit(r1, y, memory_order_relaxed);
> 
> T2:   r2 = atomic_load_explicit(y, memory_order_relaxed);
>       atomic_store_explicit(r2, x, memory_order_relaxed);

Intuitively, this is wrong because this let's the program take a step
the abstract machine wouldn't do.  This is different to the sequential
code that Peter posted because it uses atomics, and thus one can't
easily assume that the difference is not observable.


IOW, I wrote that such a compiler transformation would be wrong in my
opinion.  Thus, it should *not* return 42.
If you still see how what I wrote could be misunderstood, please let me
know because I really don't see it.

Yes, I don't do so by swearing or calling other insane, and I try to see
the reasoning that those compilers' authors might have had, even if I
don't agree with it.  In my personal opinion, that's a good thing.

> If you really think that, I hope to God that you have nothing to do
> with the C standard or any actual compiler I ever use.
> 
> Because such a standard or compiler would be shit. It's sadly not too uncommon.

Thanks for the kind words.  Perhaps writing that was quicker than
reading what I actually wrote.


