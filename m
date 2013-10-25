Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3JYKYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:24:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:40197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3JYKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:23:59 -0400
Date: Fri, 25 Oct 2013 12:23:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
In-Reply-To: <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
References: <525BD08C.2080101@t-online.de> <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com> <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Oct 2013, Linus Torvalds wrote:

> On Mon, Oct 14, 2013 at 6:53 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > And your other oopses do seem to have a similar pattern, even if their
> > actual oops is elsewhere. They oops in run_timer_softirq, also taking
> > a page fault in the 0xf9...... range, so it might well be a vmalloc
> > address there too.
> 
> Hmm.. I just got a run_timer_softirq oops on my own laptop, slightly
> different. That was not during shutdown, although there was a "yum
> upgrade" finishing when that happened, so it's quite likely that there
> was a service shutdown (and then restart).
> 
> I think it's related. But my oops has almost no information: the IP
> that was jumped to was bogus, and the callchain is just CPU idle
> followed by the softirq -> run_timers_softirq handling, so there's no
> real way to see *what* triggered it.
> 
> The bad rip was ffffffffa051e250, which is not a valid code address.
> It *might* be a module address, though. So this might be triggered by
> rmmod on some module that doesn't remove all its timers...
> 
> Ideas?

Enable DEBUG_OBJECTS, DEBUG_OBJECTS_FREE, DEBUG_OBJECTS_TIMERS

That should give you an accurate hint what site is not cleaning up
proper.

Thanks,

	tglx
