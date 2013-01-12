Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3ALHtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 02:49:22 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58805 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3ALHtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 02:49:20 -0500
MIME-Version: 1.0
In-Reply-To: <CALxABCYMC71rvWeoZ_cW+WHbXRibShuRh1U5A+0WEB-nt2uxHw@mail.gmail.com>
References: <CALxABCYMC71rvWeoZ_cW+WHbXRibShuRh1U5A+0WEB-nt2uxHw@mail.gmail.com>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Sat, 12 Jan 2013 08:48:59 +0100
Message-ID: <CALxABCau65Zm6qWQCgH+2_4SkojxFPbwwGwytCsiWyyq8bwnRw@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: linux-usb@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:04 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> Hi,
>
> the USB stick (an Cruzer Titanium 2GB) was not recognized at any of
> the USB ports of this system (an System76 lemu4 laptop, XHCI device)
> after it was removed. If I attempt to insert it again in any of the
> ports (one of the two USB3, or the USB2) the led on the stick lights
> up shortly and if off again. There is no media detection messages in
> the dmesg output, only that from the first time:
>
>  usb 1-1.2: new high-speed USB device number 3 using ehci-pci
>  usb 1-1.2: New USB device found, idVendor=0781, idProduct=5408
>  usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>  usb 1-1.2: Product: U3 Titanium
>  usb 1-1.2: Manufacturer: SanDisk Corporation
>  usb 1-1.2: SerialNumber: 0000187A3A60F1E9
>  scsi6 : usb-storage 1-1.2:1.0
>  io scheduler deadline registered (default)
>  usb 1-1.2: USB disconnect, device number 3
>
> The kernel is v3.8-rc3. I never had this problem in 3.7. I could almost
> reproduce the problem later in a simplified setup (init=/bin/bash) on
> USB3 ports by inserting and removing the stick quickly. Almost - because
> the USB3 ports recovered after some time, while the USB2 port never
> experienced the problem.

One more detail: I usually use the "noop" elevator. That time it was
the "deadline". And I just reproduced it easily with "deadline".
