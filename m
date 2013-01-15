Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3AOEGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:06:03 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35961 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3AOEGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:06:00 -0500
Date: Mon, 14 Jan 2013 20:05:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
Message-ID: <20130115040555.GI3384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130107221627.GZ2525@linux.vnet.ibm.com>
 <20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au>
 <1357600327.5190.13.camel@gandalf.local.home>
 <1357605379.5190.15.camel@gandalf.local.home>
 <20130108035348.GF2525@linux.vnet.ibm.com>
 <50F43612.8080600@infradead.org>
 <20130114173208.GY3384@linux.vnet.ibm.com>
 <50F45321.50808@infradead.org>
 <20130114194956.GB3384@linux.vnet.ibm.com>
 <1358219321.4068.9.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358219321.4068.9.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011504-4834-0000-0000-00000294C647
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:08:41PM -0500, Steven Rostedt wrote:
> On Mon, 2013-01-14 at 11:49 -0800, Paul E. McKenney wrote:
> 
> > diff --git a/kernel/rcu.h b/kernel/rcu.h
> > index 7f8e759..b5d30c3 100644
> > --- a/kernel/rcu.h
> > +++ b/kernel/rcu.h
> > @@ -24,6 +24,7 @@
> >  #define __LINUX_RCU_H
> >  
> >  #ifdef CONFIG_RCU_TRACE
> > +#include <linux/trace_clock.h>
> >  #define RCU_TRACE(stmt) stmt
> >  #else /* #ifdef CONFIG_RCU_TRACE */
> >  #define RCU_TRACE(stmt)
> > @@ -118,4 +119,13 @@ int rcu_jiffies_till_stall_check(void);
> >  
> >  #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
> >  
> > +static inline u64 notrace rcu_trace_clock_local(void)
> 
> "inline" now implies notrace. That is, we define inline to include
> notrace in the headers. The 'notrace' now is redundant.

Cool!!!  I have removed the "notrace", having just barely resisted the
urge to add two more instances of "notrace", just for good measure.  ;-)

							Thanx, Paul

> -- Steve
> 
> > +{
> > +#ifdef CONFIG_RCU_TRACE
> > +	return trace_clock_local();
> > +#else /* #ifdef CONFIG_RCU_TRACE */
> > +	return 0;
> > +#endif /* #else #ifdef CONFIG_RCU_TRACE */
> > +}
> > +
> >  #endif /* __LINUX_RCU_H */
> 
> 

