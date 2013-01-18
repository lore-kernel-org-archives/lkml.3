Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3ARRol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:44:41 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40191 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3ARRok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:44:40 -0500
Date: Fri, 18 Jan 2013 09:35:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
Message-ID: <20130118173516.GL3159@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130102190920.GD29452@charite.de>
 <20130102205630.GA5594@home.goodmis.org>
 <20130102212948.GA25701@linux.vnet.ibm.com>
 <1357174163.10284.8.camel@gandalf.local.home>
 <1358050431.4514.57.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358050431.4514.57.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011817-4834-0000-0000-000002BC2A68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 04:13:51AM +0000, Ben Hutchings wrote:
> On Wed, 2013-01-02 at 19:49 -0500, Steven Rostedt wrote:
> > On Wed, 2013-01-02 at 13:29 -0800, Paul E. McKenney wrote:
> > > On Wed, Jan 02, 2013 at 03:56:30PM -0500, Steven Rostedt wrote:
> > > > On Wed, Jan 02, 2013 at 08:09:20PM +0100, Ralf Hildebrandt wrote:
> > > > > This happened of a virtual guest (Linux mail 3.2.0-35-virtual #55-Ubuntu SMP Wed Dec 5 18:02:05 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux)
> > > > 
> > > > 3.2 is rather old and this looks to be a stock Ubuntu kernel. May want
> > > > to file a Bugzilla (or whatever they call it) with them.
> > > > 
> > > > > 
> > > > > Jan  2 13:24:08 mail kernel: [3531872.484283] INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
> > > > 
> > > > 0 jiffies?
> > > 
> > > One possibility is that they are missing commit a10d206e (rcu: Fix
> > > day-one dyntick-idle stall-warning bug), at least assuming that
> > > CONFIG_PREEMPT=n.  This went into 3.6, IIRC.
> > 
> > If that does fix the issue, we probably should send that off to Ben for
> > inclusion into 3.2 stable.
> 
> If I read the Ubuntu changelog correctly, Ralf's machine is running a
> version based on 3.2.34, which already has this change (I applied it in
> 3.2.32).

OK, another possibility is c8020a67.  Ralf, if that does not help, is
it possible for you to run either a 3.7 or a -rcu kernel [*]?  There are
some other fixes that could be related, but the probability seems low.

							Thanx, Paul

[*]  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
	branch rcu/next

