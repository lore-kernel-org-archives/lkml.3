Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3IESOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:14:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3IESOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:14:20 -0400
Date: Thu, 5 Sep 2013 14:13:56 -0400
From: Dave Jones <davej@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130905181356.GA7309@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Greg KH <gregkh@linuxfoundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130903185924.046EE660E91@gitolite.kernel.org>
 <20130903204442.GA22222@redhat.com>
 <20130903205527.GA6358@kroah.com>
 <87zjrt6tz4.fsf@rustcorp.com.au>
 <20130905041338.GA21090@redhat.com>
 <20130905045745.GA18876@kroah.com>
 <20130905051945.GB23209@redhat.com>
 <20130905173540.GK6617@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905173540.GK6617@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:35:40PM +0100, Russell King - ARM Linux wrote:
 > On Thu, Sep 05, 2013 at 01:19:45AM -0400, Dave Jones wrote:
 > > Got it. (I think I was getting tracebacks from multiple cpus, hence
 > > the spewing). Adding a check for tainted() = infinite loop to
 > > show_backtrace() combined with boot_delay gave me a really long oops
 > > that I had to grab video to record.
 > 
 > How complete is this trace?  If accurate, I suspect that this is an oops
 > caused by the timer expiring, but the memory associated with the timer
 > has already been overwritten.  That would make it particularly hard to
 > debug.

There were some '?' symbols in the trace too which I omitted last night.
(offsets left out, because I'm hand-transcribing from video) 

<IRQ>
? call_timer_fn
? call_timer_fn
run_timer_softirq
__do_softirq
irq_exit
smp_apic_timer_interrupt
apic_timer_interrupt
<EOI>
? touch_nmi_watchdog
? touch_nmi_watchdog
vprintk_emit
? create_syslog_header
dev_vprintk_emit
? dump_trace
? trace_hardirqs_off_caller
? trace_hardirqs_off_caller
dev_print_emit
? trace_hardirqs_off_caller
__dev_printk
_dev_info
? trace_hardirqs_off
ahci_print_info
ahci_init_one
local_pci_probe
pci_device_probe
driver_probe_device
__driver_attach
? __device_attach
bus_for_each_dev
driver_attach
bus_add_driver
? ata_sff_init
driver_register
__pci_register_driver
ahci_pci_driver_init
do_one_initcall
? parse_args
kernel_init_freeable
? do_early_param
? rest_init
kernel_init
ret_from_fork
? rest_init

 > Maybe the patch below will allow Dave to boot to a prompt and capture
 > the full dmesg - I've only just cooked up this patch so it may need
 > a bit of work to get it to build.  Please ensure that kobject debugging
 > is enabled, so we can translate from kobject addresses to names.
 > 
 > Dave - thanks for your patience and effort in trying to track this down.
 > Hopefully the patch below will make it easier.

building now.

Thanks,

	Dave

