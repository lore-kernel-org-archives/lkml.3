Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3BVJmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:42:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:13877 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab3BVJmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:42:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,714,1355126400"; 
   d="scan'208";a="205227495"
Message-ID: <51273D78.6020203@intel.com>
Date: Fri, 22 Feb 2013 17:42:16 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
References: <20130221184010.GA24692@kroah.com> <20130222085954.GA4352@redhat.com>
In-Reply-To: <20130222085954.GA4352@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/22 16:59, Dave Jones wrote:
> On Thu, Feb 21, 2013 at 10:40:10AM -0800, Greg KH wrote:
>
>   > USB patches for 3.9-rc1
>   >
>   > Here's the big USB merge for 3.9-rc1
>   >
>   > Nothing major, lots of gadget fixes, and of course, xhci stuff.
>
> I get no USB devices recognised when I insert them any more, which
> I think is pretty major.  I suspect it has something to do with this ?
>
>   > Lan Tianyu (12):
>   >       usb: add runtime pm support for usb port device
>   >       usb: add usb port auto power off mechanism
>
> It looks like every port on my laptop is powered down, as I can't
> even charge devices with it.
>
Hi Dave:
	Do you disable usb port's pm_qos_no_power_off?
	cat /sys/bus/usb/devices/(dev)/port/power/pm_qos_no_power_off

> I tried running powertop, which noted autosuspend for the usb controllers
> was 'good'. I flipped them to 'bad', but it made no difference.
>
> What can I do to debug this ?
Can you attach the output of dmesg with CONFIG_USB_DEBUG?
>
> $ lspci | grep USB
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
>
> $ lsusb
> Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> Bus 001 Device 003: ID 0a5c:21e6 Broadcom Corp. BCM20702 Bluetooth 4.0 [ThinkPad]
> Bus 001 Device 004: ID 5986:02d5 Acer, Inc
>
> (inserted USB devices don't show up in this list)
>
> $ dmesg | grep -i usb
> [    0.996096] ACPI: bus type usb registered
> [    0.996428] usbcore: registered new interface driver usbfs
> [    0.996638] usbcore: registered new interface driver hub
> [    0.996875] usbcore: registered new device driver usb
> [    1.874896] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.876103] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    1.886220] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    1.886781] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.886878] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.887017] usb usb1: Product: EHCI Host Controller
> [    1.887111] usb usb1: Manufacturer: Linux 3.8.0+ ehci_hcd
> [    1.887220] usb usb1: SerialNumber: 0000:00:1a.0
> [    1.888942] hub 1-0:1.0: USB hub found
> [    1.892347] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    1.902216] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    1.902674] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.902770] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.902910] usb usb2: Product: EHCI Host Controller
> [    1.903004] usb usb2: Manufacturer: Linux 3.8.0+ ehci_hcd
> [    1.903098] usb usb2: SerialNumber: 0000:00:1d.0
> [    1.904444] hub 2-0:1.0: USB hub found
> [    1.906795] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.906970] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.908243] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
> [    1.909823] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.909920] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.910060] usb usb3: Product: xHCI Host Controller
> [    1.910153] usb usb3: Manufacturer: Linux 3.8.0+ xhci_hcd
> [    1.910260] usb usb3: SerialNumber: 0000:00:14.0
> [    1.911644] hub 3-0:1.0: USB hub found
> [    1.930176] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
> [    1.930802] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    1.930899] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.931039] usb usb4: Product: xHCI Host Controller
> [    1.931131] usb usb4: Manufacturer: Linux 3.8.0+ xhci_hcd
> [    1.931239] usb usb4: SerialNumber: 0000:00:14.0
> [    1.932568] hub 4-0:1.0: USB hub found
> [    1.950215] usbcore: registered new interface driver usbserial
> [    1.950388] usbcore: registered new interface driver usbserial_generic
> [    1.950612] usbserial: USB Serial support registered for generic
> [    1.950781] usbcore: registered new interface driver usb_debug
> [    1.950959] usbserial: USB Serial support registered for debug
> [    1.972227] usbcore: registered new interface driver usbhid
> [    1.972322] usbhid: USB HID core driver
> [    2.193584] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    2.309836] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    2.309965] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.313198] hub 1-1:1.0: USB hub found
> [    2.436596] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    2.551777] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    2.551906] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.555603] hub 2-1:1.0: USB hub found
> [    2.673812] usb 1-1.4: new full-speed USB device number 3 using ehci-pci
> [    2.754662] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=21e6
> [    2.754791] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    2.754968] usb 1-1.4: Product: BCM20702A0
> [    2.755081] usb 1-1.4: Manufacturer: Broadcom Corp
> [    2.755194] usb 1-1.4: SerialNumber: 689423EB48E2
> [    2.827871] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
> [    2.921573] usb 1-1.6: New USB device found, idVendor=5986, idProduct=02d5
> [    2.921671] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.921820] usb 1-1.6: Product: Integrated Camera
> [    2.921932] usb 1-1.6: Manufacturer: Ricoh Company Ltd.
>
> *after this point, inserting devices made no printk's at all*
>
>
> 	Dave
>

-- 
Best Regards
Tianyu Lan
linux kernel enabling team
