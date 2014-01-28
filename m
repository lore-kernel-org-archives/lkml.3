Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaA1C5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:57:38 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56061 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaA1C5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <1390863766-14491-1-git-send-email-miletus@chromium.org>
References: <1390863766-14491-1-git-send-email-miletus@chromium.org>
Date: Mon, 27 Jan 2014 21:57:33 -0500
Message-ID: <CAN+gG=F3EQ4o99HW3Qid52_Kp1g-yziW1yeNetP5mE9DmEmS2w@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-input <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Andrew de los Reyes <adlr@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 27, 2014 at 6:02 PM, Yufeng Shen <miletus@chromium.org> wrote:
> There is timeout error during initialization:
> kernel: [   11.733104] hid-multitouch 0003:1870:0110.0001: usb_submit_urb(ctrl) failed: -1
> kernel: [   11.734093] hid-multitouch 0003:1870:0110.0001: timeout initializing reports
>
> Adding quirk HID_QUIRK_NO_INIT_REPORTS can solve the problem.

Could you please test the quirk HID_QUIRK_NO_INIT_INPUT_REPORTS instead?
The patch is perfectly fine, but usually when it fails, only the input
reports are non-readable, whereas features should. This way, you will
still get the value of the features, which _may_ be sensible for the
maxcontact information.

BTW, HID_QUIRK_NO_INIT_INPUT_REPORTS has been introduced in v3.12 and
is the default for Win 8 certified devices.

Cheers,
Benjamin

>
> Signed-off-by: Yufeng Shen <miletus@chromium.org>
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
>  #define USB_VENDOR_ID_NEXIO            0x1870
>  #define USB_DEVICE_ID_NEXIO_MULTITOUCH_420     0x010d
> +#define USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750 0x0110
>
>  #define USB_VENDOR_ID_NEXTWINDOW       0x1926
>  #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN   0x0003
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 0db9a67..be5270a 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -74,6 +74,7 @@ static const struct hid_blacklist {
>         { USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
>         { USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
>         { USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GX680R_LED_PANEL, HID_QUIRK_NO_INIT_REPORTS },
> +       { USB_VENDOR_ID_NEXIO, USB_DEVICE_ID_NEXIO_MULTITOUCH_PTI0750, HID_QUIRK_NO_INIT_REPORTS },
>         { USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_MOUSE, HID_QUIRK_NO_INIT_REPORTS },
>         { USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
>         { USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
> --
> 1.8.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
