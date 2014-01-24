Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaAXNrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:47:12 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:53519 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaAXNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:47:08 -0500
MIME-Version: 1.0
Date: Fri, 24 Jan 2014 08:47:07 -0500
X-Google-Sender-Auth: oOHg_f-rE7hfEupImSE2rbngSNo
Message-ID: <CA+5PVA7P=3b6oGG4pwR-q-Uy+V2hu5N-f5-fO4NdsB8ytvLz7w@mail.gmail.com>
Subject: Odd 'unable to find transceiver' messages from USB with
 v3.13-3260-g03d11a0 and later
From: Josh Boyer <jwboyer@fedoraproject.org>
To: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a report [1] of the USB layer throwing out 'unable to find
transceiver' messages during boot with the 3.14 merge window kernels.
I've seen this on my personal machine as well and included the dmesg
section below.  This does not happen with the 3.13 kernel.

There are only a handful of files in git that have that error, but I
haven't seen anything that immediately strikes me as causing this.
>From the dmesg output it looks like it is spit out right before a host
controller is registered?  USB seems to be still working OK in my
minimal testing, so the error message is confusing.

Thoughts?

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1057529

josh

[    1.683368] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.683386] ehci-pci: EHCI PCI platform driver
[    1.684765] unable to find transceiver
[    1.684993] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.685772] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    1.685847] ehci-pci 0000:00:1a.0: debug port 2
[    1.689837] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.689976] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfe707000
[    1.695158] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.695721] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.695722] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.695724] usb usb1: Product: EHCI Host Controller
[    1.695725] usb usb1: Manufacturer: Linux
3.14.0-0.rc0.git7.1.fc21.x86_64 ehci_hcd
[    1.695726] usb usb1: SerialNumber: 0000:00:1a.0
[    1.697752] hub 1-0:1.0: USB hub found
[    1.697872] hub 1-0:1.0: 2 ports detected
[    1.701620] unable to find transceiver
[    1.701847] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.702424] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    1.702458] ehci-pci 0000:00:1d.0: debug port 2
[    1.706417] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.706538] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe706000
[    1.712160] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
