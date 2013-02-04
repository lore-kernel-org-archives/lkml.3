Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3BDBwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:52:10 -0500
Received: from host171.canaca.com ([67.55.55.225]:44461 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3BDBwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:52:07 -0500
Message-ID: <baf3c18e7f60ca8fd5086abf4e5c01b1.squirrel@mungewell.org>
Date: Sun, 3 Feb 2013 20:52:04 -0500
Subject: [Fwd: Re: [PATCH 1/3] hid: Add report descriptor for Logitech
 Driving Force wheel]
From: simon@mungewell.org
To: "Paul Sbarra" <sbarra.paul@gmail.com>, jkosina@suse.cz,
        simon@mungewell.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20130203205204_67920"
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20130203205204_67920
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Resending as I missed adding linux-input to the receiptants,
Simon

---------------------------- Original Message ----------------------------
Subject: Re: [PATCH 1/3] hid: Add report descriptor for Logitech Driving
Force wheel
From:    simon@mungewell.org
Date:    Sun, February 3, 2013 8:30 pm
To:      "Paul Sbarra" <sbarra.paul@gmail.com>
Cc:      simon@mungewell.org
--------------------------------------------------------------------------

>> Interesting, I hadn't realized the newer models were also reporting with
> that product id.  I suppose that's going to add some complexity, but at
> least the background helps explain that chunk of code.
>
>
>> So a couple of questions:
>> 1) Are you sure you have a "Driving Force"?
>
> Yes.

There is another detail which 'we' previously decided; that when a 900
degree wheel was left in simple (1st connect) mode we would leave the
acc/brake combined.

This would happen if 'lg4ff' was not enabled, or the wheel was not
recognized for the 'special' command. (Note the special command causes the
wheel rotation to be unlocked to the full 900 degrees).

This obviously is not appropriate for your wheel and patching the report
descriptor will need to be done. I'd just like to ensure that we're not
breaking another wheel in the process.

Rather than using just the USBID and the size, can we also check the BCD
revision number before patching the report descriptor - similar to what we
do in lg4ff to decide what magic command to use?
ie.
--
udesc = &(hid_to_usb_dev(hid)->descriptor);
bcdDevice = le16_to_cpu(udesc->bcdDevice);
rev_maj = bcdDevice >> 8;
rev_min = bcdDevice & 0xff;
--

I've attached the report descriptor and lsusb for the DFP and DFW, which
both show a combine acc/brake in this mode. I won't have access to my G27
till midweek.

Q. In 'simple' mode should all wheels present a seperate acc and brake
(when they can)?

My DFW wheel is broken, so I can't test patching that descriptor... but if
anyone else has this wheel I can provide code to test.

>
> 2) Does the ForceFeedback work for you?
>>
>
> I'm unsure of the best way to test FF

Since we are using 'ffmemless' we're limited to constant force, although
other modes are know. It'll be a lot of work to move away from ffmemless,
for not much gain and I suspect very few games support the other modes.

You can confirm operation with 'ffcfstress'.

Cheers,
Simon.

------=_20130203205204_67920
Content-Type: text/plain; name="lsusb_dfw_pre.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="lsusb_dfw_pre.txt"

Bus 003 Device 004: ID 046d:c294 Logitech, Inc. Driving Force
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc294 Driving Force
  bcdDevice           22.01
  iManufacturer           0 
  iProduct                2 PS3/USB Cordless Wheel
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           41
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower               56mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     137
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0007  1x 7 bytes
        bInterval               2
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0007  1x 7 bytes
        bInterval               2
Device Status:     0x0000
  (Bus Powered)
------=_20130203205204_67920
Content-Type: text/plain; name="descriptor_dfw_pre.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="descriptor_dfw_pre.txt"

