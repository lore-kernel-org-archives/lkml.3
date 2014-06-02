Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaFBJKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:10:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbaFBJKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:10:17 -0400
Date: Mon, 2 Jun 2014 11:10:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Kamil Kozar <dkk089@gmail.com>
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] usbhid : enable NO_INIT_REPORTS quirk for Semico USB
 Keykoard
In-Reply-To: <alpine.LNX.2.03.1406011314180.11405@gmail.com>
Message-ID: <alpine.LNX.2.00.1406021108570.11302@pobox.suse.cz>
References: <alpine.LNX.2.03.1406011314180.11405@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2014, Daniel Kamil Kozar wrote:

> The device which identifies itself as a "USB Keykoard" (no typo) with 
> VID:PID 1a2c:0023 does not seem to be handling the reports initialization 
> very well. This results in a "usb_submit_urb(ctrl) failed: -1" message 
> from the kernel when connected, and a delay before its initialization. 
> This patch adds the quirk for this device, which causes the delay to 
> disappear.
> Signed-off-by: Daniel Kamil Kozar <dkk089@gmail.com>

Please always add an empty line between the changelog and a signoff.

> ---
> diff -uprN -X linux-3.15-rc7/Documentation/dontdiff linux-3.15-rc7/drivers/hid/hid-ids.h linux-3.15-rc7-mine/drivers/hid/hid-ids.h
> --- linux-3.15-rc7/drivers/hid/hid-ids.h	2014-05-26 01:06:00.000000000 +0200
> +++ linux-3.15-rc7-mine/drivers/hid/hid-ids.h	2014-06-01 12:30:45.910903449 +0200
> @@ -769,6 +769,10 @@
>  #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
>  #define USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE	0x0600
>  
> +/* China Resource Semico Co., Ltd */

We're not putting such comments there.

> +#define USB_VENDOR_ID_SEMICO			0x1a2c
> +#define USB_DEVICE_ID_SEMICO_USB_KEYKOARD	0x0023
> +
>  #define USB_VENDOR_ID_SENNHEISER	0x1395
>  #define USB_DEVICE_ID_SENNHEISER_BTD500USB	0x002c
>  
> diff -uprN -X linux-3.15-rc7/Documentation/dontdiff linux-3.15-rc7/drivers/hid/usbhid/hid-quirks.c linux-3.15-rc7-mine/drivers/hid/usbhid/hid-quirks.c
> --- linux-3.15-rc7/drivers/hid/usbhid/hid-quirks.c	2014-05-26 01:06:00.000000000 +0200
> +++ linux-3.15-rc7-mine/drivers/hid/usbhid/hid-quirks.c	2014-06-01 12:32:01.161744987 +0200
> @@ -120,6 +120,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_HD, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_QUAD_HD, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_TP_V103, HID_QUIRK_NO_INIT_REPORTS },
> +	{ USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD, HID_QUIRK_NO_INIT_REPORTS },

The list ought to be kept sorted.

These were trivial to fix, so I have fixed it and applied, but please keep 
that in mind for your future patch submissions.

Thanks,

-- 
Jiri Kosina
SUSE Labs
