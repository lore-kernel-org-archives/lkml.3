Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaAOUdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:33:04 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35944 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaAOUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:00 -0500
X-Originating-IP: 173.246.103.110
Date: Wed, 15 Jan 2014 12:32:45 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 2/4] timers: Reduce __run_timers()
 latency for empty list
Message-ID: <20140115203245.GB11147@jtriplet-mobl1>
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140115173858.GC14473@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115173858.GC14473@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:38:58PM +0100, Oleg Nesterov wrote:
> forgot to mention...
> 
> On 01/14, Paul E. McKenney wrote:
> >
> > +static bool catchup_timer_jiffies(struct tvec_base *base)
> > +{
> > +#ifdef CONFIG_NO_HZ_FULL
> > +	if (!base->all_timers) {
> > +		base->timer_jiffies = jiffies;
> > +		return 1;
> > +	}
> > +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > +	return 0;
> > +}
> 
> Do we really want ifdef?
> 
> This check is cheap, and !CONFIG_NO_HZ_FULL case looks a bit
> strange because we still update ->all_timers for no reason.

There's an easy way to improve this: instead of using an ifdef, put
"IS_ENABLED(CONFIG_NO_HZ_FULL) && " in the if condition.

- Josh Triplett
