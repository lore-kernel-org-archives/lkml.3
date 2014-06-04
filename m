Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaFDNRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:17:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:36523 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaFDNRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:17:39 -0400
Date: Wed, 4 Jun 2014 15:17:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 2/5] rtmutex: Cleanup deadlock detector debug logic
In-Reply-To: <20140531160043.1d4bfb07@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406041515470.3319@nanos>
References: <20140531155229.493650009@linutronix.de> <20140531155739.265673091@linutronix.de> <20140531160043.1d4bfb07@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014, Steven Rostedt wrote:
> On Sat, 31 May 2014 15:57:49 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > Index: tip/kernel/locking/rtmutex.c
> > ===================================================================
> > --- tip.orig/kernel/locking/rtmutex.c
> > +++ tip/kernel/locking/rtmutex.c
> > @@ -256,6 +256,25 @@ static void rt_mutex_adjust_prio(struct
> >  }
> >  
> >  /*
> > + * Deadlock detection is conditional:
> > + *
> > + * If CONFIG_DEBUG_RT_MUTEXES=n, deadlock detection is only conducted
> > + * if the detect argument is == RT_MUTEX_FULL_CHAINWALK.
> > + *
> > + * If CONFIG_DEBUG_RT_MUTEXES=y, deadlock detection is always
> > + * conducted independent of the detect argument.
> > + *
> > + * If the waiter argument is NULL this indicates the deboost path and
> > + * deadlock detection is disabled independent of the detect argument
> > + * and the config settings.
> > + */
> > +static int rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
> > +					 enum rtmutex_chainwalk detect)
> > +{
> > +	return debug_rt_mutex_detect_deadlock(waiter, detect);
> > +}
> > +
> > +/*
> 
> I'm curious to why you created this wrapper function that adds no
> value? Why not call debug_rt_mutex_detect_deadlock() directly?

debug_rt_mutex_detect_deadlock() smells like a magic debug feature,
while rt_mutex_cond_detect_deadlock() clearly says; It's
conditional.
 
Thanks,

	tglx
