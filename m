Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3KVWcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:32:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:47487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3KVWcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:32:41 -0500
Date: Fri, 22 Nov 2013 23:32:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: badarkhe.manish@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [patch 05/34] idle: Implement generic idle function
In-Reply-To: <CAOh2x=nefF3QqHy2C8jRFeXj_JxyeUus+4D1OD96qj8BkYY-JA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311222328190.30673@ionos.tec.linutronix.de>
References: <20130321214930.752934102@linutronix.de> <20130321215233.646635455@linutronix.de> <CAOh2x=nefF3QqHy2C8jRFeXj_JxyeUus+4D1OD96qj8BkYY-JA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Viresh Kumar wrote:

> On Fri, Mar 22, 2013 at 3:23 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > --- linux-2.6.orig/kernel/cpu/idle.c
> > +++ linux-2.6/kernel/cpu/idle.c
> 
> > +void cpu_startup_entry(enum cpuhp_state state)
> > +{
> > +       current_set_polling();
> > +       arch_cpu_idle_prepare();
> > +       cpu_idle_loop();
> > +}
> > +#endif
> 
> Hi Thomas..
> 
> Manish (cc'd) recently asked me purpose of _state_ argument in this
> routine, As this is unused here..
> 
> Was this reserved for future use?

Yep, if you dig the mail archives you'll find my cpu hotplug series
which tries to convert it to a full state machine. So the state
argument is due to that, because the boot cpu will call into that with
a certain state and we want to allow archs to skip some states even on
secondary cpus. So yes, it's unused, but its there on purpose. It's
going to be used when my work backlog drops down to the cpuhotplug
mess again. About 2 lightyears from now ....

Thanks,

	tglx
