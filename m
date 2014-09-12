Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaILITg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:19:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:64914 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbaILITc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:19:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,511,1406617200"; 
   d="scan'208";a="477073076"
Message-ID: <1410509968.7023.33.camel@linux.intel.com>
Subject: Re: Ask help about pre_init_apic_IRQ0()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Date: Fri, 12 Sep 2014 11:19:28 +0300
In-Reply-To: <alpine.DEB.2.10.1409112354501.4178@nanos>
References: <54116106.5090904@linux.intel.com>
	 <alpine.DEB.2.10.1409111225380.4178@nanos>
	 <1410444181.7023.25.camel@linux.intel.com>
	 <alpine.DEB.2.10.1409111610430.4178@nanos>
	 <1410448503.7023.27.camel@linux.intel.com>
	 <alpine.DEB.2.10.1409112354501.4178@nanos>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 23:59 +0200, Thomas Gleixner wrote:
[]

> > With patch nothing happened indeed.
> > 
> > 
> > >      x86_intel_mid_timer=apbt_only
> > 
> > [    0.116839] BUG: unable to handle kernel NULL pointer dereference at
> > 0000003a
> > [    0.123803] IP: [<c1071c0e>] setup_irq+0xf/0x4d
> > ...
> > 

w/o patch

[    0.000000] Early APIC setup for system timer0
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at
arch/x86/kernel/apic/apic.c:1393 setup_local_APIC+0x20c/0x2d9()

...and stuck a bit later

> > > or
> > >      x86_intel_mid_timer=lapic_and_apbt
> > 
> > [    0.116858] BUG: unable to handle kernel NULL pointer dereference at
> > 0000003a
> > [    0.123820] IP: [<c1071c0e>] setup_irq+0xf/0x4d
> > ...
> > 

w/o patch

[    0.000000] Early APIC setup for system timer0
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at
arch/x86/kernel/apic/apic.c:1393 setup_local_APIC+0x20c/0x2d9()

...and boots normally


> > > 
> > > on the kernel commandline. But even w/o that patch I doubt that
> > > anything post moorestown even has that apbt trainwreck implemented. If
> > > I'm right then the commandline option will prevent the thing to boot
> > > at all, which is an even better reason to remove that crap
> > > alltogether.
> > 
> > See above.
> 
> That was with the patch applied, right? 

Correct.

> What happens if you undo the
> patch and add the command line options?

See above.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

