Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3IEVLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab3IEVLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:11:39 -0400
Date: Thu, 5 Sep 2013 17:11:13 -0400
From: Dave Jones <davej@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130905211113.GA22201@redhat.com>
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
 <20130905192917.GA9339@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905192917.GA9339@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 03:29:17PM -0400, Dave Jones wrote:
 > On Thu, Sep 05, 2013 at 06:35:40PM +0100, Russell King - ARM Linux wrote:
 >  
 >  > Dave - thanks for your patience and effort in trying to track this down.
 >  > Hopefully the patch below will make it easier.
 >  
 > I'm not sure if this is happening because I enabled DEBUG_KOBJECT this time around
 > or not, but now I'm seeing a different trace. (same hang though)
 > 
 > serial8250: ttyS0 at I/O 0x3f8 (ieq =4, base_baud = 115200) is 16550A
 > Oops
 > RIP: kobject_release
 > trace:
 > 
 > kobject_put
 > cdev_del
 > tty_unregister_device
 > uart_remove_one_port
 > serial8250_register_8250_port
 > pciserial_init_ports
 > pciserial_init_one
 > local_pci_probe
 > pci_device_probe
 > driver_probe_device
 > __driver_attach
 > ? __device_attach
 > bus_for_each_dev
 > driver_attach
 > bus_add_driver
 > ? early_serial_setup
 > driver_register
 > ? early_serial_setup
 > __pci_register_driver
 > serial_pci_driver_init
 > do_one_initcall
 > 
 > 
 > Trying without serial console next..

rebuilt with all serial turned off.

no luck, then it oopses somewhere else. I'm suspecting something isn't
right with that debug patch, as the next trace is also in kobject_release

	Dave
