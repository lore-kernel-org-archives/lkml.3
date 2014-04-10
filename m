Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbaDJOkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:40:03 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:63585 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065AbaDJOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:39:59 -0400
X-AuditID: cbfec372-b7fa96d000006a7b-da-5346ad3ef0f0
Date: Thu, 10 Apr 2014 11:39:49 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: shuah.kh@samsung.com, Greg KH <gregkh@linuxfoundation.org>, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
Message-id: <20140410113949.7de1312b@samsung.com>
In-reply-to: <20140410124653.64aeb06d@alan.etchedpixels.co.uk>
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <20140409191740.GA10748@kroah.com> <5345CD32.8010305@samsung.com>
 <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
 <20140410083841.488f9c43@samsung.com>
 <20140410124653.64aeb06d@alan.etchedpixels.co.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/hIF27tW7BBov+SFpMmvKXzaJ58Xo2
	i8u75rBZ9GzYymrxZOEZJovHK96yW3z5zGXx9aeDxa/lRxkttt1ayOLA5bFz1l12j13bdjJ5
	LN7zkslj06pONo/9c9ewe7Se3MTqsfN7A7tH35ZVjB6fN8kFcEZx2aSk5mSWpRbp2yVwZZz/
	+Y2tYIV2xeclHawNjBuVuxg5OSQETCQ+XVvABmGLSVy4tx7I5uIQEljCKHHj6VUWCKePSeJP
	/0ZGkCoWAVWJm1u2g3WwCRhJvGpsYQWxRYAmNb96zQjSwCzwhFFi988LYAlhARuJ/deusIDY
	vAKGEgt/dYM1cwrYScw+2A61rptJomfBcXaIO5wkXr2ezATRICjxY/I9sGZmAS2JzduaWCFs
	eYnNa94yT2AUmIWkbBaSsllIyhYwMq9iFC0tTi4oTkrPNdQrTswtLs1L10vOz93ECImWoh2M
	zzZYHWIU4GBU4uE9sMw1WIg1say4MvcQowQHs5II78apbsFCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGAWOFy8JyRMRPVfadphDb8GNbzIyvTMO22b79qtyFxQVPZmhzHFZl6uu2oe3rvncuilH
	97Or914O2v6Ae6c7f2PeJ1f1KZdbmf4sD4qP3xXbxzghpb/BOSBlKseDa9/WiLXdmXG4e83m
	e6b/P/MUb38g2JYR+3FdskDXPmGv6PSmLx+nZzb4KbEUZyQaajEXFScCANEBYW10AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 10 Apr 2014 12:46:53 +0100
One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> escreveu:

> > For example, some devices provide standard USB Audio Class, handled by
> > snd-usb-audio for the audio stream, while the video stream is handled
> > via a separate driver, like some em28xx devices.
> 
> Which is what mfd is designed to handle.
> 
> > There are even more complex devices that provide 3G modem, storage
> > and digital TV, whose USB ID changes when either the 3G modem starts
> > or when the digital TV firmware is loaded.
> 
> But presumably you only have one driver at a time then ?

In this specific device, before USB ID changes, only storage is
available, as it contains the manufacturer's Windows driver on it
(and the device firmware).

After the USB ID changes and after the 3G chip manufacturer is 
recognized (if the device is locked to an specific 3G carrier), 
the USB storage switches to work as a micro SD memory reader
and the TV and 3G modem functions also become available.

The Kernel drivers that are used by this device are:

smsdvb                 18471  0 
dvb_core              114974  1 smsdvb
option                 42468  0 
smsusb                 17819  0 
usb_wwan               19510  1 option
smsmdtv                52283  2 smsdvb,smsusb
rc_core                27210  1 smsmdtv
usb_storage            56690  0 

Those are the logs:

