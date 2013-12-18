Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3LRKSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:18:13 -0500
Received: from sam.nabble.com ([216.139.236.26]:32911 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3LRKSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:18:11 -0500
Date: Wed, 18 Dec 2013 02:18:10 -0800 (PST)
From: "gerald.maricau@gmail.com" <gerald.maricau@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1387361890424-773917.post@n7.nabble.com>
Subject: Adding supprot for Bluetooth 0x13d3, 0x3404 "BCM20702A0" on asus
 G750JX
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using linux OpenSuse 13.1 with kernel 3.11 on the Asus ROG G750JX-T4215H
machine:
# uname -r
3.11.6-4-desktop

It's hard to find something about this bluetooth device but finally i found
some patch for the same device BCM20702A0 on another hardware but on this
computer Asus P8Z77-V Deluxe : 
http://blog.tkassembled.com/301/patching-btusb-to-enable-compatibility-with-the-bcm20702a0-chip/
http://linux-kernel.2935.n7.nabble.com/PATCH-Bluetooth-Add-support-for-BCM20702A0-0b05-17b5-td195933.html

I found that this bluetooth is integrated but connected to the USB-hub ! And
after adding the following line to drivers/bluetooth/btusb.c and recompiling
it and using it (# modprobe btusb), the device is now enabled
{ USB_DEVICE(0x13d3, 0x3404) }, /*on ASUS G750JX vendor INC*/

# hwinfo --usb (BCM207702A0 part)
34: USB 00.0: 0000 Unclassified device
  [Created at usb.122]
  Unique ID: 4zpN.FVG0jOcmIlA
  Parent ID: uIhY.2DFUsyrieMD
  SysFS ID: /devices/pci0000:00/0000:00:14.0/usb3/3-5/3-5:1.0
  SysFS BusID: 3-5:1.0
  Hardware Class: unknown
  Model: "IMC Networks BCM20702A0"
  Hotplug: USB
  Vendor: usb 0x13d3 "IMC Networks"
  Device: usb 0x3404 "BCM20702A0"
  Revision: "1.12"
  Serial ID: "240A6439A913"
  Driver: "btusb"
  Driver Modules: "btusb"
  Speed: 12 Mbps
  Module Alias: "usb:v13D3p3404d0112dcFFdsc01dp01icFFisc01ip01in00"
  Driver Info #0:
    Driver Status: btusb is active
    Driver Activation Cmd: "modprobe btusb"
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #30 (Hub)

QUESTIONS:
Do i have to make other actions to enable the device completely ?
I don't know how to make the patch file for what i did, if somebody can do
it or explain me how to do it, i have enough aknowledge in system admin to
do it.

Because it's enabled with the applet bluedevil integrated in kde4 but i
can't connect to the desired device (mouse with bluetooth Razer Orochi 2013)

# hwinfo --mouse (part of the specified mouse)
29: USB 00.0: 10503 USB Mouse                                   
  [Created at usb.122]
  Unique ID: CiZ2.17e4hJ8gaGB
  Parent ID: uIhY.2DFUsyrieMD
  SysFS ID: /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.0
  SysFS BusID: 3-3:1.0
  Hardware Class: mouse
  Model: "Razer Orochi 2013"
  Hotplug: USB
  Vendor: usb 0x1532 "Razer"
  Device: usb 0x0039 "Razer Orochi 2013"
  Revision: "2.00"
  Compatible to: int 0x0210 0x0018
  Driver: "usbhid"
  Driver Modules: "usbhid"
  Device File: /dev/input/mice (/dev/input/mouse1)
  Device Files: /dev/input/mice, /dev/input/mouse1, /dev/input/event2,
/dev/input/by-id/usb-Razer_Razer_Orochi_2013-event-mouse,
/dev/input/by-path/pci-0000:00:14.0-usb-0:3:1.0-event-mouse,
/dev/input/by-id/usb-Razer_Razer_Orochi_2013-mouse,
/dev/input/by-path/pci-0000:00:14.0-usb-0:3:1.0-mouse
  Device Number: char 13:63 (char 13:33)
  Speed: 12 Mbps
  Module Alias: "usb:v1532p0039d0200dc00dsc00dp00ic03isc01ip02in00"
  Driver Info #0:
    Buttons: 8
    Wheels: 1
    XFree86 Protocol: explorerps/2
    GPM Protocol: exps2
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #27 (Hub)

Thanks in advance for your help.

Regards,



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/Adding-supprot-for-Bluetooth-0x13d3-0x3404-BCM20702A0-on-asus-G750JX-tp773917.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
