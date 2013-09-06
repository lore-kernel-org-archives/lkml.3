Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3IFU1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:27:06 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:40362 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3IFU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:27:04 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2013 16:27:03 EDT
Date: Fri, 6 Sep 2013 22:20:22 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
Message-ID: <20130906202022.GA353@x4>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.09.06 at 14:00 +0200, Jiri Kosina wrote:
> 
> David Herrmann (12):
...
>       HID: wiimote: add support for Guitar-Hero drums

 commit 61e00655e9cb82e034eb72b95a51072e718d14a7
 Author: David Herrmann <dh.herrmann@gmail.com>
 Date:   Mon Aug 26 19:14:46 2013 +0200

     Input: introduce BTN/ABS bits for drums and guitars

The commit above breaks my Logitech mouse. The mouse cursor just sits in
the middle of the screen and doesn't react to movements. dmesg is
normal, but Xorg.0.log says:

[     5.717] (II) config/udev: Adding input device Logitech Unifying Device. Wireless PID:4026 (/dev/input/event0)
[     5.717] (**) Logitech Unifying Device. Wireless PID:4026: Applying InputClass "evdev pointer catchall"
[     5.717] (**) Logitech Unifying Device. Wireless PID:4026: Applying InputClass "evdev keyboard catchall"
[     5.717] (II) Using input driver 'evdev' for 'Logitech Unifying Device. Wireless PID:4026'
[     5.717] (**) Logitech Unifying Device. Wireless PID:4026: always reports core events
[     5.717] (**) evdev: Logitech Unifying Device. Wireless PID:4026: Device: "/dev/input/event0"
[     5.717] (EE) evdev: Logitech Unifying Device. Wireless PID:4026: ioctl EVIOCGABSi(32) failed: Invalid argument
[     5.763] (EE) PreInit returned 8 for "Logitech Unifying Device. Wireless PID:4026"
[     5.763] (II) UnloadModule: "evdev"
[     5.763] (II) config/udev: Adding input device Logitech Unifying Device. Wireless PID:4026 (/dev/input/mouse0)
[     5.763] (II) No input driver specified, ignoring this device.
[     5.763] (II) This device may have been added with another device file.

I've double-checked the bisection by reverting the commit on top of
current tree and this fixes the issue...

>From dmesg:
[    1.551437] XFS (sda): Mounting Filesystem
[    1.555823] tsc: Refined TSC clocksource calibration: 3210.826 MHz
[    1.729233] usb 4-2: new full-speed USB device number 2 using ohci-pci
[    1.857691] XFS (sda): Ending clean mount
[    1.915581] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
[    1.920263] input: Logitech Unifying Device. Wireless PID:4026 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.2/0003:046D:C52B.0003/input/input0
[    1.920479] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4026] on usb-0000:00:12.1-2:1
[    2.042641] usb 3-1: new low-speed USB device number 2 using ohci-pci
[    2.204791] input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input1
[    2.204975] hid-generic 0003:046A:0011.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
[    2.341424] udevd[98]: starting eudev version 1.0
[    2.556172] Switched to clocksource tsc
[    2.791794] ATL1E 0000:02:00.0 eth0: NIC Link is Up <1000 Mbps Full Duplex>
[    3.945433] Adding 3071996k swap on /var/cache/swapfile.img.  Priority:-1 extents:1 across:3071996k 

-- 
Markus
