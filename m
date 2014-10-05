Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaJEJIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaJEJII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:08:08 -0400
Message-ID: <54310A74.3090404@redhat.com>
Date: Sun, 05 Oct 2014 11:08:04 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: uas: module not loaded automatically
References: <54303DF6.4050203@web.de>
In-Reply-To: <54303DF6.4050203@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/04/2014 08:35 PM, Jan Kiszka wrote:
> Hi,
> 
> my Delock external USB drive stopped working after updating from a
> UAS-disabled distro kernel to latest 3.17-rc7 with UAS on. That UAS was
> key became clear to me only after looking at storage_probe(): the device
> is ignored by usb-storage if it is UAS-capable. However, nothing causes
> uas.ko to be loaded when the drive is plugged here. How is this supposed
> to work in the normal case?

Is the uas.ko module installed, and was depmod run after installing it ?

uas.c has the following:

        { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_BULK) },
        { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_UAS) },

Which should make it load automatically on your device.

Regards,

Hans


> 
> lsusb of the device below.
> 
> Jan
> 
> ---
> 
> Bus 001 Device 009: ID 174c:5136 ASMedia Technology Inc.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x174c ASMedia Technology Inc.
>   idProduct          0x5136
>   bcdDevice            1.00
>   iManufacturer           2 Delock
>   iProduct                3 42514
>   iSerial                 1 200000000CB4
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           85
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xc0
>       Self Powered
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     80 Bulk-Only
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           4
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     98
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>         Data-in pipe (0x03)
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>         Data-out pipe (0x04)
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>         Status pipe (0x02)
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x04  EP 4 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>         Command pipe (0x01)
> Binary Object Store Descriptor:
>   bLength                 5
>   bDescriptorType        15
>   wTotalLength           22
>   bNumDeviceCaps          2
>   USB 2.0 Extension Device Capability:
>     bLength                 7
>     bDescriptorType        16
>     bDevCapabilityType      2
>     bmAttributes   0x00000002
>       Link Power Management (LPM) Supported
>   SuperSpeed USB Device Capability:
>     bLength                10
>     bDescriptorType        16
>     bDevCapabilityType      3
>     bmAttributes         0x00
>     wSpeedsSupported   0x000e
>       Device can operate at Full Speed (12Mbps)
>       Device can operate at High Speed (480Mbps)
>       Device can operate at SuperSpeed (5Gbps)
>     bFunctionalitySupport   1
>       Lowest fully-functional device speed is Full Speed (12Mbps)
>     bU1DevExitLat          10 micro seconds
>     bU2DevExitLat        2047 micro seconds
> Device Status:     0x0001
>   Self Powered
> 
