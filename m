Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaEOQql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:46:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:55010 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaEOQqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:46:40 -0400
Date: Thu, 15 May 2014 18:46:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, Mateusz Guzik <mguzik@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: WARN in do_rt_tgsigqueueinfo()
In-Reply-To: <20140515155415.GA326@redhat.com>
Message-ID: <alpine.DEB.2.02.1405151845070.6261@ionos.tec.linutronix.de>
References: <20140515133834.GN13658@twins.programming.kicks-ass.net> <20140515142723.GB22041@mguzik.redhat.com> <20140515150412.GP30445@twins.programming.kicks-ass.net> <20140515155415.GA326@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Dave Jones wrote:

> On Thu, May 15, 2014 at 05:04:12PM +0200, Peter Zijlstra wrote:
> 
>  > > > trinity$ MALLOC_CHECK_=0 ./trinity -xinit_module -xreboot -xshutdown -xunshare -xnfsservctl -xclock_nanosleep -xuselib -xumount -xmount -m --quiet -C 400 -l off -xmremap
>  > > > 
>  > > > [watchdog] kernel became tainted! (512/0) Last seed was 4072360471
>  > > > 
>  > > > [15908.562512] ------------[ cut here ]------------
>  > > > [15908.567245] WARNING: CPU: 22 PID: 3312 at /usr/src/linux-2.6/kernel/signal.c:3060 do_rt_tgsigqueueinfo+0xb4/0xc0()
>  > > > 
>  > > > This is apparently a very common thing to hit according to google.
>  > > 
>  > > Well, it warns about an argument received from userland, so nothing fishy
>  > > going on as far as kernel consistency is concerned if that's what you mean.
>  > 
>  > I hadn't looked that far.. I just manged to hit it two times in a row
>  > while waiting for my bug to trigger.
> 
> There's a ton of 'noise' like this that fuzzing turns up.
> I've been collecting some of the stuff to shut it up..
> 
> http://codemonkey.org.uk/junk/silence-fuzz-testing-noise.patch
> http://codemonkey.org.uk/junk/silence-noisy-deprecated-warnings-while-fuzzing.patch
> 
> I'm of the opinion that a user-triggerable WARN is a bug, but aparently
> not everyone else feels that way.

I agree. It returns -EPERM which is the right answer

Thanks,

	tglx
