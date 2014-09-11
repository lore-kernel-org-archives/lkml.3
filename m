Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaIKJJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:09:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:41460 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbaIKJI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="476840738"
Message-ID: <1410426536.7023.19.camel@linux.intel.com>
Subject: Re: Ask help about pre_init_apic_IRQ0()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>
Date: Thu, 11 Sep 2014 12:08:56 +0300
In-Reply-To: <20140911085303.GN13406@lahna.fi.intel.com>
References: <54116106.5090904@linux.intel.com>
	 <20140911085303.GN13406@lahna.fi.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 11:53 +0300, Mika Westerberg wrote:
> On Thu, Sep 11, 2014 at 04:44:54PM +0800, Jiang Liu wrote:
> > Hi Thomas,
> > 
> > When converting IOAPIC to hierarchy irqdomain, I ran into trouble when
> > dealing with pre_init_apic_IRQ0(). Currently pre_init_apic_IRQ0() is
> > only used by intel-mid platform and is called before initializing of
> > IOAPIC irqdomains. That really causes headache when converting to
> > hierarchy irqdomain. So could we delay
> > 	io_apic_setup_irq_pin(0, 0, &attr);
> >         irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
> >                                       "edge");
> > to the point of "check_timer()"?
> > 
> > I have no MID hardware at handle so can't experiment with it. Could
> > you please refer someone for help?
> 
> Andy (Cc'd) has some MID boards that he uses almost daily basis. Andy
> can you help Jiang here?

I'm not familiar with IRQ domains like people Cc'ed here, but I could
test any patch you provide to me. Just keep me in Cc list of those
patches you would like to be tested on Intel MID, though I have only
Intel Medfield based board. For newer stuff would be better to ask David
(Cc'ed).

> 
> > 
> > /* Enable IOAPIC early just for system timer */
> > void __init pre_init_apic_IRQ0(void)
> > {
> >         struct io_apic_irq_attr attr = { 0, 0, 0, 0 };
> > 
> >         printk(KERN_INFO "Early APIC setup for system timer0\n");
> > #ifndef CONFIG_SMP
> >         physid_set_mask_of_physid(boot_cpu_physical_apicid,
> >                                          &phys_cpu_present_map);
> > #endif
> >         setup_local_APIC();
> > 
> >         io_apic_setup_irq_pin(0, 0, &attr);
> >         irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
> >                                       "edge");
> > }
> > 
> > Regards!
> > Gerry


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

