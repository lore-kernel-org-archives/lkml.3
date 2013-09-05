Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3IEFvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:51:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab3IEFvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:51:08 -0400
Date: Thu, 5 Sep 2013 01:19:45 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rmk+kernel@arm.linux.org.uk
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130905051945.GB23209@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	rmk+kernel@arm.linux.org.uk
References: <20130903185924.046EE660E91@gitolite.kernel.org>
 <20130903204442.GA22222@redhat.com>
 <20130903205527.GA6358@kroah.com>
 <87zjrt6tz4.fsf@rustcorp.com.au>
 <20130905041338.GA21090@redhat.com>
 <20130905045745.GA18876@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905045745.GA18876@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 09:57:45PM -0700, Greg KH wrote:
 > On Thu, Sep 05, 2013 at 12:13:38AM -0400, Dave Jones wrote:
 > > On Wed, Sep 04, 2013 at 02:53:11PM +0930, Rusty Russell wrote:
 > >  
 > >  > >> With this enabled, I get a bunch of scrolling oopses immediately after
 > >  > >> exiting the bootloader. It happens so early I can't even capture them
 > >  > >> over usb-serial, or earlyprintk=dbgp.
 > >  > >> 
 > >  > >> And for whatever reason, the printk path while oopsing ignores boot_delay parameter,
 > >  > >> so I can't even use that.
 > >  > >> 
 > >  > >> any ideas ?
 > >  > >
 > >  > > The first big bug found with this was with the module kobject code, and
 > >  > > a fix for that should be going in through Rusty's tree to Linus for this
 > >  > > merge window (right Rusty?)
 > >  > 
 > >  > Yep, just sent pull request.  The fix was the final commit there...
 > > 
 > > Crap, that isn't the bug I'm hitting.
 > 
 > Any chance to get a oops traceback?

Got it. (I think I was getting tracebacks from multiple cpus, hence the spewing).
Adding a check for tainted() = infinite loop to show_backtrace() combined with boot_delay
gave me a really long oops that I had to grab video to record.

RIP: <null>

Trace:
<IRQ>
run_timer_softirq
__do_softirq
irq_exit
smp_apic_timer_interrupt
apic_timer_interrupt
<EOI>
vprintk_emit
dev_vprintk_emit
dev_vprint_emit
__dev_printk
_dev_info
ahci_print_info
ahci_init_one
local_pci_probe
pci_device_probe
driver_probe_device
__driver_attach
bus_for_each_dev
driver_attach
bus_add_driver
driver_register
__pci_register_driver
ahci_pci_driver_init
do_one_initcall
...

	Dave

