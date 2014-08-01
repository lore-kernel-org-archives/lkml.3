Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaHARQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbaHARQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:16:22 -0400
Message-ID: <1406913373.10668.5.camel@dcbw.local>
Subject: Re: [PATCH] serial/option: Add support for Option GTM671WFS
From: Dan Williams <dcbw@redhat.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Aug 2014 12:16:13 -0500
In-Reply-To: <1406894424-7561-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1406894424-7561-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 14:00 +0200, Ricardo Ribalda Delgado wrote:
> After this patch:
> 
> [    5.389385] usbserial: USB Serial support registered for GSM modem (1-port)
> [    5.390181] option 2-1.4:1.0: GSM modem (1-port) converter detected
> [    5.390556] usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB0
> [    5.390636] option 2-1.4:1.1: GSM modem (1-port) converter detected
> [    5.390935] usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB1
> [    5.391002] option 2-1.4:1.2: GSM modem (1-port) converter detected
> [    5.391258] usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB2
> [    5.391318] option 2-1.4:1.3: GSM modem (1-port) converter detected
> [    5.391650] usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB3
> [    5.391685] option 2-1.4:1.4: GSM modem (1-port) converter detected
> [    5.391895] usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB4
> [    5.391927] option 2-1.4:1.5: GSM modem (1-port) converter detected
> [    5.392076] usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB5
> [    5.392109] option 2-1.4:1.6: GSM modem (1-port) converter detected
> [    5.392278] usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB6
> 
> root@qt5022:~# lsusb -d 0af0: -vvv

Are you 100% sure these don't go into the 'hso' driver?  'option' is
used for mostly older Option devices (like 5+ years old).  I tried to
find information about this module, and the closest I could come for
0af0:9200 was:

http://trac.gateworks.com/wiki/3g

which indicates they might be 'hso' instead.  Can you give that a try?

Dan

> Bus 002 Device 003: ID 0af0:9200 Option
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          255 Vendor Specific Class
>   bDeviceSubClass       255 Vendor Specific Subclass
>   bDeviceProtocol       255 Vendor Specific Protocol
>   bMaxPacketSize0        64
>   idVendor           0x0af0 Option
>   idProduct          0x9200
>   bcdDevice            0.00
>   iManufacturer           3 Option N.V.
>   iProduct                2 Globetrotter HSUPA Modem
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          200
>     bNumInterfaces          8
>     bConfigurationValue     1
>     iConfiguration          1 Option Configuration
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
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
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x04  EP 4 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        4
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x05  EP 5 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        5
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x06  EP 6 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x86  EP 6 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        6
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x87  EP 7 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x88  EP 8 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x07  EP 7 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval              32
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        7
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     80 Bulk-Only
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x08  EP 8 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x89  EP 9 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass          255 Vendor Specific Class
>   bDeviceSubClass       255 Vendor Specific Subclass
>   bDeviceProtocol       255 Vendor Specific Protocol
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0001
>   Self Powered
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/usb/serial/option.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index a968894..48a63b5 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -78,6 +78,7 @@ static void option_instat_callback(struct urb *urb);
>  #define OPTION_PRODUCT_ETNA_MODEM_EX		0x7061
>  #define OPTION_PRODUCT_ETNA_KOI_MODEM		0x7100
>  #define OPTION_PRODUCT_GTM380_MODEM		0x7201
> +#define OPTION_PRODUCT_GLOBETROTTER_MODEM	0x9200
>  
>  #define HUAWEI_VENDOR_ID			0x12D1
>  #define HUAWEI_PRODUCT_E173			0x140C
> @@ -603,6 +604,7 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM_EX) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GTM380_MODEM) },
> +	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GLOBETROTTER_MODEM) },
>  	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_Q101) },
>  	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_Q111) },
>  	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLX) },


