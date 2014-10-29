Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaJ2Oep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:34:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44429 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834AbaJ2Oeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:34:44 -0400
Date: Wed, 29 Oct 2014 07:34:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle()
 function
Message-ID: <20141029143439.GN5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
 <20141029124728.GL5718@linux.vnet.ibm.com>
 <20141029134519.GC30198@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029134519.GC30198@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102914-0009-0000-0000-000005F03EC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 01:45:19PM +0000, Alexander Gordeev wrote:
> On Wed, Oct 29, 2014 at 05:47:29AM -0700, Paul E. McKenney wrote:
> > On Wed, Oct 29, 2014 at 12:07:07PM +0100, Alexander Gordeev wrote:
> > > Function rcu_is_cpu_rrupt_from_idle() is called from scheduling-
> > > clock interrupt handler to check if the current CPU was interrupted
> > > from idle. If true, it results in invocation of RCU callbacks. But
> > > the common hardware interrupt exit path also contains similar check
> > > and therefore the call to rcu_is_cpu_rrupt_from_idle() is redundant.
> > 
> > By common hardware interrupt exit path, you are meaning the calls
> > to rcu_irq_exit()?  If not, please let me know exactly what you
> > mean here.
> 
> Yes, I mean rcu_irq_exit().

Unless you can get the indication of whether or not the original interrupt
came from userspace execution into rcu_irq_exit(), this will not work.
It will result in grace-period hangs on some configurations.

Now, if you -can- get the userspace-execution indication into
rcu_irq_exit(), this might be of interest.  However, it might be faster
to simply let the scheduling-clock interrupt do the job as it currently
does, especially for workloads with lots of interrupts.

Or did you have something else in mind?

							Thanx, Paul

