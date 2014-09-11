Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaIKPRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:17:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:54520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaIKPRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:17:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,506,1406617200"; 
   d="scan'208";a="476899144"
Message-ID: <1410448503.7023.27.camel@linux.intel.com>
Subject: Re: Ask help about pre_init_apic_IRQ0()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Date: Thu, 11 Sep 2014 18:15:03 +0300
In-Reply-To: <alpine.DEB.2.10.1409111610430.4178@nanos>
References: <54116106.5090904@linux.intel.com>
	 <alpine.DEB.2.10.1409111225380.4178@nanos>
	 <1410444181.7023.25.camel@linux.intel.com>
	 <alpine.DEB.2.10.1409111610430.4178@nanos>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:35 +0200, Thomas Gleixner wrote:
> On Thu, 11 Sep 2014, Andy Shevchenko wrote:
> > On Thu, 2014-09-11 at 14:58 +0200, Thomas Gleixner wrote:
> > []
> > 
> > > According to the MID code the apbt horror is only used for moorestown.
> > > Medfield and later use the local apic timer without the apbt nonsense.
> > > 
> > > The best thing we can do is to drop moorestown support and get rid of
> > > that apbt nonsense alltogether.
> > 
> > Alan Cox removed Moorestown (as a platform) support in 2012 IIRC.
> > So, AFAIK you may safely remove those leftovers.
> 
> Good.
>  
> > > I don't think anyone deeply cares about it not being supported from
> > > 3.18 on. The number of devices which sport a moorestown should be
> > > pretty limited and the only relevant use case of those is to act as a
> > > pocket heater with short battery life time. Its pretty pointless to
> > > update kernels on pocket heaters except for bragging reasons.
> > > 
> > > If someone at Intel really thinks that we need to keep moorestown
> > > alive for other than documentary and sentimental reasons, then we can
> > > move the apbt setup to x86_init.timers.setup_percpu_clockev(). At that
> > > point the IOAPIC is setup already, so it should just work. Untested
> > > patch below.
> > 
> > Suddenly I have one priority work to do and my Medfield tablet doesn't
> > boot by some reason. I would try to test it as soon as I can.
> 
> The patch wont make a difference, except you add

With patch nothing happened indeed.


>      x86_intel_mid_timer=apbt_only

[    0.116839] BUG: unable to handle kernel NULL pointer dereference at
0000003a
[    0.123803] IP: [<c1071c0e>] setup_irq+0xf/0x4d
...

> or
>      x86_intel_mid_timer=lapic_and_apbt

[    0.116858] BUG: unable to handle kernel NULL pointer dereference at
0000003a
[    0.123820] IP: [<c1071c0e>] setup_irq+0xf/0x4d
...

> 
> on the kernel commandline. But even w/o that patch I doubt that
> anything post moorestown even has that apbt trainwreck implemented. If
> I'm right then the commandline option will prevent the thing to boot
> at all, which is an even better reason to remove that crap
> alltogether.

See above.

> 
> Thanks,
> 
> 	tglx
> 
> 
> 
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

