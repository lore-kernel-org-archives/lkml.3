Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3LBONK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:13:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab3LBONH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:13:07 -0500
Date: Mon, 2 Dec 2013 15:13:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Zawullon <zawullon@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: add NOGET quirk and device id for Logitech Dual
 Action gamepads support
In-Reply-To: <5299B520.9060200@gmail.com>
Message-ID: <alpine.LNX.2.00.1312021512460.24931@pobox.suse.cz>
References: <5299B520.9060200@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Zawullon wrote:

> Issue description: I have two Logitech Dual Action gamepads, both have
> same Vendor/Device id pair. Newest gamepad (A) can switch between old mode (HID)
> and XBox gamepad emulation mode. Old gamepad (B) can only work in HID mode.
> In HID mode gamepad A sends many EPIPE errors during initialization and was
> disconnected immediately after connect  to usb port. It works fine in Win and
> Mac. After adding NOGET quirk in driver, it was working properly.
> Gamepad B works fine before and after changes. I tested both gamepads
> with 3.8.0 and 3.11.6 kernels  with modified driver. Follow patch can apply
> for current git kernel version. I can send pcap log from usb bus with both
> gamepads or any other additional information if it is needed
> 

Please provide your Signed-off-by: line so that I could apply the patch. 
Thanks.

> diff -uprN -X linux-git/Documentation/dontdiff linux-git/drivers/hid/hid-ids.h linux-my/drivers/hid/hid-ids.h
> --- linux-git/drivers/hid/hid-ids.h	2013-11-30 13:29:27.937351968 +0400
> +++ linux-my/drivers/hid/hid-ids.h	2013-11-30 13:46:05.201378674 +0400
> @@ -552,6 +552,7 @@
>  #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD_CORD	0xc20a
>  #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD	0xc211
>  #define USB_DEVICE_ID_LOGITECH_EXTREME_3D	0xc215
> +#define USB_DEVICE_ID_LOGITECH_DUAL_ACTION	0xc216
>  #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2	0xc218
>  #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2_2	0xc219
>  #define USB_DEVICE_ID_LOGITECH_WINGMAN_F3D	0xc283
> diff -uprN -X linux-git/Documentation/dontdiff linux-git/drivers/hid/hid-lg.c linux-my/drivers/hid/hid-lg.c
> --- linux-git/drivers/hid/hid-lg.c	2013-11-30 13:29:27.937351968 +0400
> +++ linux-my/drivers/hid/hid-lg.c	2013-11-30 13:46:05.201378674 +0400
> @@ -758,6 +758,8 @@ static const struct hid_device_id lg_dev
>  
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_EXTREME_3D),
>  		.driver_data = LG_NOGET },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_DUAL_ACTION),
> +		.driver_data = LG_NOGET },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WHEEL),
>  		.driver_data = LG_NOGET | LG_FF4 },
>  
> 

-- 
Jiri Kosina
SUSE Labs
