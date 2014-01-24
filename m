Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaAXUft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:35:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60269 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751686AbaAXUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:35:45 -0500
Date: Fri, 24 Jan 2014 15:35:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>,
        Joakim Hernberg <jbh@alchemy.lu>, Joe Korty <joe.korty@ccur.com>,
        Muli Baron <muli.baron@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RT v2] timer: Raise softirq if there's irq_work
Message-ID: <20140124153542.6a92ef27@gandalf.local.home>
In-Reply-To: <20140124202039.GA32662@linutronix.de>
References: <20140124145157.1f30d447@gandalf.local.home>
	<20140124150933.22d8c20a@gandalf.local.home>
	<20140124202039.GA32662@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014 21:20:39 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> * Steven Rostedt | 2014-01-24 15:09:33 [-0500]:
> 
> >[ Talking with Sebastian on IRC, it seems that doing the irq_work_run()
> >  from the interrupt in -rt is a bad thing. Here we simply raise the
> >  softirq if there's irq work to do. This too boots on my i7 ]
> 
> It is okay in general because most of the users should not run in bare
> interrupt context. The only exception here is the nohz_full_kick_work
> thing.
> 

I know we discussed this on IRC, but I wanted to publicly state that
the missing irq work callback was the RCU's rsp_wakeup() function.

-- Steve
