Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaGFBmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 21:42:16 -0400
Received: from mail001.aei.ca ([206.123.6.130]:59945 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGFBmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 21:42:14 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [USB spamming log] with 3.16-rc (git) my pl2303 is spaming my logs
Date: Sat, 05 Jul 2014 21:42:12 -0400
Message-ID: <2692466.FZbUl8jIJM@grover>
Organization: me
User-Agent: KMail/4.13.2 (Linux/3.16.0-1-git; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140705180206.GA828@kroah.com>
References: <1404459477.27680.10.camel@x220> <4878627.a0D3mPHSVv@grover> <20140705180206.GA828@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kernel in question is running on a i7 with a pi connected via to the i6 via the pl2303 to view the pi's console.

The kernel on the i7 is at level:

commit 77c4cf17ae867ba93233b3832bda3de7adaae326
Merge: 88b5a85 133d452
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jul 4 09:37:43 2014 -0700

There is one extra patch applied to fix a problem with the boot stalling
see the patch from Chris Wilson in the thread: [PATCH 5/5] drm/i915: Kick out vga console

Here is a lsusb -v

Bus 001 Device 011: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x067b Prolific Technology, Inc.
  idProduct          0x2303 PL2303 Serial Port
  bcdDevice            3.00
  iManufacturer           1 Prolific Technology Inc.
  iProduct                2 USB-Serial Controller
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

Thanks
Ed

On Saturday 05 July 2014 11:02:06 Greg KH wrote:
> On Sat, Jul 05, 2014 at 10:55:57AM -0400, Ed Tomlinson wrote:
> > Hi
> > 
> > I have a raspberry PI sending its console to my box via a pl2303 
> 
> What exact pl2303 is this?  Can you provide the output from 'lsusb'?
> 
> > [    5.184385] usbserial: USB Serial support registered for pl2303
> > [    5.184398] pl2303 1-2.6:1.0: pl2303 converter detected
> > [    5.185353] usb 1-2.6: pl2303 converter now attached to ttyUSB0
> > 
> > and with the latest fixes from git on 3.16 its now started spamming my logs with: 
> > 
> > [55507.155354] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55510.736558] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55517.238586] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55521.099938] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55521.778520] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55523.229808] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55523.229846] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55525.074519] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> > [55527.270207] pl2303 ttyUSB0: usb_serial_generic_read_bulk_callback - nonzero urb status: -71
> 
> That's saying there was one of the following errors in this device:
>   a) bitstuff error
>   b) no response packet received within the prescribed bus turn-around
>      time
>   c) unknown USB error
> 
> All of which point to either a problem in the USB host controller, or
> the usb device itself.
> 
> Is this an "unpatched" 3.16-rc kernel running on the rpi?  If so, odds
> are it's a host controller issue...
> 
> thanks,
> 
> greg k-h
> 

