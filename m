Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab3LJTqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:46:34 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:32923 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3LJTqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:46:32 -0500
Date: Tue, 10 Dec 2013 20:46:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131210194628.GA21814@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205132101.45c56f93@lwn.net>
 <20131205214406.GY15492@linux.vnet.ibm.com>
 <20131210152006.GD873@gmail.com>
 <20131210174400.GW4208@linux.vnet.ibm.com>
 <20131210182800.GA20770@gmail.com>
 <20131210190154.GB4208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210190154.GB4208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > So, what I don't see this statement cover (and I might be dense about 
> > it!) is whether two ACCESS_ONCE() macros referring to different 
> > variables are allowed to be reordered with each other.
> > 
> > If the compiler reorders:
> > 
> > 	ACCESS_ONCE(x);
> > 	ACCESS_ONCE(y);
> > 
> > to:
> > 
> > 	ACCESS_ONCE(y);
> > 	ACCESS_ONCE(x);
> > 
> > then AFAICS it still meets the "compiler need only forget the contents 
> > of the indicated memory located" requirement that you listed, right?
> 
> True, but if the compiler was willing to reorder ACCESS_ONCE()'s 
> volatile accesses, it would be really hard to write reliable device 
> drivers. [...]

But nowhere do we link ACCESS_ONCE() to 'volatile' semantics in the 
document, do we? (and I'm not sure we should.)

[ In theory a future compiler could offer a smarter, more flexible 
  'compiler barrier' implementation - at which point we might be 
  tempted to use that new facility to implement ACCESS_ONCE(). At that 
  point this ambiguity might arise. ]


> [...]  The standard says the following:
> 
> 	Access to volatile objects are evaluated strictly according to
> 	the rules of the abstract machine.
> 
> That said, compiler writers and standards wonks will argue endlessly 
> about exactly what that does and does not mean.  :-/
> 
> I added a sentence reading:
> 
> 	Of course, the compiler must also respect the order in which
> 	the ACCESS_ONCE()s occur, though the CPU of course need not do so.
> 
> To the end of that paragraph.  Does that help?

Yeah, that looks perfect!

Thanks,

	Ingo
