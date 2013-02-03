Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab3BCAa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 19:30:28 -0500
Received: from host171.canaca.com ([67.55.55.225]:34257 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3BCAaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 19:30:25 -0500
Message-ID: <eda86cfd7fd3f5878ef00e3e8a9de1c6.squirrel@www.mungewell.org>
In-Reply-To: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
References: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
Date: Sat, 2 Feb 2013 19:30:23 -0500
Subject: Re: [PATCH 1/3] hid: Add report descriptor for Logitech Driving
 Force wheel
From: simon@mungewell.org
To: "Paul Sbarra" <sbarra.paul@gmail.com>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul Sbarra" <sbarra.paul@gmail.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20130202193023_42180"
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

------=_20130202193023_42180
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> This is the original report descriptor as reported by lsusb -vd 046d:c294.
>
> Signed-off-by: Paul Sbarra <sbarra.paul@gmail.com>
> ---
>  drivers/hid/hid-lg.c | 84
> ++++++++++++++++++++++++++++++++++++++++++++++++----

>  	switch (hdev->product) {
> +	case USB_DEVICE_ID_LOGITECH_WHEEL:
> +		if (*rsize == DF_RDESC_ORIG_SIZE) {
> +			hid_info(hdev,
> +				"fixing up Logitech Driving Force report descriptor\n");
> +			rdesc = df_rdesc_fixed;
> +			*rsize = sizeof(df_rdesc_fixed);
> +		}
> +		break;
> +
>  	case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
>  		if (*rsize == DFP_RDESC_ORIG_SIZE) {
>  			hid_info(hdev,
> --


Hi Paul,
I'm not following as to why you are patching the descriptor for the DFP,
my understanding is that this is fully supported at the moment (as
USB_DEVICE_ID_LOGITECH_DFP_WHEEL in the line after your patch).

Perhaps you have a different revision. Can you please forward a 'lsusb
-vv' to we can compare.

I have attached the one from my DPF.
--
simon@selkie:~/speed-dreams-2.0$ lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 003: ID 5986:01a6 Acer, Inc Lenovo Integrated Webcam
Bus 003 Device 002: ID 0a5c:217f Broadcom Corp. Bluetooth Controller
Bus 003 Device 003: ID 046d:c294 Logitech, Inc. Driving Force
--

Thanks,
Simon.
------=_20130202193023_42180
Content-Type: text/plain; name="lsusb_vv.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="lsusb_vv.txt"

Bus 003 Device 003: ID 046d:c294 Logitech, Inc. Driving Force
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
  iManufacturer           3 
  iProduct                1 
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
------=_20130202193023_42180--


