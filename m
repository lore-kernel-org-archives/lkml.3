Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3FKRUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:20:12 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34579 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3FKRUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:20:11 -0400
Date: Tue, 11 Jun 2013 10:16:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <waiman.long@hp.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611171646.GM5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <51B748DA.2070306@hp.com>
 <20130611163607.GG5146@linux.vnet.ibm.com>
 <1370970115.9844.189.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370970115.9844.189.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061117-4834-0000-0000-000007F52CED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 01:01:55PM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 09:36 -0700, Paul E. McKenney wrote:
> 
> > > I am a bit concern about the size of the head queue table itself.
> > > RHEL6, for example, had defined CONFIG_NR_CPUS to be 4096 which mean
> > > a table size of 256. Maybe it is better to dynamically allocate the
> > > table at init time depending on the actual number of CPUs in the
> > > system.
> > 
> > But if your kernel is built for 4096 CPUs, the 32*256=8192 bytes of memory
> > is way down in the noise.  Systems that care about that small an amount
> > of memory probably have a small enough number of CPUs that they can just
> > turn off queueing at build time using CONFIG_TICKET_LOCK_QUEUED=n, right?
> 
> If this turns out to work for large machines, that means that distros
> will enable it, and distros tend to up the NR_CPUS, which is defined at
> compile time and is set regardless of if you are running with 2 CPUs or
> a 1000 CPUs.
> 
> For now it's fine to use NR_CPUS, but I always try to avoid it. Working
> in the ARM and POWER environment you are use to lots of kernels compiled
> specifically for the target. But in the x86 world, it is basically one
> kernel for all environments, where NR_CPUS does make a big difference.

Fair point.  Something to worry about should this ever be in danger of
actually going upstream.  ;-)

							Thanx, Paul

