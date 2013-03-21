Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3CUS7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:59:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60476 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3CUS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:59:22 -0400
Date: Thu, 21 Mar 2013 11:59:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321185908.GG3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
 <20130321171518.GW3637@linux.vnet.ibm.com>
 <1363891462.6345.52.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363891462.6345.52.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032118-7606-0000-0000-000009BB759A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 02:44:22PM -0400, Steven Rostedt wrote:
> On Thu, 2013-03-21 at 10:15 -0700, Paul E. McKenney wrote:
> 
> > > The OS always has some sched other tasks around that become runnable after
> > > a while (like for example the vm statistics update, or the notorious slab
> > > scanning). As long as SCHED_FIFO is active and there is no process in the
> > > same scheduling class then tick needs to be off. Also wish that this would
> > > work with SCHED_OTHER if there is only a single task with a certain renice
> > > value (-10?) and the rest is runnable at lower priorities. Maybe in that
> > > case stop the tick for a longer period and then give the lower priority
> > > tasks a chance to run but then switch off the tick again.
> > 
> > These sound to me like good future enhancements.
> 
> Exactly. Please, this is a complex enough change to something that is
> critical to the entire system (similar to RCU itself). Lets take baby
> steps here and get it right each step of the way.
> 
> For now, no, if more than one process is scheduled on the CPU, we fall
> out of dynamic tick mode. In the future, we can add SCHED_FIFO task
> scheduled in to trigger it. But lets conquer that after we successfully
> conquer the current changes.

What Steve said!!!

							Thanx, Paul

