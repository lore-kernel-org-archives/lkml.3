Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaLCXtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:49:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:56193 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaLCXtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:49:46 -0500
Date: Thu, 4 Dec 2014 00:49:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141203232115.GA13266@redhat.com>
Message-ID: <alpine.DEB.2.11.1412040043170.16275@nanos>
References: <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com> <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
 <20141203200906.GA3118@redhat.com> <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com> <alpine.DEB.2.11.1412032141040.16275@nanos> <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com> <alpine.DEB.2.11.1412032249050.16275@nanos>
 <20141203232115.GA13266@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Dave Jones wrote:
> On Wed, Dec 03, 2014 at 11:19:11PM +0100, Thomas Gleixner wrote:
>  > On Wed, 3 Dec 2014, Linus Torvalds wrote:
>  > > On Wed, Dec 3, 2014 at 12:55 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>  > > >
>  > > > But it's always negative, which means HPET is always ahead of
>  > > > TSC. That excludes pretty much the clocksource watchdog starvation
>  > > > issue which results in TSC being ahead of HPET due to a HPET
>  > > > wraparound (which takes ~300s).
>  > > 
>  > > Still, I'd be more likely to trust the TSC than the HPET on modern
>  > > machines.. And DaveJ's machine isn't some old one.
>  > 
>  > Well, that does not explain the softlock watchdog which is solely
>  > relying on the TSC.
>  > 
>  > > Of course, there's always BIOS games. Can we read the TSC offset
>  > > register and check it being constant (modulo sleep events)?
>  > 
>  > The kernel does not touch it. Here is a untested hack to verify it on
>  > every local apic timer interrupt. Not nice, but simple :)
>  
>  > +			pr_err("TSC adjustment on cpu %d changed %llu -> %llu\n",
>  > +			       cpu,
>  > +			       (unsigned long long) __this_cpu_read(tsc_adjust),
>  > +			       (unsigned long long) adj);
> 
> I just got 
> 
> [ 1472.614433] Clocksource tsc unstable (delta = -26373048906 ns)
> 
> without any sign of the pr_err above.

Bah. Would have been too simple ....

Could you please run Ingos time-warp test on that machine for a while?

   http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

Please change:

- #define TEST_CLOCK 0
+ #define TEST_CLOCK 1

I'll dig further into the time/clocksource whatever related changes
post 3.16

Thanks,

	tglx
