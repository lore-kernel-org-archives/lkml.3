Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3D2IR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:17:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3D2IRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:17:55 -0400
Date: Mon, 29 Apr 2013 10:17:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Adam Jiang <jiang.adam@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: Add PID for Japanese version of NE4K keyboard
In-Reply-To: <1367209651-14405-1-git-send-email-jiang.adam@gmail.com>
Message-ID: <alpine.LNX.2.00.1304291017470.17743@pobox.suse.cz>
References: <1367209651-14405-1-git-send-email-jiang.adam@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Adam Jiang wrote:

> This patche adds PID of Japanese Natual Ergonomic Keyboard 4000. HID
> NE4K driver depends on this PID for determining its quirks. F14-F18 keys
> would not work without the patch.
> 
> Signed-off-by: Adam Jiang <jiang.adam@gmail.com>
> ---
>  drivers/hid/hid-core.c      | 1 +
>  drivers/hid/hid-ids.h       | 1 +
>  drivers/hid/hid-microsoft.c | 2 ++
>  3 files changed, 4 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index aa341d1..b587b42 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1654,6 +1654,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K_JP) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_LK6K) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 5309fd5..f909603 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -577,6 +577,7 @@
>  #define USB_DEVICE_ID_SIDEWINDER_GV	0x003b
>  #define USB_DEVICE_ID_WIRELESS_OPTICAL_DESKTOP_3_0 0x009d
>  #define USB_DEVICE_ID_MS_NE4K		0x00db
> +#define USB_DEVICE_ID_MS_NE4K_JP	0x00dc
>  #define USB_DEVICE_ID_MS_LK6K		0x00f9
>  #define USB_DEVICE_ID_MS_PRESENTER_8K_BT	0x0701
>  #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
> diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
> index 29d27f6..551795b 100644
> --- a/drivers/hid/hid-microsoft.c
> +++ b/drivers/hid/hid-microsoft.c
> @@ -195,6 +195,8 @@ static const struct hid_device_id ms_devices[] = {
>  		.driver_data = MS_HIDINPUT },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K),
>  		.driver_data = MS_ERGONOMY },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K_JP),
> +		.driver_data = MS_ERGONOMY },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_LK6K),
>  		.driver_data = MS_ERGONOMY | MS_RDESC },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_USB),

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
