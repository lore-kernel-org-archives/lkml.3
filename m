Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3BEU0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:26:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58312 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756607Ab3BEU0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:26:09 -0500
Date: Tue, 5 Feb 2013 15:26:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Hurley <peter@hurleysoftware.com>
cc: Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: [-next-20130204] usb/hcd:  irq 18: nobody cared
In-Reply-To: <1360086665.3298.16.camel@thor.lan>
Message-ID: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Peter Hurley wrote:

> With -next-20130204:
> 
> [   33.855570] irq 18: nobody cared (try booting with the "irqpoll" option)
> [   33.855580] Pid: 0, comm: swapper/4 Not tainted 3.8.0-next-20130204-xeon #20130204
> [   33.855582] Call Trace:
> [   33.855585]  <IRQ>  [<ffffffff810f1076>] __report_bad_irq+0x36/0xe0
> [   33.855600]  [<ffffffff810f152a>] note_interrupt+0x1aa/0x200
> [   33.855606]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
> [   33.855610]  [<ffffffff810eed89>] handle_irq_event_percpu+0xc9/0x260
> [   33.855614]  [<ffffffff810eef68>] handle_irq_event+0x48/0x70
> [   33.855618]  [<ffffffff810f20ba>] handle_fasteoi_irq+0x5a/0x100
> [   33.855624]  [<ffffffff810182f2>] handle_irq+0x22/0x40
> [   33.855630]  [<ffffffff816e2a9a>] do_IRQ+0x5a/0xd0
> [   33.855636]  [<ffffffff816d97ad>] common_interrupt+0x6d/0x6d
> [   33.855638]  <EOI>  [<ffffffff810f8e2a>] ? rcu_eqs_enter_common+0x4a/0x320
> [   33.855646]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
> [   33.855649]  [<ffffffff8101ed99>] ? mwait_idle+0x29/0x1b0
> [   33.855653]  [<ffffffff8101f8a6>] cpu_idle+0x116/0x130
> [   33.855658]  [<ffffffff816c0c0f>] start_secondary+0x251/0x258
> [   33.855660] handlers:
> [   33.855664] [<ffffffff814f98a0>] usb_hcd_irq
> [   33.855667] Disabling IRQ #18
> 
> From earlier in the boot log:
> [    1.297020] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.297032] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.297040] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> [    1.297076] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
> [    1.297213] hub 4-0:1.0: USB hub found
> [    1.297221] hub 4-0:1.0: 2 ports detected
> 
> lsusb:
> ...
> Bus 004 Device 002: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS
> Bus 004 Device 003: ID 046d:c52b Logitech, Inc. Unifying Receiver
> ...
> 
> Didn't have this problem with -next-20120125. One of these commits, maybe?
> next/drivers/usb/core$ git log --oneline next-20130125..next-20130204 -- *
> 2c2e865 usb: forbid memory allocation with I/O during bus reset
> e9121a8 Merge remote-tracking branch 'usb/usb-next'
> 3b2ab2b Revert "usb: Register usb port's acpi power resources"
> da0aa71 USB: add usb_hcd_{start,end}_port_resume
> 192fef1 usb: enable usb port device's async suspend.
> f6cced1 usb: expose usb port's pm qos flags to user space
> ad493e5 usb: add usb port auto power off mechanism
> 971fcd4 usb: add runtime pm support for usb port device
> 88bb965 usb: Register usb port's acpi power resources
> 54a3ac0 usb: Using correct way to clear usb3.0 device's remote wakeup feature.

None of those commits seems likely to have caused the problem.  The 
most likely is da0aa71, combined with one you didn't mention:

840008bb USB: UHCI: notify usbcore about port resumes

If you revert these two commits, does that make any difference?  What
if you revert all of these commits?

> I didn't see any changes in the drivers/hid/hid-logitech-dj.c or usbhid
> but maybe it's doing something wrong anyway?
> 
> I'll open a bugzilla if a bunch more info is necessary.

If the suggestion above doesn't work out, bisection may be the best way
to find the answer.

Alan Stern

