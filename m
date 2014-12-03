Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaLCXWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:22:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaLCXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:22:01 -0500
Date: Wed, 3 Dec 2014 18:21:15 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203232115.GA13266@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>
References: <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141203190045.GB32005@redhat.com>
 <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
 <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
 <20141203200906.GA3118@redhat.com>
 <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com>
 <alpine.DEB.2.11.1412032141040.16275@nanos>
 <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com>
 <alpine.DEB.2.11.1412032249050.16275@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412032249050.16275@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:19:11PM +0100, Thomas Gleixner wrote:
 > On Wed, 3 Dec 2014, Linus Torvalds wrote:
 > > On Wed, Dec 3, 2014 at 12:55 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
 > > >
 > > > But it's always negative, which means HPET is always ahead of
 > > > TSC. That excludes pretty much the clocksource watchdog starvation
 > > > issue which results in TSC being ahead of HPET due to a HPET
 > > > wraparound (which takes ~300s).
 > > 
 > > Still, I'd be more likely to trust the TSC than the HPET on modern
 > > machines.. And DaveJ's machine isn't some old one.
 > 
 > Well, that does not explain the softlock watchdog which is solely
 > relying on the TSC.
 > 
 > > Of course, there's always BIOS games. Can we read the TSC offset
 > > register and check it being constant (modulo sleep events)?
 > 
 > The kernel does not touch it. Here is a untested hack to verify it on
 > every local apic timer interrupt. Not nice, but simple :)
 
 > +			pr_err("TSC adjustment on cpu %d changed %llu -> %llu\n",
 > +			       cpu,
 > +			       (unsigned long long) __this_cpu_read(tsc_adjust),
 > +			       (unsigned long long) adj);

I just got 

[ 1472.614433] Clocksource tsc unstable (delta = -26373048906 ns)

without any sign of the pr_err above.

	Dave