00000000  05 01 09 04 a1 01 a1 02  95 01 75 0a 15 00 26 ff  |..........u...&.|
00000010  03 35 00 46 ff 03 09 30  81 02 95 0c 75 01 25 01  |.5.F...0....u.%.|
00000020  45 01 05 09 19 01 29 0c  81 02 95 02 06 00 ff 09  |E.....).........|
00000030  01 81 02 05 01 09 31 26  ff 00 46 ff 00 95 01 75  |......1&..F....u|
00000040  08 81 02 25 07 46 3b 01  75 04 65 14 09 39 81 42  |...%.F;.u.e..9.B|
00000050  75 01 95 04 65 00 06 00  ff 09 01 25 01 45 01 81  |u...e......%.E..|
00000060  02 95 02 75 08 26 ff 00  46 ff 00 09 02 81 02 c0  |...u.&..F.......|
00000070  a1 02 26 ff 00 46 ff 00  95 07 75 08 09 03 91 02  |..&..F....u.....|
00000080  c0 0a ff ff 95 08 b1 02  c0                       |.........|
00000089
------=_20130203205204_67920
Content-Type: text/plain; name="jstest_dfw_pre.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="jstest_dfw_pre.txt"

RHJpdmVyIHZlcnNpb24gaXMgMi4xLjAuCkpveXN0aWNrIChQUzMvVVNCIENvcmRsZXNzIFdoZWVs
KSBoYXMgNCBheGVzIChYLCBZLCBIYXQwWCwgSGF0MFkpCmFuZCAxMiBidXR0b25zIChUcmlnZ2Vy
LCBUaHVtYkJ0biwgVGh1bWJCdG4yLCBUb3BCdG4sIFRvcEJ0bjIsIFBpbmtpZUJ0biwgQmFzZUJ0
biwgQmFzZUJ0bjIsIEJhc2VCdG4zLCBCYXNlQnRuNCwgQmFzZUJ0bjUsIEJhc2VCdG42KS4KVGVz
dGluZyAuLi4gKGludGVycnVwdCB0byBleGl0KQoNQXhlczogIDA6ICAgICAwICAxOiAgICAgMCAg
MjogICAgIDAgIDM6ICAgICAwIEJ1dHRvbnM6ICAwOm9mZiAgMTpvZmYgIDI6b2ZmICAzOm9mZiAg
NDpvZmYgIDU6b2ZmICA2Om9mZiAgNzpvZmYgIDg6b2ZmICA5Om9mZiAxMDpvZmYgMTE6b2ZmIA1B
eGVzOiAgMDogICAgIDAgIDE6ICAgICAwICAyOiAgICAgMCAgMzogICAgIDAgQnV0dG9uczogIDA6
b2ZmICAxOm9mZiAgMjpvZmYgIDM6b2ZmICA0Om9mZiAgNTpvZmYgIDY6b2ZmICA3Om9mZiAgODpv
ZmYgIDk6b2ZmIDEwOm9mZiAxMTpvZmYgDUF4ZXM6ICAwOiAgICAgMCAgMTogICAgIDAgIDI6ICAg
ICAwICAzOiAgICAgMCBCdXR0b25zOiAgMDpvZmYgIDE6b2ZmICAyOm9mZiAgMzpvZmYgIDQ6b2Zm
ICA1Om9mZiAgNjpvZmYgIDc6b2ZmICA4Om9mZiAgOTpvZmYgMTA6b2ZmIDExOm9mZiANQXhlczog
IDA6ICAgICAwICAxOiAgICAgMCAgMjogICAgIDAgIDM6ICAgICAwIEJ1dHRvbnM6ICAwOm9mZiAg
MTpvZmYgIDI6b2ZmICAzOm9mZiAgNDpvZmYgIDU6b2ZmICA2Om9mZiAgNzpvZmYgIDg6b2ZmICA5
Om9mZiAxMDpvZmYgMTE6b2ZmIA1BeGVzOiAgMDogICAgIDAgIDE6ICAgICAwICAyOiAgICAgMCAg
MzogICAgIDAgQnV0dG9uczogIDA6b2ZmICAxOm9mZiAgMjpvZmYgIDM6b2ZmICA0Om9mZiAgNTpv
ZmYgIDY6b2ZmICA3Om9mZiAgODpvZmYgIDk6b2ZmIDEwOm9mZiAxMTpvZmYgDUF4ZXM6ICAwOiAg
ICAgMCAgMTogICAgIDAgIDI6ICAgICAwICAzOiAgICAgMCBCdXR0b25zOiAgMDpvZmYgIDE6b2Zm
ICAyOm9mZiAgMzpvZmYgIDQ6b2ZmICA1Om9mZiAgNjpvZmYgIDc6b2ZmICA4Om9mZiAgOTpvZmYg
MTA6b2ZmIDExOm9mZiANQXhlczogIDA6ICAgICAwICAxOiAgICAgMCAgMjogICAgIDAgIDM6ICAg
ICAwIEJ1dHRvbnM6ICAwOm9mZiAgMTpvZmYgIDI6b2ZmICAzOm9mZiAgNDpvZmYgIDU6b2ZmICA2
Om9mZiAgNzpvZmYgIDg6b2ZmICA5Om9mZiAxMDpvZmYgMTE6b2ZmIA1BeGVzOiAgMDogICAgIDAg
IDE6ICAgICAwICAyOiAgICAgMCAgMzogICAgIDAgQnV0dG9uczogIDA6b2ZmICAxOm9mZiAgMjpv
ZmYgIDM6b2ZmICA0Om9mZiAgNTpvZmYgIDY6b2ZmICA3Om9mZiAgODpvZmYgIDk6b2ZmIDEwOm9m
ZiAxMTpvZmYgDUF4ZXM6ICAwOiAgICAgMCAgMTogICAgIDAgIDI6ICAgICAwICAzOiAgICAgMCBC
dXR0b25zOiAgMDpvZmYgIDE6b2ZmICAyOm9mZiAgMzpvZmYgIDQ6b2ZmICA1Om9mZiAgNjpvZmYg
IDc6b2ZmICA4Om9mZiAgOTpvZmYgMTA6b2ZmIDExOm9mZiANQXhlczogIDA6ICAgICAwICAxOiAg
ICAgMCAgMjogICAgIDAgIDM6ICAgICAwIEJ1dHRvbnM6ICAwOm9mZiAgMTpvZmYgIDI6b2ZmICAz
Om9mZiAgNDpvZmYgIDU6b2ZmICA2Om9mZiAgNzpvZmYgIDg6b2ZmICA5Om9mZiAxMDpvZmYgMTE6
b2ZmIA1BeGVzOiAgMDogICAgIDAgIDE6ICAgICAwICAyOiAgICAgMCAgMzogICAgIDAgQnV0dG9u
czogIDA6b2ZmICAxOm9mZiAgMjpvZmYgIDM6b2ZmICA0Om9mZiAgNTpvZmYgIDY6b2ZmICA3Om9m
ZiAgODpvZmYgIDk6b2ZmIDEwOm9mZiAxMTpvZmYgDUF4ZXM6ICAwOiAgICAgMCAgMTogICAgIDAg
IDI6ICAgICAwICAzOiAgICAgMCBCdXR0b25zOiAgMDpvZmYgIDE6b2ZmICAyOm9mZiAgMzpvZmYg
IDQ6b2ZmICA1Om9mZiAgNjpvZmYgIDc6b2ZmICA4Om9mZiAgOTpvZmYgMTA6b2ZmIDExOm9mZiAN
QXhlczogIDA6LTMyNzY3ICAxOiAgICAgMCAgMjogICAgIDAgIDM6ICAgICAwIEJ1dHRvbnM6ICAw
Om9mZiAgMTpvZmYgIDI6b2ZmICAzOm9mZiAgNDpvZmYgIDU6b2ZmICA2Om9mZiAgNzpvZmYgIDg6
b2ZmICA5Om9mZiAxMDpvZmYgMTE6b2ZmIA1BeGVzOiAgMDotMzI3NjcgIDE6LTMyNzY3ICAyOiAg
ICAgMCAgMzogICAgIDAgQnV0dG9uczogIDA6b2ZmICAxOm9mZiAgMjpvZmYgIDM6b2ZmICA0Om9m
ZiAgNTpvZmYgIDY6b2ZmICA3Om9mZiAgODpvZmYgIDk6b2ZmIDEwOm9mZiAxMTpvZmYgDUF4ZXM6
ICAwOi0zMjc2NyAgMTotMzI3NjcgIDI6ICAgICAwICAzOiAgICAgMCBCdXR0b25zOiAgMDpvZmYg
IDE6b2ZmICAyOm9mZiAgMzpvZmYgIDQ6b2ZmICA1Om9mZiAgNjpvZmYgIDc6b2ZmICA4Om9mZiAg
OTpvZmYgMTA6b2ZmIDExOm9mZiANQXhlczogIDA6LTMyNzY3ICAxOi0zMjc2NyAgMjogICAgIDAg
IDM6ICAgICAwIEJ1dHRvbnM6ICAwOm9mZiAgMTpvZmYgIDI6b2ZmICAzOm9mZiAgNDpvZmYgIDU6
b2ZmICA2Om9mZiAgNzpvZmYgIDg6b2ZmICA5Om9mZiAxMDpvZmYgMTE6b2ZmIA1BeGVzOiAgMDog
ICAgIDAgIDE6LTMyNzY3ICAyOiAgICAgMCAgMzogICAgIDAgQnV0dG9uczogIDA6b2ZmICAxOm9m
ZiAgMjpvZmYgIDM6b2ZmICA0Om9mZiAgNTpvZmYgIDY6b2ZmICA3Om9mZiAgODpvZmYgIDk6b2Zm
IDEwOm9mZiAxMTpvZmYgDUF4ZXM6ICAwOiAgICAgMCAgMTogICAgIDAgIDI6ICAgICAwICAzOiAg
ICAgMCBCdXR0b25zOiAgMDpvZmYgIDE6b2ZmICAyOm9mZiAgMzpvZmYgIDQ6b2ZmICA1Om9mZiAg
NjpvZmYgIDc6b2ZmICA4Om9mZiAgOTpvZmYgMTA6b2ZmIDExOm9mZiA=
------=_20130203205204_67920
Content-Type: text/plain; name="descriptor_dfp_pre.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="descriptor_dfp_pre.txt"

