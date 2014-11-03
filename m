Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaKCNam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:30:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaKCNak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:30:40 -0500
Date: Mon, 3 Nov 2014 14:30:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Wu <alan.c.wu@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Surface Pro 3 Type Cover 3
In-Reply-To: <1414770520-4125-1-git-send-email-alan.c.wu@gmail.com>
Message-ID: <alpine.LNX.2.00.1411031429500.19451@pobox.suse.cz>
References: <1414770520-4125-1-git-send-email-alan.c.wu@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Alan Wu wrote:

> From: alanwu <alan.c.wu@gmail.com>
> 
> Surface Pro 3 Type Cover that works with Ubuntu (and possibly Arch) from this thread. Both trackpad and keyboard work after compiling my own kernel.
> http://ubuntuforums.org/showthread.php?t=2231207&page=2&s=44910e0c56047e4f93dfd9fea58121ef
> 
> Signed-off-by: alanwu <alan.c.wu@gmail.com>

Hi Alan,

thanks for the patch.

For driver binding to work reliably and correctly, you also need to add 
the device to hid_have_special_driver[] array in drivers/hid/hid-core.c.

Could you please fix that up and resend the patch?

> ---
>  drivers/hid/hid-ids.h       | 1 +
>  drivers/hid/hid-microsoft.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index e23ab8b..15f32c2 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -648,6 +648,7 @@
>  #define USB_DEVICE_ID_MS_SURFACE_PRO_2   0x0799
>  #define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
>  #define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
> +#define USB_DEVICE_ID_MS_TYPE_COVER_3    0x07dc
> 
>  #define USB_VENDOR_ID_MOJO		0x8282
>  #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
> diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
> index 8ba17a9..cacda43 100644
> --- a/drivers/hid/hid-microsoft.c
> +++ b/drivers/hid/hid-microsoft.c
> @@ -274,6 +274,8 @@ static const struct hid_device_id ms_devices[] = {
> 		.driver_data = MS_NOGET },
> 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500),
> 		.driver_data = MS_DUPLICATE_USAGES },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_3),
> +		.driver_data = MS_HIDINPUT },
> 
> 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT),
> 		.driver_data = MS_PRESENTER },
> --
> 2.1.0
> 

-- 
Jiri Kosina
SUSE Labs
