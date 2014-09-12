Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaILI0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:26:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:46038 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaILI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:26:29 -0400
Date: Fri, 12 Sep 2014 10:26:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: Ask help about pre_init_apic_IRQ0()
In-Reply-To: <1410509968.7023.33.camel@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409121020290.4178@nanos>
References: <54116106.5090904@linux.intel.com>  <alpine.DEB.2.10.1409111225380.4178@nanos>  <1410444181.7023.25.camel@linux.intel.com>  <alpine.DEB.2.10.1409111610430.4178@nanos>  <1410448503.7023.27.camel@linux.intel.com>  <alpine.DEB.2.10.1409112354501.4178@nanos>
 <1410509968.7023.33.camel@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Andy Shevchenko wrote:
> On Thu, 2014-09-11 at 23:59 +0200, Thomas Gleixner wrote:

> > > >      x86_intel_mid_timer=apbt_only
> 
> w/o patch
> 
> [    0.000000] Early APIC setup for system timer0
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at
> arch/x86/kernel/apic/apic.c:1393 setup_local_APIC+0x20c/0x2d9()
> 
> ...and stuck a bit later

Right, because there is no apbt timer in that machine and the
commandline tells the kernel to use it and ignore the local apic
timer.
 
> > > > or
> > > >      x86_intel_mid_timer=lapic_and_apbt
> > > 
> > > [    0.116858] BUG: unable to handle kernel NULL pointer dereference at
> > > 0000003a
> > > [    0.123820] IP: [<c1071c0e>] setup_irq+0xf/0x4d
> > > ...
> > > 
> 
> w/o patch
> 
> [    0.000000] Early APIC setup for system timer0
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at
> arch/x86/kernel/apic/apic.c:1393 setup_local_APIC+0x20c/0x2d9()
> 
> ...and boots normally

Right, because it uses the local apic timer later on.
 
Thanks for providing the data! I'll queue a removal of this mess.

Thanks,

	tglx
