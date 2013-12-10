Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3LJUJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:09:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47263 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3LJUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:09:43 -0500
Date: Tue, 10 Dec 2013 12:09:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131210200936.GE4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205132101.45c56f93@lwn.net>
 <20131205214406.GY15492@linux.vnet.ibm.com>
 <20131210152006.GD873@gmail.com>
 <20131210174400.GW4208@linux.vnet.ibm.com>
 <20131210182800.GA20770@gmail.com>
 <20131210190154.GB4208@linux.vnet.ibm.com>
 <20131210194628.GA21814@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210194628.GA21814@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121020-3532-0000-0000-000003BABAF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 08:46:28PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > So, what I don't see this statement cover (and I might be dense about 
> > > it!) is whether two ACCESS_ONCE() macros referring to different 
> > > variables are allowed to be reordered with each other.
> > > 
> > > If the compiler reorders:
> > > 
> > > 	ACCESS_ONCE(x);
> > > 	ACCESS_ONCE(y);
> > > 
> > > to:
> > > 
> > > 	ACCESS_ONCE(y);
> > > 	ACCESS_ONCE(x);
> > > 
> > > then AFAICS it still meets the "compiler need only forget the contents 
> > > of the indicated memory located" requirement that you listed, right?
> > 
> > True, but if the compiler was willing to reorder ACCESS_ONCE()'s 
> > volatile accesses, it would be really hard to write reliable device 
> > drivers. [...]
> 
> But nowhere do we link ACCESS_ONCE() to 'volatile' semantics in the 
> document, do we? (and I'm not sure we should.)

Agreed, stating ACCESS_ONCE()'s semantics separately is better.

> [ In theory a future compiler could offer a smarter, more flexible 
>   'compiler barrier' implementation - at which point we might be 
>   tempted to use that new facility to implement ACCESS_ONCE(). At that 
>   point this ambiguity might arise. ]

And they are trying to obsolete volatile, but haven't quite got there
yet.  ;-)

> > [...]  The standard says the following:
> > 
> > 	Access to volatile objects are evaluated strictly according to
> > 	the rules of the abstract machine.
> > 
> > That said, compiler writers and standards wonks will argue endlessly 
> > about exactly what that does and does not mean.  :-/
> > 
> > I added a sentence reading:
> > 
> > 	Of course, the compiler must also respect the order in which
> > 	the ACCESS_ONCE()s occur, though the CPU of course need not do so.
> > 
> > To the end of that paragraph.  Does that help?
> 
> Yeah, that looks perfect!

Very good!

							Thanx, Paul

