Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaAPCXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:23:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46768 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaAPCW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:22:58 -0500
Date: Wed, 15 Jan 2014 18:22:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 2/4] timers: Reduce __run_timers()
 latency for empty list
Message-ID: <20140116022251.GP10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140115173858.GC14473@redhat.com>
 <20140115203245.GB11147@jtriplet-mobl1>
 <20140115154710.4281c978@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115154710.4281c978@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011602-6688-0000-0000-000005908DEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 03:47:10PM -0500, Steven Rostedt wrote:
> On Wed, 15 Jan 2014 12:32:45 -0800
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > On Wed, Jan 15, 2014 at 06:38:58PM +0100, Oleg Nesterov wrote:
> > > forgot to mention...
> > > 
> > > On 01/14, Paul E. McKenney wrote:
> > > >
> > > > +static bool catchup_timer_jiffies(struct tvec_base *base)
> > > > +{
> > > > +#ifdef CONFIG_NO_HZ_FULL
> > > > +	if (!base->all_timers) {
> > > > +		base->timer_jiffies = jiffies;
> > > > +		return 1;
> > > > +	}
> > > > +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > > > +	return 0;
> > > > +}
> > > 
> > > Do we really want ifdef?
> > > 
> > > This check is cheap, and !CONFIG_NO_HZ_FULL case looks a bit
> > > strange because we still update ->all_timers for no reason.
> > 
> > There's an easy way to improve this: instead of using an ifdef, put
> > "IS_ENABLED(CONFIG_NO_HZ_FULL) && " in the if condition.
> 
> Why even bother with that? What's wrong with doing this check all the
> time? Looks like it will save of the normal case too.

Sold!  I removed the ifdef.

							Thanx, Paul

