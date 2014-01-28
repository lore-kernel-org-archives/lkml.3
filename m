Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaA1PLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:11:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbaA1PLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:11:47 -0500
Date: Tue, 28 Jan 2014 16:11:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Yufeng Shen <miletus@chromium.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, adlr@chromium.org
Subject: Re: [PATCH] HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay
In-Reply-To: <1390863766-14491-1-git-send-email-miletus@chromium.org>
Message-ID: <alpine.LNX.2.00.1401281611320.3763@pobox.suse.cz>
References: <1390863766-14491-1-git-send-email-miletus@chromium.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Yufeng Shen wrote:

> There is timeout error during initialization:
> kernel: [   11.733104] hid-multitouch 0003:1870:0110.0001: usb_submit_urb(ctrl) failed: -1
> kernel: [   11.734093] hid-multitouch 0003:1870:0110.0001: timeout initializing reports
> 
> Adding quirk HID_QUIRK_NO_INIT_REPORTS can solve the problem.
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>

Applied.

> ---
>  drivers/hid/hid-ids.h           | 1 +
>  drivers/hid/usbhid/hid-quirks.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index f9304cb..ece2997 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -636,6 +636,7 @@
>  
>  #define USB_VENDOR_ID_NEXIO		0x1870
>  #define USB_DEVICE_ID_NEXIO_MULTITOUCH_420	0x010d
> +#define USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750	0x0110
>  
>  #define USB_VENDOR_ID_NEXTWINDOW	0x1926
>  #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 0db9a67..be5270a 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -74,6 +74,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
> +	{ USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
> -- 
> 1.8.5.3
> 

-- 
Jiri Kosina
SUSE Labs
