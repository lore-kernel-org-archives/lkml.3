Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab3GWIq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:46:58 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:48060 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3GWIqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAO4LoOydyJrgaAZmc_K2f4avuOfs+5BvQcGpWFZVf8ki8=-y9w@mail.gmail.com>
References: <CAO4LoOyW39zCnGq_fnQ5LK9sXD8s3x9LdYvvRMZ=AwfoyaOHqw@mail.gmail.com>
	<CAAfyv36tJ3bF-uTTd8yqs-4eCJUV6Pz9Acz3pD-VESwTBrSHOQ@mail.gmail.com>
	<CAO4LoOydyJrgaAZmc_K2f4avuOfs+5BvQcGpWFZVf8ki8=-y9w@mail.gmail.com>
Date: Tue, 23 Jul 2013 10:46:49 +0200
Message-ID: <CAAfyv34aEL4mna1jDOg7md9UfWES1W_FEFdM_s1TJ5SY-+TsGA@mail.gmail.com>
Subject: Re: Unsupported DisplayLink (udl or udlfb module)
From: Belisko Marek <marek.belisko@gmail.com>
To: Paolo Bolzoni <paolo.bolzoni.brown@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:15 AM, Paolo Bolzoni
<paolo.bolzoni.brown@gmail.com> wrote:
> On Mon, Jul 22, 2013 at 10:07 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
>>> But, it does not matter what of the two modules I have loaded it
>>> seems the kernel does not recognize it
>> Matching is done by VID = 0x17e9 which seem match but then by
>> bInterfaceClass = 0xff, bInterfaceSubClass = 0x00 and bInterfaceProtocol = 0x00.
>> Can you please post lsusb -v to check what are other parameters for your device.
> Sure thing, I appended the output at the end of the email because it
> is a little long.
>
> Please if you answer put my address paolo.bolzoni.brown@gmail.com in
> CC as I did not register to the mailing list.
>
> Your sincerely,
> Paolo
>
>
> Here is the lsusb -v output about my DisplayLink:
Can you please try following patch:
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index d2e5bc3..a9c96f4 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -64,6 +64,16 @@ static struct usb_device_id id_table[] = {
                USB_DEVICE_ID_MATCH_INT_SUBCLASS |
                USB_DEVICE_ID_MATCH_INT_PROTOCOL,
        },
+       {.idVendor = 0x17e9,
+        .bInterfaceClass = 0xff,
+        .bInterfaceSubClass = 0x00,
+        .bInterfaceProtocol = 0x03,
+        .match_flags = USB_DEVICE_ID_MATCH_VENDOR |
+               USB_DEVICE_ID_MATCH_INT_CLASS |
+               USB_DEVICE_ID_MATCH_INT_SUBCLASS |
+               USB_DEVICE_ID_MATCH_INT_PROTOCOL,
+
+       },
        {},
 };
 MODULE_DEVICE_TABLE(usb, id_table);

>
> Bus 003 Device 002: ID 17e9:4300 DisplayLink
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               3.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0         9
>   idVendor           0x17e9 DisplayLink
>   idProduct          0x4300
>   bcdDevice            2.36
>   iManufacturer           1
>   iProduct                2
>   iSerial                 3
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          103
>     bNumInterfaces          2
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              126mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      3
>       iInterface              0
>       ** UNRECOGNIZED:  0c 5f 01 00 0a 00 04 04 01 00 04 00
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval               5
>         bMaxBurst               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass       254 Application Specific Interface
>       bInterfaceSubClass      1 Device Firmware Update
>       bInterfaceProtocol      1
>       iInterface              0
>
>       Device Firmware Upgrade Interface Descriptor:
>         bLength                             9
>         bDescriptorType                    33
>         bmAttributes                        1
>           Will Not Detach
>           Manifestation Intolerant
>           Upload Unsupported
>           Download Supported
>         wDetachTimeout                    200 milliseconds
>         wTransferSize                    1024 bytes
>         bcdDFUVersion                   1.01
>       ** UNRECOGNIZED:  10 40 06 01 09 01 01 03 45 6c 6c 61 44 6f 63 6b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

marek

--
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
