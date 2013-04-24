Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3DXUce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:32:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47586 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757600Ab3DXUcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:32:33 -0400
Date: Wed, 24 Apr 2013 16:32:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
In-Reply-To: <CA+icZUWUof6BJQWefi-dYfFhO_hRLF5aKsOVO0CAbFCo_UVn2w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304241625050.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Sedat Dilek wrote:

> > [ CC linux-pm and linux-usb (ehci) folks ]
> >
> > This happens with my external USB mouse after suspend/resume.
> >
> > Excerpt (full dmesg and kernel-config attached):
> >
> > $ dmesg | egrep -i 'usb|async' | grep 1-1.2
> > [    1.258602] usb 1-1.2: new low-speed USB device number 3 using ehci-pci
> > [    1.368649] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
> > [    1.368661] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
> > SerialNumber=0
> > [    1.368668] usb 1-1.2: Product: USB-PS/2 Optical Mouse
> > [    1.368672] usb 1-1.2: Manufacturer: Logitech
> > [    1.957999] input: Logitech USB-PS/2 Optical Mouse as
> > /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
> > [   62.353997] usb 1-1.2: reset low-speed USB device number 3 using ehci-pci
> > [   62.636893] PM: Device 1-1.2 failed to resume async: error -32
> > [   64.243543] usb 1-1.2: USB disconnect, device number 3
> > [   64.380328] usb 1-1.2: new low-speed USB device number 5 using ehci-pci
> > [   64.477612] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
> > [   64.477618] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
> > SerialNumber=0
> > [   64.477621] usb 1-1.2: Product: USB-PS/2 Optical Mouse
> > [   64.477623] usb 1-1.2: Manufacturer: Logitech
> > [   64.481934] input: Logitech USB-PS/2 Optical Mouse as
> > /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input11
> >

Did this work differently under earlier kernels?

> Thos 3 lines IIRC are important (one line missing above):
> 
> [   62.353997] usb 1-1.2: reset low-speed USB device number 3 using ehci-pci
> [   62.636877] dpm_run_callback(): usb_dev_resume+0x0/0x20 returns -32
> [   62.636893] PM: Device 1-1.2 failed to resume async: error -32
> 
> - Sedat -
> 
> > Any help/hints/infos welcome :-)!

This indicates that the optical mouse didn't survive the suspend/resume
sequence and had to be reenumerated.  Without more information, there's
no way to tell specifically what went wrong during the initial reset at
timestamp 62.353997.

If you want to pursue this farther, you could enable CONFIG_USB_DEBUG.  
You could also collect a usbmon trace for bus 1 showing what happens
during the suspend and resume.

On the other hand, what difference does it really make if a mouse has
to be reenumerated?

Alan Stern

