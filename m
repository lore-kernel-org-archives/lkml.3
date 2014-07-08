Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaGHWWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:22:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52823 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaGHWWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:22:15 -0400
Date: Tue, 8 Jul 2014 15:22:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] rcu: uninline rcu_lock_acquire() and
 rcu_lock_release()
Message-ID: <20140708222211.GE4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140630161837.GA15873@redhat.com>
 <20140630161849.GA15887@redhat.com>
 <20140701114138.GQ6758@twins.programming.kicks-ass.net>
 <20140701164002.GA26950@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701164002.GA26950@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070822-1542-0000-0000-0000032151A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 06:40:02PM +0200, Oleg Nesterov wrote:
> On 07/01, Peter Zijlstra wrote:
> >
> > On Mon, Jun 30, 2014 at 06:18:49PM +0200, Oleg Nesterov wrote:
> > > +static inline void __rcu_lock_acquire(struct lockdep_map *map, unsigned long ip)
> > >  {
> > > +	lock_acquire(map, 0, 0, 2, 0, NULL, ip);
> > >  }
> >
> > > +extern void rcu_lock_acquire(void);
> > > +extern void rcu_lock_release(void);
> > > +extern void rcu_lock_acquire_bh(void);
> > > +extern void rcu_lock_release_bh(void);
> > > +extern void rcu_lock_acquire_sched(void);
> > > +extern void rcu_lock_release_sched(void);
> >
> > > diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> > > index a2783cb..5c06289 100644
> > > --- a/include/linux/srcu.h
> > > +++ b/include/linux/srcu.h
> > > @@ -219,7 +219,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
> > >  {
> > >  	int retval = __srcu_read_lock(sp);
> > >
> > > -	rcu_lock_acquire(&(sp)->dep_map);
> > > +	__rcu_lock_acquire(&(sp)->dep_map, _THIS_IP_);
> > >  	return retval;
> > >  }
> >
> > Would an srcu_lock_acquire() not make sense here?
> >
> > In any case, not wrong per se, just a consistency thing that stood out.
> 
> Yes, I looked at this too...
> 
> But probably it would be better to just add __rcu_lock_acquire() into
> __srcu_read_lock(), and kill that inline in srcu.h ?

Makes sense to me!

							Thanx, Paul

