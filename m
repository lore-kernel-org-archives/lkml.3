Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab3LESFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:05:55 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44940 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335Ab3LESFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:05:53 -0500
Date: Thu, 5 Dec 2013 10:05:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH tip/core/locking 4/4] Documentation/memory-barriers.txt:
 Document ACCESS_ONCE()
Message-ID: <20131205180547.GU15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204224628.GA30159@linux.vnet.ibm.com>
 <1386197219-31964-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386197219-31964-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131205095042.GB16749@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205095042.GB16749@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120518-8236-0000-0000-00000492EB05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 10:50:42AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > + (*) The compiler is within its rights to reload a variable, for example,
> > +     in cases where high register pressure prevents the compiler from
> > +     keeping all data of interest in registers.  The compiler might
> > +     therefore optimize the variable tmp out of our previous example:
> > +
> > +	while (tmp = a)
> > +		do_something_with(tmp);
> > +
> > +     This could result in the following code, which is perfectly safe in
> > +     single-threaded code, but can be fatal in concurrent code:
> > +
> > +	while (a)
> > +		do_something_with(a);
> > +
> > +     For example, the optimized version of this code could result in
> > +     passing a zero to do_something_with() in the case where the variable
> > +     a was modified by some other CPU between the "while" statement and
> > +     the call to do_something_with().
> 
> Nit: I guess references to variable names such as 'a' should be quoted 
> (same for 'tmp', 'b', etc):
> 
>         For example, the optimized version of this code could result in
>         passing a zero to do_something_with() in the case where the variable
>         'a' was modified by some other CPU between the "while" statement and
>         the call to do_something_with().
> 
> which makes reading it less ambiguous and more fluid IMO. This 
> observation applies to the whole document as 'a' is used in many 
> places.

Good point, fixed.

							Thanx, Paul

