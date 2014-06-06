Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaFFFko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:40:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:53495 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaFFFkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:40:43 -0400
Date: Fri, 6 Jun 2014 07:40:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 1/2] rtmutex: Handle deadlock detection smarter
In-Reply-To: <20140605225914.13b8b714@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406060740210.23174@nanos>
References: <20140605152544.641846795@linutronix.de> <20140605152801.836501969@linutronix.de> <20140605225914.13b8b714@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Steven Rostedt wrote:

> On Thu, 05 Jun 2014 15:28:32 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Index: tip/kernel/locking/rtmutex.h
> > ===================================================================
> > --- tip.orig/kernel/locking/rtmutex.h
> > +++ tip/kernel/locking/rtmutex.h
> > @@ -21,6 +21,10 @@
> >  #define debug_rt_mutex_unlock(l)			do { } while (0)
> >  #define debug_rt_mutex_init(m, n)			do { } while (0)
> >  #define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
> > -#define debug_rt_mutex_print_deadlock(w)		do { } while (0)
> >  #define debug_rt_mutex_detect_deadlock(w,d)		(d)
> >  #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
> > +
> > +static inline void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
> > +{
> > +	WARN(1, "rtmutex deadlock detected\n");
> > +}
> > 
> 
> The above is called directly in rt_mutex_start_proxy_lock(), and as it
> doesn't have a conditional where the DEBUG_RT_MUTEXES version does, I
> get a ton of these:

Crap, yes. Of course I had debug enabled :)

