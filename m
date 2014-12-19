Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaLSG7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:59:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:65297 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaLSG7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:59:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,605,1413270000"; 
   d="scan'208";a="626422986"
From: "Du, Changbin" <changbin.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [DISCUSSION] USB device remote wakeup is not working for S3 case
Thread-Topic: [DISCUSSION] USB device remote wakeup is not working for S3
 case
Thread-Index: AdAaujexwQVjoEsORCWW3pR7AJbQmf//tgsA//6C/XA=
Date: Fri, 19 Dec 2014 06:55:55 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01C42A57@SHSMSX103.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A01C428B4@SHSMSX103.ccr.corp.intel.com>
 <Pine.LNX.4.44L0.1412181028510.1745-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1412181028510.1745-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's a simple solution: Call device_set_wakeup_enable() for the device!
> You can do this from the command line by:
> 
> 	echo auto >/sys/bus/usb/devices/.../power/control
> 
> where the "..." is the pathname for your device.
> 
Yes, this can enable auto-suspend for usb device like a mouse. And remote wakeup
does work for RPM because rpm suspend refers to the needs_remote_wakeup flag.
But this doesn't impact system level suspend. The correct thing is:
	
	echo enabled >/sys/bus/usb/devices/.../power/wakeup

This will call device_set_wakeup_enable() for the device and should work. But 
unfortunately it seems didn't work even the wakeup file shows "enabled" which 
means the device is wakeup enabled(Tried on 3.16 & 3.18 kernel). This is a different
issue, I will check.

> 	if (interface->desc.bInterfaceSubClass ==
> USB_INTERFACE_SUBCLASS_BOOT &&
> 			interface->desc.bInterfaceProtocol ==
> 				USB_INTERFACE_PROTOCOL_KEYBOARD) {
> 		usbhid_set_leds(hid);
> 		device_set_wakeup_enable(&dev->dev, 1);
> 	}
> 
> How about leaving everything the way it is now?  If you want to enable
> wakeup for something like a USB mouse, you can write a udev script to do it
> as shown above.
> 
> Alan Stern

Could we also enable wakeup for usb mouse? Or is there any concern to enable it?
Per my opinion, most people may expect clicking mouse can awake system.

Regards,
Du, Changbin