[210431.241488] usb 1-1.3: new high-speed USB device number 7 using ehci-pci
[210431.340676] usb 1-1.3: New USB device found, idVendor=19d2, idProduct=2000
[210431.340683] usb 1-1.3: New USB device strings: Mfr=3, Product=2, SerialNumber=4
[210431.340687] usb 1-1.3: Product: ZTE WCDMA Technologies MSM
[210431.340691] usb 1-1.3: Manufacturer: ZTE,Incorporated
[210431.340695] usb 1-1.3: SerialNumber: P675B1ZTED010000
[210431.344778] usb-storage 1-1.3:1.0: USB Mass Storage device detected
[210431.344891] scsi10 : usb-storage 1-1.3:1.0
[210432.701801] usb 1-1.3: USB disconnect, device number 7
[210438.735217] usb 1-1.3: new high-speed USB device number 8 using ehci-pci
[210438.834309] usb 1-1.3: New USB device found, idVendor=19d2, idProduct=0086
[210438.834314] usb 1-1.3: New USB device strings: Mfr=3, Product=2, SerialNumber=4
[210438.834317] usb 1-1.3: Product: ZTE WCDMA Technologies MSM
[210438.834319] usb 1-1.3: Manufacturer: ZTE,Incorporated
[210438.834321] usb 1-1.3: SerialNumber: P675B1ZTED010000
[210438.839042] option 1-1.3:1.0: GSM modem (1-port) converter detected
[210438.839369] usb 1-1.3: GSM modem (1-port) converter now attached to ttyUSB1
[210438.839566] option 1-1.3:1.1: GSM modem (1-port) converter detected
[210438.839749] usb 1-1.3: GSM modem (1-port) converter now attached to ttyUSB2
[210438.839880] usb-storage 1-1.3:1.2: USB Mass Storage device detected
[210438.840116] scsi11 : usb-storage 1-1.3:1.2
[210438.840407] option 1-1.3:1.3: GSM modem (1-port) converter detected
[210438.840593] usb 1-1.3: GSM modem (1-port) converter now attached to ttyUSB3
[210438.840811] option 1-1.3:1.4: GSM modem (1-port) converter detected
[210438.840961] usb 1-1.3: GSM modem (1-port) converter now attached to ttyUSB4
[210439.844891] scsi 11:0:0:0: Direct-Access     ZTE      MMC Storage      2.31 PQ: 0 ANSI: 2
[210439.845516] sd 11:0:0:0: Attached scsi generic sg4 type 0
[210439.854702] sd 11:0:0:0: [sdd] Attached SCSI removable disk
[210449.269010] smscore_detect_mode: line: 1274: MSG_SMS_GET_VERSION_EX_REQ failed first try
[210454.266114] smscore_set_device_mode: line: 1354: mode detect failed -62
[210454.266121] smsusb_init_device: line: 436: smscore_start_device(...) failed
[210454.266371] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.266618] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.266855] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.267090] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.267341] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.267593] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.267868] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.268106] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.268340] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.268609] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[210454.268625] sms_ir_exit: 
[210454.274338] smsusb: probe of 1-1.3:1.5 failed with error -62
[210454.274413] option 1-1.3:1.5: GSM modem (1-port) converter detected
[210454.274768] usb 1-1.3: GSM modem (1-port) converter now attached to ttyUSB5
[210454.310745] sd 11:0:0:0: [sdd] 7744512 512-byte logical blocks: (3.96 GB/3.69 GiB)
[210454.316753] sd 11:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[210454.334348]  sdd: sdd1
[210455.709432] EXT4-fs (sdd1): mounting ext3 file system using the ext4 subsystem

> > So, we need to find a way to lock some hardware resources among
> > different subsystems that don't share anything in common. Not sure if
> > mfd has the same type of problem of a non-mfd driver using another
> > function of the same device
> 
> The MFD device provides subdevices for all the functions. That is the
> whole underlying concept.

I'll take a look on how it works, and how it locks resources on
other drivers. What drivers outside drivers/mfd use shared resources
that require locks controlled by mfd?

-- 

Regards,
Mauro
