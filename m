Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaDNRHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:07:37 -0400
Received: from www84.your-server.de ([213.133.104.84]:40327 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaDNRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:07:35 -0400
Message-ID: <1397495205.1854.3.camel@vger.seibold.net>
Subject: Re: EHCI hotplug kernel crash in kernel 3.14 and 3.13
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Date: Mon, 14 Apr 2014 19:06:45 +0200
In-Reply-To: <Pine.LNX.4.44L0.1404141107520.874-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404141107520.874-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

the patch fix the issue. I tested it on a notebook with a cardbus
controller and on desktop machine with a thunderbolt interface. Both are
working.

Thunderbolt will sometimes crash but i think this is a issue with
dynamic added pci bridges, which cause a lot of trouble and headache  to
me.

Thanks,

Greetings,
Stefani

Am Montag, den 14.04.2014, 11:11 -0400 schrieb Alan Stern:
> On Sun, 13 Apr 2014, Stefani Seibold wrote:
> 
> > A hot plug of an USB 2.0 EHCI controller cardbus card will result in a
> > kernel crash. This is the kernel log of a vanilla 3.14 x86_64 kernel. I
> > will attach my kernel config.
> 
> > [   70.419755] ehci-pci 0000:04:00.2: EHCI Host Controller
> > [   70.419874] ehci-pci 0000:04:00.2: new USB bus registered, assigned bus number 9
> > [   70.419980] ehci-pci 0000:04:00.2: irq 19, io mem 0xf1402000
> > [   70.422796] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> > [   70.424894] ohci-pci: OHCI PCI platform driver
> > [   70.425072] ehci-pci 0000:04:00.2: USB 2.0 started, EHCI 0.95
> > [   70.425132] usb usb9: New USB device found, idVendor=1d6b, idProduct=0002
> > [   70.425135] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> > [   70.425138] usb usb9: Product: EHCI Host Controller
> > [   70.425141] usb usb9: Manufacturer: Linux 3.14.0 ehci_hcd
> > [   70.425144] usb usb9: SerialNumber: 0000:04:00.2
> > [   70.425332] hub 9-0:1.0: USB hub found
> > [   70.425344] hub 9-0:1.0: 5 ports detected
> > [   70.425556] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > [   70.425560] IP: [<ffffffff814947cc>] usb_set_configuration+0x1c/0x7d0
> > [   70.425568] PGD 30d571067 PUD 30d570067 PMD 0 
> > [   70.425572] Oops: 0000 [#1] PREEMPT SMP 
> > [   70.425576] Modules linked in: ohci_pci(+) ohci_hcd rfcomm btusb ppdev intel_agp intel_gtt 8250 video parport_pc parport serial_core nvidia(PO) drm agpgart
> > [   70.425604] CPU: 3 PID: 83 Comm: pccardd Tainted: P           O 3.14.0 #1
> > [   70.425607] Hardware name: Dell Inc. Precision M6400                 /0G841G, BIOS A13 06/05/2013
> > [   70.425609] task: ffff88030eefe150 ti: ffff88030ef86000 task.ti: ffff88030ef86000
> > [   70.425611] RIP: 0010:[<ffffffff814947cc>]  [<ffffffff814947cc>] usb_set_configuration+0x1c/0x7d0
> > [   70.425615] RSP: 0018:ffff88030ef87ba0  EFLAGS: 00010286
> > [   70.425617] RAX: ffff88030c7ce800 RBX: 0000000000000000 RCX: ffff88030ea57000
> > [   70.425619] RDX: ffff88030dcb6800 RSI: 0000000000000001 RDI: 0000000000000000
> > [   70.425620] RBP: ffff88030ef87c38 R08: ffff88030dfa6910 R09: 0000000000000000
> > [   70.425622] R10: 0000000000004e2e R11: 0000000000000000 R12: 0000000000000000
> > [   70.425624] R13: 0000000000000000 R14: ffffffff814a0b80 R15: ffff88030c7ce800
> > [   70.425626] FS:  0000000000000000(0000) GS:ffff88031fd80000(0000) knlGS:0000000000000000
> > [   70.425628] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [   70.425630] CR2: 0000000000000040 CR3: 000000030c714000 CR4: 00000000000407e0
> > [   70.425631] Stack:
> > [   70.425632]  ffffffff81340110 ffffffff814a0b80 ffff88030ef87bc8 ffffffff817b3858
> > [   70.425636]  ffff88030dcb6898 ffff88030ef87c00 ffffffff813d6daf ffff88030f429000
> > [   70.425640]  000000010ef87bf0 ffffffff813d4737 ffff88030ef87c00 ffffffff8133f19a
> > [   70.425644] Call Trace:
> > [   70.425650]  [<ffffffff81340110>] ? pci_do_find_bus+0x70/0x70
> > [   70.425653]  [<ffffffff814a0b80>] ? hcd_pci_suspend_noirq+0xa0/0xa0
> > [   70.425659]  [<ffffffff817b3858>] ? klist_iter_exit+0x18/0x30
> > [   70.425663]  [<ffffffff813d6daf>] ? bus_find_device+0x7f/0xb0
> > [   70.425666]  [<ffffffff813d4737>] ? put_device+0x17/0x20
> > [   70.425669]  [<ffffffff8133f19a>] ? pci_dev_put+0x1a/0x20
> > [   70.425672]  [<ffffffff81340361>] ? pci_get_dev_by_id+0x61/0x90
> > [   70.425675]  [<ffffffff814a0b80>] ? hcd_pci_suspend_noirq+0xa0/0xa0
> > [   70.425679]  [<ffffffff814a0bcb>] ehci_post_add+0x4b/0x60
> > [   70.425682]  [<ffffffff814a0070>] for_each_companion+0x80/0xa0
> > [   70.425685]  [<ffffffff814a0504>] usb_hcd_pci_probe+0x474/0x4e0
> 
> I think I see the problem; the driver data for the companion controller 
> gets set before we expect it.  The patch below should help, by adding a 
> check to see that the companion's root hub has been allocated.
> 
> Alan Stern
> 
> 
> 
> Index: usb-3.14/drivers/usb/core/hcd-pci.c
> ===================================================================
> --- usb-3.14.orig/drivers/usb/core/hcd-pci.c
> +++ usb-3.14/drivers/usb/core/hcd-pci.c
> @@ -75,7 +75,7 @@ static void for_each_companion(struct pc
>  				PCI_SLOT(companion->devfn) != slot)
>  			continue;
>  		companion_hcd = pci_get_drvdata(companion);
> -		if (!companion_hcd)
> +		if (!companion_hcd || !companion_hcd->self.root_hub)
>  			continue;
>  		fn(pdev, hcd, companion, companion_hcd);
>  	}
> 


