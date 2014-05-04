Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaEDMNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 08:13:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:47666 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaEDMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 08:13:04 -0400
Date: Sun, 4 May 2014 14:13:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [RFC] rtmutex: Do not boost fair tasks each other
In-Reply-To: <20140504071758.GK17778@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1405041412490.6261@ionos.tec.linutronix.de>
References: <5362122B.8060305@yandex.ru> <alpine.DEB.2.02.1405032041460.6261@ionos.tec.linutronix.de> <20140504071758.GK17778@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2014, Peter Zijlstra wrote:
> On Sat, May 03, 2014 at 08:54:08PM +0200, Thomas Gleixner wrote:
> > On Thu, 1 May 2014, Kirill Tkhai wrote:
> > > Higher priority does not provide exclusive privilege
> > > of one fair task over the other. In this case priority
> > > boosting looks excess.
> > > 
> > > On RT patch with enabled PREEMPT_RT_FULL I see a lot of
> > > rt_mutex_setprio() actions like
> > > 
> > > 	120 -> 118
> > > 	118 -> 120
> > > 
> > > They harm RT tasks.
> > 
> > That's not the main problem. The point is that it is useless and
> > therefor harming performace and throughput as well.
> >  
> > > RT patch has lazy preemtion feature, so if idea is we care
> > > about excess preemption inside fair class, we should care
> > > about excess priority inheritance too.
> > > 
> > > In case of vanila kernel the problem is the same, but there
> > > are no so many rt mutexes. Do I skip anything?
> > 
> > Almost a decade ago we decided to do the boosting for everything
> > including SCHED_OTHER due to the very simple reason that exercising
> > that code path more is likely to trigger more bugs.
> >  
> > But yes in a production environment, it's pointless for SCHED_OTHER
> > tasks.
> > 
> > Though exercising that code path as much as we can is not a bad thing
> > either. So I'd like to see that made compile time conditional on one
> > of the lock testing CONFIG items.
> > 
> > And the patch should be made against mainline, where we have the same
> > issue (reduced to PI-futexes).
> 
> And of course, if we ever get to PEP, we very much want all the classes
> to participate :)

That's true. We deal with it when it arrives :)
 
