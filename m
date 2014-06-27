Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaF0On1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:43:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbaF0On0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:43:26 -0400
Date: Fri, 27 Jun 2014 16:43:23 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 4/5 v2] printk: Add per_cpu printk func to allow
 printk to be diverted
Message-ID: <20140627144323.GG23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220130.356038089@goodmis.org>
 <20140627142025.GD23205@pathway.suse.cz>
 <20140627103933.1e7b981b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140627103933.1e7b981b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-06-27 10:39:33, Steven Rostedt wrote:
> On Fri, 27 Jun 2014 16:20:25 +0200
> Petr Mládek <pmladek@suse.cz> wrote:
> 
> 
> > >  	va_start(args, fmt);
> > > -	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
> > > +	preempt_disable();
> > 
> > I think that it is too late to disable the preemption here.
> > It has to be done by the printk() caller if it wants to be sure
> > that the requested function is used.
> 
> That's only if the printk() caller cares. But it would be nice that we
> run the printk_func for the CPU that vprintk_func() is on, thus the
> preempt_disable() is required. (in -rt, this would turn into a
> migrate_disable()).

It makes sense. Thanks for explanation.

Best Regards,
Petr
 
> -- Steve
> 
> > 
> > > +	vprintk_func = this_cpu_read(printk_func);
> > > +	r = vprintk_func(fmt, args);
> > > +	preempt_enable();
> > >  	va_end(args);
> > >  
> > >  	return r;
> > 
> > Best Regards,
> > Petr
> 
