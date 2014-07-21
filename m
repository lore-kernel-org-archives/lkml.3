Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaGUSZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:25:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:32910 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341AbaGUSZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:25:15 -0400
Date: Mon, 21 Jul 2014 20:24:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
In-Reply-To: <871tte3bjw.fsf@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1407212021540.20847@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Andi Kleen wrote:

> Andi Kleen <andi@firstfloor.org> writes:
> 
> > Waiman Long <Waiman.Long@hp.com> writes:
> >
> >> This patch series introduces two new futex command codes to support
> >> a new optimistic spinning futex for implementing an exclusive lock
> >> primitive that should perform better than the same primitive using
> >> the wait-wake futex in cases where the lock owner is actively working
> >> instead of waiting for I/O completion.
> >
> > How would you distinguish those two cases automatically?
> 
> Also BTW traditionally the spinning was just done in user space.

And traditionally that is based on heuristics, because user space
cannot figure out whether the lock owner is on the CPU or not. 
 
And heuristics suck no matter what.

There have been attempts to expose that information to user space, but
that sucks as well, as it requires updates of that information from
the guts of the scheduler, does not scale at all and what's worse, it
has security implications.

Thanks,

	tglx
