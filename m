Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3AMUk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 15:40:28 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37469 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3AMUk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 15:40:26 -0500
Message-ID: <50F329C4.8030308@qdot.me>
Date: Sun, 13 Jan 2013 22:40:20 +0100
From: Tomasz Mloduchowski <q@qdot.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121113 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Crucible Technologies COMET Caller ID - pid added.
References: <CAEpun2ZA-JKsrtGbajBX7nOo=uacitAvnC5gSKiNJJe5bfDLSg@mail.gmail.com> <20130113192504.GA15331@kroah.com>
In-Reply-To: <20130113192504.GA15331@kroah.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/13 20:25, Greg KH wrote:
> On Sun, Jan 13, 2013 at 07:20:27PM +0100, Tomasz Mloduchowski wrote:
>> From: Tomasz Mloduchowski <q@qdot.me>
>>
>> Simple fix to add support for Crucible Technologies COMET Caller ID
>> USB decoder - a device containing FTDI USB/Serial converter chip,
>> handling 1200bps CallerID messages decoded from the phone line -
>> adding correct USB PID is sufficient.
>>
>> Tested to apply cleanly and work flawlessly against 3.6.9, 3.7.0-rc8
>> and 3.8.0-rc3 on both amd64 and x86 arches.
>>
>> Signed-off-by: Tomasz Mloduchowski <q@qdot.me>
>> ---
>> diff -ur linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c
>> linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c
>> --- linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c    2013-01-13
>> 19:41:28.000000000 +0100
>> +++ linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c 2013-01-13
>> 19:49:27.239874311 +0100
>> @@ -875,6 +875,8 @@
>>         { USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
>>                 .driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
>>         { USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
>> +       /* Crucible Devices */
>> +       { USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
>>         { },                                    /* Optional parameter entry */
>>         { }                                     /* Terminating entry */
>>  };
> 
> The patch is line-wrapped and all of the tabs are converted to spaces,
> both of which are keeping this patch from being able to be applied :(
> 
> Care to fix your email client and resend this so that I can apply it?
> 
> thanks,
> 
> greg k-h
> 


No problem - this should send correctly now .

Best,
Tomasz

diff -ur linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c
--- linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c	2013-01-13 19:41:28.000000000 +0100
+++ linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c	2013-01-13 19:49:27.239874311 +0100
@@ -875,6 +875,8 @@
 	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
+	/* Crucible Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -ur linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio_ids.h linux-3.8-rc3/drivers/usb/serial/ftdi_sio_ids.h
--- linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio_ids.h	2013-01-13 19:41:28.000000000 +0100
+++ linux-3.8-rc3/drivers/usb/serial/ftdi_sio_ids.h	2013-01-13 19:48:24.819996641 +0100
@@ -1259,3 +1259,9 @@
  * ATI command output: Cinterion MC55i
  */
 #define FTDI_CINTERION_MC55I_PID	0xA951
+
+/*
+ * Product: Comet Caller ID decoder
+ * Manufacturer: Crucible Technologies
+ */
+#define FTDI_CT_COMET_PID 0x8e08

