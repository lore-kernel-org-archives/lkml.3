Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3H1Nez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:34:55 -0400
Received: from smtp-pa1a.enomia.com ([64.128.160.11]:12113 "EHLO
	smtp1.enomia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3H1Ney (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:34:54 -0400
Message-ID: <521DFC94.4050106@uplogix.com>
Date: Wed, 28 Aug 2013 08:35:16 -0500
From: David Barksdale <dbarksdale@uplogix.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH RESEND] HID: New hid-cp2112 driver.
References: <1377615715-25699-1-git-send-email-dbarksdale@uplogix.com> <alpine.LNX.2.00.1308281455350.4557@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1308281455350.4557@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [209.163.150.140]
X-OriginalArrivalTime: 28 Aug 2013 13:34:52.0814 (UTC) FILETIME=[60499AE0:01CEA3F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 07:57 AM, Jiri Kosina wrote:
>
 > [ adding Benjamin to CC ]
 >
 > On Tue, 27 Aug 2013, David Barksdale wrote:
 >
 >> This patch adds support for the Silicon Labs CP2112 "Single-Chip
 >> HID USB to SMBus Master Bridge."
 >>
 >> I wrote this to support a USB temperature and humidity sensor I've
 >> been working on. It's been tested by using SMBus byte-read,
 >> byte-data-read/write, and word-data-read transfer modes to talk to
 >> an I2C sensor. The other transfer modes have not been tested.
 >>
 >> Signed-off-by: David Barksdale <dbarksdale@uplogix.com>
 >>
 >> --- drivers/hid/Kconfig      |   6 + drivers/hid/Makefile     |
 >> 1 + drivers/hid/hid-core.c   |   3 + drivers/hid/hid-cp2112.c |
 >> 504 +++++++++++++++++++++++++++++++++++++++++++++++ 4 files
 >> changed, 514 insertions(+)
 >>
 >> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig index
 >> 14ef6ab..1833948 100644 --- a/drivers/hid/Kconfig +++
 >> b/drivers/hid/Kconfig @@ -175,6 +175,12 @@ config HID_PRODIKEYS
 >> multimedia keyboard, but will lack support for the musical keyboard
 >> and some additional multimedia keys.
 >>
 >> +config HID_CP2112 +    tristate "Silicon Labs CP2112 HID
 >> USB-to-SMBus Bridge support" +    depends on USB_HID +
 >> ---help--- +    Support for Silicon Labs CP2112 HID USB to SMBus
 >> Master Bridge. +
 >
 > Hi David,
 >
 > this is rather difficult to get by quickly looking at the code, so
 > I'd like to have a slightly better overview of what the device
 > really is.
 >
 > Is it talking HID protocol on the SMBus? (if so, there is a hid-i2c
 > transport driver for it already). But I guess this is not really the
 > case, as you seem to be using the USB HID functionality as well.
 >
 > Thanks in advance for some more background.
 >

The CP2112 is a USB HID device that provides an SMBus controller.
The datasheet can be found here: 
http://www.silabs.com/Support%20Documents/TechnicalDocs/CP2112.pdf
The interface specification here: 
http://www.silabs.com/Support%20Documents/TechnicalDocs/AN495.pdf
The host communicates with the CP2112 via HID reports. Device 
configuration uses feature reports and data transfer uses output and 
event reports.
I prototyped this in userspace using the /dev/hidraw interface and then 
wrote this driver to provide a real i2c adapter device.
