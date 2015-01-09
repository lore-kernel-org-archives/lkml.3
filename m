Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbbAIOHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:07:47 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52266 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbbAIOHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:07:46 -0500
Date: Fri, 9 Jan 2015 06:07:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com,
        borntraeger@de.ibm.com
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
Message-ID: <20150109140734.GS5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20150108094102.GD29390@twins.programming.kicks-ass.net>
 <20150108152230.GL5280@linux.vnet.ibm.com>
 <1420785714.25454.1.camel@stgolabs.net>
 <20150109134954.GO5280@linux.vnet.ibm.com>
 <20150109135614.GI29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109135614.GI29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010914-0005-0000-0000-000007E4DEAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 02:56:14PM +0100, Peter Zijlstra wrote:
> On Fri, Jan 09, 2015 at 05:49:54AM -0800, Paul E. McKenney wrote:
> > > That reminds me, I think the new conversion for stores will most likely
> > > introduce silly arg bugs:
> > > 
> > > -       ACCESS_ONCE(a) = b;
> > > +       ASSIGN_ONCE(b, a);
> > 
> > I was planning to do mine by hand for this sort of reason.
> > 
> > Or are you thinking of something more subtle than the case where
> > "b" is an unparenthesized comma-separated expression?
> 
> I think he's revering to the wrong way around-ness of the thing.
> 
> Its a bit of a mixed bag on assignments, but for instance
> rcu_assign_pointer() takes them the right way around, as does
> atomic_set().
> 
> So yes, I think the ASSIGN_ONCE() thing got the arguments the wrong way
> around.

Ah, yes, I had forgotten about this point.

> We could maybe still change it, before its in too long ?

I would be in favor.  Any objections?  ;-)

							Thanx, Paul

