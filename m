Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbbAINuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:50:06 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53663 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbAINuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:50:03 -0500
Date: Fri, 9 Jan 2015 05:49:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
Message-ID: <20150109134954.GO5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20150108094102.GD29390@twins.programming.kicks-ass.net>
 <20150108152230.GL5280@linux.vnet.ibm.com>
 <1420785714.25454.1.camel@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420785714.25454.1.camel@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010913-0013-0000-0000-000007C38AB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:41:54PM -0800, Davidlohr Bueso wrote:
> On Thu, 2015-01-08 at 07:22 -0800, Paul E. McKenney wrote:
> > > Didn't we just obsolete ACCESS_ONCE with that {READ,WRITE}_ONCE stuff?
> > 
> > Indeed we did!  But that was after I did this commit back on October 29th.
> > 
> > I am planning a bulk change to READ_ONCE() and ASSIGN_ONCE() either as
> > the last patch for 3.20 or as the first one for 3.21.  Probably as the
> > first for 3.21 to minimize rebasing hassles with any needed 3.20 fixes.
> 
> That reminds me, I think the new conversion for stores will most likely
> introduce silly arg bugs:
> 
> -       ACCESS_ONCE(a) = b;
> +       ASSIGN_ONCE(b, a);

I was planning to do mine by hand for this sort of reason.

Or are you thinking of something more subtle than the case where
"b" is an unparenthesized comma-separated expression?

							Thanx, Paul