00000000  05 01 09 04 a1 01 a1 02  95 01 75 0a 15 00 26 ff  |..........u...&.|
00000010  03 35 00 46 ff 03 09 30  81 02 95 0c 75 01 25 01  |.5.F...0....u.%.|
00000020  45 01 05 09 19 01 29 0c  81 02 95 02 06 00 ff 09  |E.....).........|
00000030  01 81 02 05 01 09 31 26  ff 00 46 ff 00 95 01 75  |......1&..F....u|
00000040  08 81 02 25 07 46 3b 01  75 04 65 14 09 39 81 42  |...%.F;.u.e..9.B|
00000050  75 01 95 04 65 00 06 00  ff 09 01 25 01 45 01 81  |u...e......%.E..|
00000060  02 95 02 75 08 26 ff 00  46 ff 00 09 02 81 02 c0  |...u.&..F.......|
00000070  a1 02 26 ff 00 46 ff 00  95 07 75 08 09 03 91 02  |..&..F....u.....|
00000080  c0 c0                                             |..|
00000082
------=_20130203205204_67920
Content-Type: text/plain; name="lsusb_dfp_pre.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="lsusb_dfp_pre.txt"

Bus 003 Device 004: ID 046d:c294 Logitech, Inc. Driving Force
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc294 Driving Force
  bcdDevice           11.06
  iManufacturer           3 Logitech
  iProduct                1 Logitech Driving Force
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           41
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xc0
      Self Powered
    MaxPower               80mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.00
          bCountryCode           33 US
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     130
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0001
  Self Powered
------=_20130203205204_67920--


