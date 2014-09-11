Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaIKOf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:35:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:40920 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaIKOf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:35:27 -0400
Date: Thu, 11 Sep 2014 16:35:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: Ask help about pre_init_apic_IRQ0()
In-Reply-To: <1410444181.7023.25.camel@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409111610430.4178@nanos>
References: <54116106.5090904@linux.intel.com>  <alpine.DEB.2.10.1409111225380.4178@nanos> <1410444181.7023.25.camel@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Andy Shevchenko wrote:
> On Thu, 2014-09-11 at 14:58 +0200, Thomas Gleixner wrote:
> []
> 
> > According to the MID code the apbt horror is only used for moorestown.
> > Medfield and later use the local apic timer without the apbt nonsense.
> > 
> > The best thing we can do is to drop moorestown support and get rid of
> > that apbt nonsense alltogether.
> 
> Alan Cox removed Moorestown (as a platform) support in 2012 IIRC.
> So, AFAIK you may safely remove those leftovers.

Good.
 
> > I don't think anyone deeply cares about it not being supported from
> > 3.18 on. The number of devices which sport a moorestown should be
> > pretty limited and the only relevant use case of those is to act as a
> > pocket heater with short battery life time. Its pretty pointless to
> > update kernels on pocket heaters except for bragging reasons.
> > 
> > If someone at Intel really thinks that we need to keep moorestown
> > alive for other than documentary and sentimental reasons, then we can
> > move the apbt setup to x86_init.timers.setup_percpu_clockev(). At that
> > point the IOAPIC is setup already, so it should just work. Untested
> > patch below.
> 
> Suddenly I have one priority work to do and my Medfield tablet doesn't
> boot by some reason. I would try to test it as soon as I can.

The patch wont make a difference, except you add

     x86_intel_mid_timer=apbt_only
or
     x86_intel_mid_timer=lapic_and_apbt

on the kernel commandline. But even w/o that patch I doubt that
anything post moorestown even has that apbt trainwreck implemented. If
I'm right then the commandline option will prevent the thing to boot
at all, which is an even better reason to remove that crap
alltogether.

Thanks,

	tglx




