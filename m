Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaG0RTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 13:19:44 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33409 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaG0RTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 13:19:43 -0400
Date: Sun, 27 Jul 2014 10:19:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up
 kthreads
Message-ID: <20140727171936.GQ11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com>
 <CAJhHMCDQe5tSs7576uy8fRBW0txXoyUa6RiQdpg48UJs5TPsog@mail.gmail.com>
 <20140725150248.GZ11241@linux.vnet.ibm.com>
 <CAJhHMCDEFgwNVcd_ZaZ_1Eohv_eH9tCnjedxeQg122ACNdX2cQ@mail.gmail.com>
 <20140725231535.GH11241@linux.vnet.ibm.com>
 <53D2E861.2060000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D2E861.2060000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072717-7164-0000-0000-0000036958C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 07:29:37PM -0400, Pranith Kumar wrote:
> 
> On 07/25/2014 07:15 PM, Paul E. McKenney wrote:
> > On Fri, Jul 25, 2014 at 06:23:41PM -0400, Pranith Kumar wrote:
> >> Here total is the total number of times we enter th function rcu_report_qs_rsp()
> >> and unnecessary is the times we call wake_up() unnecessarily.
> >> case1, 2, 3 are the cases I listed above.
> >>
> >> Note that the frequency has gone way up than before, I am not sure why that is.
> >>
> >> *ALL* the wakeups seem to be unnecessary from that location. And the
> >> main reason is that gp_flags is 0.
> >>
> >> My rcugp file has the following:
> >>
> >> completed=257515  gpnum=257516  age=1  max=1684
> >>
> >> Thoughts?
> > Hard to believe in the rcutorture case.  My guess was that rcutorture was
> > doing about 9000 wakeups, 2000 of which were unnecessary.  Which would
> > of course still tilt things very much in favor of your patch.
> >
> > I am not surprised in the mostly-idle case, as the RCU grace-period
> > kthread would most likely be the one ending the grace period, which
> > would therefore almost always be a self-wakeup.
> >
> > Any chance of a peek at your debugging code?
> 
> Sure, I am also attaching my dmesg output. Hope it helps!

Looks legit.  I guess that having even one CPU idle for the duration
of the grace period will cause a self wakeup, so perhaps I should not
have been surprised.

In any case, please summarize the data down to no more than 30 lines of
text and resend your wakeup-elimination patch with this text included
as the change log.

							Thanx, Paul

