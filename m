Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaFBQYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:24:51 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:55235 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaFBQYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:24:48 -0400
Message-ID: <538CA54C.4040803@mutualink.net>
Date: Mon, 02 Jun 2014 12:24:44 -0400
From: Mike Remski <mremski@mutualink.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
References: <538C8963.4010909@mutualink.net> <20140602143347.GA1902@localhost> <538C953B.9020304@mutualink.net> <20140602154036.GA8662@localhost> <538CA020.4070204@mutualink.net> <20140602162027.GB13790@localhost>
In-Reply-To: <20140602162027.GB13790@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 12:20 PM, Johan Hovold wrote:
> On Mon, Jun 02, 2014 at 12:02:40PM -0400, Mike Remski wrote:
>> On 06/02/2014 11:40 AM, Johan Hovold wrote:
>>> [ Please avoid top-posting. ]
>>>
>>> On Mon, Jun 02, 2014 at 11:16:11AM -0400, Mike Remski wrote:
>>>> Thanks Johan, that's why I looked at the cross references for ftdi_sio.c
>>>> over on
>>>> http://lxr.free-electrons.com/source/drivers/usb/serial/ftdi_sio.c,
>>>> latest version it's showing is 3.14.  It appears that the ftdi_sio code
>>>> is largely the same as in 2.6.32, particularly in the
>>>> ftdi_set_max_packet_size() function.
>>> Lots of things have changed since v2.6.32 and not just in the driver
>>> itself but in all the infrastructure it relies on.
>>>
>>>> I'm trying to verify if the "number of endpoints is 0" is a valid
>>>> situation.
>>> No, that is not normal, but it should not crash the driver if it's a
>>> hardware issue. What is the lsusb -v output of your device (make sure
>>> the ftdi_sio driver isn't loaded when connecting the device).
>>>
>>> And what happens if you plug it into a machine running a recent kernel?
>>>
>>> Thanks,
>>> Johan
>> Thanks Johan;  sorry for top posting.
>> An even more ancient kernel (2.6.18) has v1.4.3 of the ftdi_sio.c and I
>> do not see this problem.  In v1.4.3,
>> ftdi_sio_attach() is doing the work that is now in
>> ftdi_sio_port_probe(), but 1.4.3 does not have the
>> ftdi_set_max_packet_size() code.  The device works fine under 2.6.18.  I
>> have to see if I can scrounge up
>> a machine running a later kernel (other than my desktop).
> Your desktop should be just fine for testing.
>
>> Should have included this earlier but its unmodified CentOs 6.0 and 6.4,
>> kernel is:
>>
>> Linux nicA91A84 2.6.32-71.29.1.el6.i686 #1 SMP Tue May 10 17:35:05 CDT
>> 2011 i686 i686 i386 GNU/Linux
>>
>>
>> lsusb -v cut for the device in question.
>>
>> Bus 005 Device 003: ID 1fdf:1001
>> Device Descriptor:
>>     bLength                18
>>     bDescriptorType         1
>>     bcdUSB               2.00
>>     bDeviceClass          239 Miscellaneous Device
>>     bDeviceSubClass         2 ?
>>     bDeviceProtocol         1 Interface Association
>>     bMaxPacketSize0        64
>>     idVendor           0x1fdf
>>     idProduct          0x1001
>>     bcdDevice            0.03
>>     iManufacturer           1 Sepura
>>     iProduct                2 Colour Console
>>     iSerial                 0
>>     bNumConfigurations      1
>>     Configuration Descriptor:
>>       bLength                 9
>>       bDescriptorType         2
>>       wTotalLength          134
>>       bNumInterfaces          4
>>       bConfigurationValue     1
>>       iConfiguration          0
>>       bmAttributes         0xc0
>>         Self Powered
>>       MaxPower              100mA
>>       Interface Association:
>>         bLength                 8
>>         bDescriptorType        11
>>         bFirstInterface         0
>>         bInterfaceCount         2
>>         bFunctionClass          2 Communications
>>         bFunctionSubClass       2 Abstract (modem)
> Is this indeed the right device? Then you seem to be using the wrong
> driver as this is no FTDI device, but a CDC-ACM modem-class device which
> should be driven by the cdc-acm driver.
>
>>         bFunctionProtocol       0 None
>>         iFunction               0
>>       Interface Descriptor:
>>         bLength                 9
>>         bDescriptorType         4
>>         bInterfaceNumber        0
>>         bAlternateSetting       0
>>         bNumEndpoints           1
>>         bInterfaceClass         2 Communications
>>         bInterfaceSubClass      2 Abstract (modem)
>>         bInterfaceProtocol      0 None
>>         iInterface              0
>>         CDC Header:
>>           bcdCDC               1.10
>>         CDC Call Management:
>>           bmCapabilities       0x01
>>             call management
>>           bDataInterface          1
>>         CDC ACM:
>>           bmCapabilities       0x02
>>             line coding and serial state
>>         CDC Union:
>>           bMasterInterface        0
>>           bSlaveInterface         1
>>         Endpoint Descriptor:
>>           bLength                 7
>>           bDescriptorType         5
>>           bEndpointAddress     0x83  EP 3 IN
>>           bmAttributes            3
>>             Transfer Type            Interrupt
>>             Synch Type               None
>>             Usage Type               Data
>>           wMaxPacketSize     0x0040  1x 64 bytes
>>           bInterval              10
>>       Interface Descriptor:
>>         bLength                 9
>>         bDescriptorType         4
>>         bInterfaceNumber        1
>>         bAlternateSetting       0
>>         bNumEndpoints           2
>>         bInterfaceClass        10 CDC Data
>>         bInterfaceSubClass      0 Unused
>>         bInterfaceProtocol      0
>>         iInterface              0
>>         Endpoint Descriptor:
>>           bLength                 7
>>           bDescriptorType         5
>>           bEndpointAddress     0x01  EP 1 OUT
>>           bmAttributes            2
>>             Transfer Type            Bulk
>>             Synch Type               None
>>             Usage Type               Data
>>           wMaxPacketSize     0x0040  1x 64 bytes
>>           bInterval               0
>>         Endpoint Descriptor:
>>           bLength                 7
>>           bDescriptorType         5
>>           bEndpointAddress     0x82  EP 2 IN
>>           bmAttributes            2
>>             Transfer Type            Bulk
>>             Synch Type               None
>>             Usage Type               Data
>>           wMaxPacketSize     0x0040  1x 64 bytes
>>           bInterval               0
>>       Interface Association:
>>         bLength                 8
>>         bDescriptorType        11
>>         bFirstInterface         2
>>         bInterfaceCount         2
>>         bFunctionClass          2 Communications
>>         bFunctionSubClass       2 Abstract (modem)
>>         bFunctionProtocol       0 None
>>         iFunction               0
>>       Interface Descriptor:
>>         bLength                 9
>>         bDescriptorType         4
>>         bInterfaceNumber        2
>>         bAlternateSetting       0
>>         bNumEndpoints           0
> The third interface lacks endpoints and crashes the ftdi_sio driver.
> This shouldn't happen (even if you're forcing the wrong driver to bind),
> so I'll fix it up if still broken in v3.15-rc.
>
> Thanks,
> Johan
Johan,
Thanks again.  Yes, the device does indeed have an FTDI embedded in it;  
they've programmed in their own ids.  They supply a Windows driver for 
it, but that doesn't do me any good.  :)

I will work on getting a later version set up for testing.  May not 
happen today but as soon as possible.


-- 
Office: (978)401-4032 (x123 internally)
Cell: (603) 759-6953

