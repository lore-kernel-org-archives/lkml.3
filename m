Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaAOXlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:41:19 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57152 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaAOXlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:41:15 -0500
Date: Wed, 15 Jan 2014 15:41:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 3/4] timers: Reduce future __run_timers()
 latency for newly emptied list
Message-ID: <20140115234108.GL10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140115155405.5682a2de@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115155405.5682a2de@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011523-3532-0000-0000-000004C6A374
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 03:54:05PM -0500, Steven Rostedt wrote:
> On Tue, 14 Jan 2014 21:20:47 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> 
> > diff --git a/kernel/timer.c b/kernel/timer.c
> > index 295837e5e011..bdd1c00ec4ec 100644
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -700,6 +700,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
> >  			base->next_timer = base->timer_jiffies;
> >  	}
> >  	base->all_timers--;
> > +	(void)catchup_timer_jiffies(base);
> 
> Why the "(void)" ?

Just a way of saying "I really did intend to ignore the return value."

							Thanx, Paul

> -- Steve
> 
> >  	return 1;
> >  }
> >  
> 

