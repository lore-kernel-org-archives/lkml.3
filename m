Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab3CVJ01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:26:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:35272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079Ab3CVJ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:26:25 -0400
Date: Fri, 22 Mar 2013 10:26:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Breeds <tony@bakeyournoodle.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 02/34] arch: Consolidate tsk_is_polling()
In-Reply-To: <20130322052010.GB31022@thor.bakeyournoodle.com>
Message-ID: <alpine.LFD.2.02.1303221025530.22263@ionos>
References: <20130321214930.752934102@linutronix.de> <20130321215233.446034505@linutronix.de> <20130322052010.GB31022@thor.bakeyournoodle.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Tony Breeds wrote:

> On Thu, Mar 21, 2013 at 09:52:57PM -0000, Thomas Gleixner wrote:
>  
> > +/*
> > + * Idle thread specific functions to determine the need_resched
> > + * polling state. We have two versions, one based on TS_POLLING in
> > + * thread_info.status and one based on TIF_POLLING_NRFLAG in
> > + * thread_info.flags
> > + */
> > +#ifdef TS_POLLING
> > +static inline int tsk_is_polling(struct task_struct *p)
> > +{
> > +	return task_thread_info(p)->status & TS_POLLING;
> > +}
> > +#elif defined(TIF_POLLING_NRFLAG)
> > +static inline int tsk_is_polling(struct task_struct *p)
> > +{
> > +	test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
> > +}
> 
> On powerpc (at least) this is used before it's declared.  Also I think
> you're missing a 'return' in that function.

Mooo
 
> *cough* https://www.kernel.org/pub/tools/crosstool/ *cough*

Yes, I know. /me feels bad
