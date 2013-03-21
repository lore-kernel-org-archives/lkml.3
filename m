Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073Ab3CUQRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:17:38 -0400
Received: from a194-81.smtp-out.amazonses.com ([199.255.194.81]:46236 "EHLO
	a194-81.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933955Ab3CUQRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:17:36 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2013 12:17:36 EDT
Date: Thu, 21 Mar 2013 16:08:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
In-Reply-To: <20130320235545.GL3637@linux.vnet.ibm.com>
Message-ID: <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com> <1363636794.15703.32@driftwood> <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com> <20130318222548.GG3656@linux.vnet.ibm.com> <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Paul E. McKenney wrote:

> > > Another approach is to offload RCU callback processing to "rcuo" kthreads
> > > using the CONFIG_RCU_NOCB_CPU=y.  The specific CPUs to offload may be
> > > selected via several methods:

Why are there multiple rcuo threads? Would a single thread that may be
able to run on multiple cpus not be sufficient?

> > "Even though the SCHED_FIFO task is the only task running, because the
> > SCHED_OTHER tasks are queued on the CPU, it currently will not enter
> > adaptive tick mode."
>
> Again, good point!

Uggh. That will cause problems and did cause problems when I tried to use
nohz.

The OS always has some sched other tasks around that become runnable after
a while (like for example the vm statistics update, or the notorious slab
scanning). As long as SCHED_FIFO is active and there is no process in the
same scheduling class then tick needs to be off. Also wish that this would
work with SCHED_OTHER if there is only a single task with a certain renice
value (-10?) and the rest is runnable at lower priorities. Maybe in that
case stop the tick for a longer period and then give the lower priority
tasks a chance to run but then switch off the tick again.
