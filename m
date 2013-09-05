Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3IEPrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab3IEPrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:47:22 -0400
Date: Thu, 5 Sep 2013 11:47:00 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rmk+kernel@arm.linux.org.uk
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130905154700.GD24177@redhat.com>
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
 <20130905051945.GB23209@redhat.com>
 <20130905153457.GA27954@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905153457.GA27954@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 08:34:57AM -0700, Greg KH wrote:
 
 > > Trace:
 > > <IRQ>
 > > run_timer_softirq
 > > __do_softirq
 > > irq_exit
 > > smp_apic_timer_interrupt
 > > apic_timer_interrupt
 > > <EOI>
 > > vprintk_emit
 > > dev_vprintk_emit
 > > dev_vprint_emit
 > > __dev_printk
 > > _dev_info
 > > ahci_print_info
 > > ahci_init_one
 > > local_pci_probe
 > > pci_device_probe
 > > driver_probe_device
 > > __driver_attach
 > > bus_for_each_dev
 > > driver_attach
 > > bus_add_driver
 > > driver_register
 > > __pci_register_driver
 > > ahci_pci_driver_init
 > 
 > So we are loading a ahci driver here.  Any hint as to which
 > driver/device this is?  Is it a device that fails for this driver, and
 > then falls back to another more "specific" one?

It's "ahci.ko" (though it's built in).
For a boring onboard intel sata controller...
00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 04)

 
When I disable the debug option, usually it looks like..

[    6.382970] ahci 0000:00:1f.2: version 3.0
[    6.384753] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    6.385039] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x6 impl SATA mode
[    6.385067] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    6.385101] ahci 0000:00:1f.2: setting latency timer to 64
[    6.402536] scsi0 : ahci
[    6.403669] scsi1 : ahci
[    6.404208] scsi2 : ahci
[    6.404756] scsi3 : ahci
[    6.405342] scsi4 : ahci
[    6.405951] scsi5 : ahci
[    6.406345] ata1: DUMMY
[    6.406364] ata2: SATA max UDMA/133 abar m2048@0xc043b000 port 0xc043b180 irq 43
[    6.406393] ata3: SATA max UDMA/133 abar m2048@0xc043b000 port 0xc043b200 irq 43
[    6.406416] ata4: DUMMY
[    6.406427] ata5: DUMMY
[    6.406438] ata6: DUMMY

	Dave

