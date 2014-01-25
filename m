Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaAYAZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 19:25:40 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39556 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAYAZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 19:25:38 -0500
Date: Fri, 24 Jan 2014 16:19:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>,
        Joakim Hernberg <jbh@alchemy.lu>, Joe Korty <joe.korty@ccur.com>,
        Muli Baron <muli.baron@gmail.com>
Subject: Re: [PATCH RT v2] timer: Raise softirq if there's irq_work
Message-ID: <20140125001936.GB9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140124145157.1f30d447@gandalf.local.home>
 <20140124150933.22d8c20a@gandalf.local.home>
 <20140124202039.GA32662@linutronix.de>
 <20140124153542.6a92ef27@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124153542.6a92ef27@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012500-8236-0000-0000-00000666BA7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 03:35:42PM -0500, Steven Rostedt wrote:
> On Fri, 24 Jan 2014 21:20:39 +0100
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
> > * Steven Rostedt | 2014-01-24 15:09:33 [-0500]:
> > 
> > >[ Talking with Sebastian on IRC, it seems that doing the irq_work_run()
> > >  from the interrupt in -rt is a bad thing. Here we simply raise the
> > >  softirq if there's irq work to do. This too boots on my i7 ]
> > 
> > It is okay in general because most of the users should not run in bare
> > interrupt context. The only exception here is the nohz_full_kick_work
> > thing.
> 
> I know we discussed this on IRC, but I wanted to publicly state that
> the missing irq work callback was the RCU's rsp_wakeup() function.

Failing to invoke rsp_wakeup() when it was needed could potentially
stop RCU grace periods from happening, so having rsp_wakeup() happen
when it is needed is pretty important...

But I would guess that you knew that already.  ;-)

							Thanx, Paul

