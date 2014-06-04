Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaFDT4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:56:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:41020 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaFDT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:56:18 -0400
Date: Wed, 4 Jun 2014 21:56:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 2/5] rtmutex: Cleanup deadlock detector debug logic
In-Reply-To: <20140604155440.7b137ee0@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406042155160.18296@nanos>
References: <20140531155229.493650009@linutronix.de> <20140531155739.265673091@linutronix.de> <20140531160043.1d4bfb07@gandalf.local.home> <alpine.DEB.2.10.1406041515470.3319@nanos> <20140604155440.7b137ee0@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Steven Rostedt wrote:

> On Wed, 4 Jun 2014 15:17:35 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > > > +static int rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
> > > > +					 enum rtmutex_chainwalk detect)
> > > > +{
> > > > +	return debug_rt_mutex_detect_deadlock(waiter, detect);
> > > > +}
> > > > +
> > > > +/*
> > > 
> > > I'm curious to why you created this wrapper function that adds no
> > > value? Why not call debug_rt_mutex_detect_deadlock() directly?
> > 
> > debug_rt_mutex_detect_deadlock() smells like a magic debug feature,
> > while rt_mutex_cond_detect_deadlock() clearly says; It's
> > conditional.
> 
> Which brings up the next obvious question. Um, why not just rename
> debug_rt_mutex_detect_deadlock() to rt_mutex_cond_detect_deadlock()?

Because I wanted to keep the cond function in the main source file
along with the comments instead of having two of the same in the
headers.

Thanks,

	tglx
