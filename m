Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaENGm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 02:42:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:40149 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaENGmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 02:42:25 -0400
Date: Wed, 14 May 2014 08:42:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
In-Reply-To: <20140513184430.5f2e12f8@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405140840140.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512201700.999660035@linutronix.de> <5371B2D9.8060405@cn.fujitsu.com> <20140513084815.GB2485@laptop.programming.kicks-ass.net> <alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
 <20140513162041.3405b668@gandalf.local.home> <20140513203619.GV18164@linux.vnet.ibm.com> <alpine.DEB.2.02.1405132301530.6261@ionos.tec.linutronix.de> <20140513220009.GW18164@linux.vnet.ibm.com> <20140513184430.5f2e12f8@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Steven Rostedt wrote:

> On Tue, 13 May 2014 15:00:09 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
>  
> > Good points -- I was indeed thinking about stress testing instead of
> > algorithmic testing.
> 
> But doesn't lockdep use algorithmic tests too?

Kinda, but only for the deadlock detection.

I'm not sure if we want to inflict PI correctness and set_scheduler()
interaction to lockdep.

Thanks,

	tglx
