Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaAPCd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:33:57 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41562 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaAPCdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:33:35 -0500
Date: Wed, 15 Jan 2014 18:33:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 4/4] timers: Reduce future
	__run_timers() latency for first add to empty list
Message-ID: <20140116023328.GS10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140115172409.GD11499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115172409.GD11499@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011602-1542-0000-0000-00000545DB93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:24:09PM +0100, Oleg Nesterov wrote:
> On 01/14, Paul E. McKenney wrote:
> >
> > @@ -749,6 +749,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
> >
> >  	base = lock_timer_base(timer, &flags);
> >
> > +	(void)catchup_timer_jiffies(base);
> 
> Agreed, but perhaps it would be better to do this before
> all_timers++ in internal_add_timer() ?

Excellent point, changed.

> This is funny, but I already have the same change for ->next_timer,
> if we add this optimization perhaps that trivial patch makes sense
> too.

Yep, I queued your change in my series as well, thank you!

							Thanx, Paul

