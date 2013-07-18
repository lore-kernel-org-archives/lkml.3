Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab3GROY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:24:57 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53829 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3GROY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:24:56 -0400
Date: Thu, 18 Jul 2013 16:24:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 6/7] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130718142450.GB7398@somewhere>
References: <20130709012934.GA26058@linux.vnet.ibm.com>
 <1373333406-26979-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1373333406-26979-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130717233119.GA2801@somewhere>
 <20130718004141.GI4161@linux.vnet.ibm.com>
 <20130718013259.GA7398@somewhere>
 <20130718033921.GL4161@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718033921.GL4161@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 08:39:21PM -0700, Paul E. McKenney wrote:
> On Thu, Jul 18, 2013 at 03:33:01AM +0200, Frederic Weisbecker wrote:
> > So it's like:
> > 
> >     CPU 0                                              CPU 1
> > 
> >     read I                                             write I
> >     smp_mb()                                           smp_mb()
> >     cmpxchg S                                          read S
> > 
> > I still can't find what guarantees we don't read a value in CPU 1 that is way below
> > what we want.
> 
> One key point is that there is a second cycle from LONG to FULL.
> 
> (Not saying that there is not a bug -- there might well be.  In fact,
> I am starting to think that I need to do another Promela model...

Now I'm very confused :)

I'm far from being a specialist on these matters but I would really love to
understand this patchset. Is there any documentation somewhere I can read
that could help, something about cycles of committed memory or something?


> 
> > > Unfortunately, the reasoning in #2 above does not hold in the small-CPU
> > > case because there is the possibility of both the timekeeping CPU and
> > > the RCU grace-period kthread concurrently advancing the state machine.
> > > This would be bad, good catch!!!
> > 
> > It's not like I spotted anything myself but you're welcome :)
> 
> I will take them any way I can get them.  ;-)
> 
> > > The patch below (untested) is an attempt to fix this.  If it actually
> > > works, I will merge it in with 6/7.
> > > 
> > > Anything else I missed?  ;-)
> > 
> > Well I guess I'll wait one more night before trying to understand
> > the below ;)
> 
> The key point is that the added check means that either the timekeeping
> CPU is advancing the state machine (if there are few CPUs) or the
> RCU grace-period kthread is (if there are many CPUs), but never both.
> Or that is the intent, anyway!

Yeah got that.

Thanks!
