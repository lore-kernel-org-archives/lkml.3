Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaLDA7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:59:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:56394 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaLDA7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:59:17 -0500
Date: Thu, 4 Dec 2014 01:59:01 +0100 (CET)
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
In-Reply-To: <20141204002044.GA15239@redhat.com>
Message-ID: <alpine.DEB.2.11.1412040156070.16275@nanos>
References: <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com> <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com> <20141203200906.GA3118@redhat.com> <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com>
 <alpine.DEB.2.11.1412032141040.16275@nanos> <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com> <alpine.DEB.2.11.1412032249050.16275@nanos> <20141203232115.GA13266@redhat.com> <alpine.DEB.2.11.1412040043170.16275@nanos>
 <20141204002044.GA15239@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Dave Jones wrote:
> On Thu, Dec 04, 2014 at 12:49:29AM +0100, Thomas Gleixner wrote:
> 
>  > > I just got 
>  > > 
>  > > [ 1472.614433] Clocksource tsc unstable (delta = -26373048906 ns)
>  > > 
>  > > without any sign of the pr_err above.
>  > 
>  > Bah. Would have been too simple ....
>  > 
>  > Could you please run Ingos time-warp test on that machine for a while?
>  > 
>  >    http://people.redhat.com/mingo/time-warp-test/time-warp-test.c
>  > 
>  > Please change:
>  > 
>  > - #define TEST_CLOCK 0
>  > + #define TEST_CLOCK 1
> 
> Seems to be 32-bit only, so I built it with -m32. I assume that's ok?

I has some _x86_64 ifdeffery, but I'm too tired to stare at that
now. 32bit should show the issue as well.
 
> Also, should I run it in isolation, with nothing else going on,
> or under load where I see problems ?

isolated is usually the best thing as it has the highest density of
reads.

Thanks,

	tglx
